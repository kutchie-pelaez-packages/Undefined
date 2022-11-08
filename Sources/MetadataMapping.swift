import Logging

private let logger = Logger(label: "Undefined")

func log(message: String, with metadata: [String: Any]?, _ file: String, _ function: String, _ line: UInt) {
    logger.critical(
        "\(message)", metadata: metadata.map(loggerMetadata),
        file: file, function: function, line: line
    )
}

private func loggerMetadata(from dictionary: [String: Any]) -> Logger.Metadata {
    var unsupportedValues = [KeyValuePairs<String?, Any>]()
    var metadata = Logger.Metadata()
    for (key, value) in dictionary {
        let (metadataValue, mappedUnsupportedValues) = mapKeyValue(key: key, value: value)

        metadata[key] = metadataValue
        unsupportedValues += mappedUnsupportedValues
    }
    if !unsupportedValues.isEmpty {
        metadata["unsupportedValues"] = mapUnsupportedValues(unsupportedValues)
    }

    return metadata
}

private func mapKeyValue(key: String?, value: Any) -> (Logger.MetadataValue?, [KeyValuePairs<String?, Any>]) {
    switch value {
    case let dictionary as [String: Any]:
        var metadata = Logger.Metadata()
        var unsupportedValues = [KeyValuePairs<String?, Any>]()
        for (dictionaryKey, dictionaryValue) in dictionary {
            let (mappedMetadataValue, mappedUnsupportedValues) = mapKeyValue(key: dictionaryKey, value: dictionaryValue)
            metadata[dictionaryKey] = mappedMetadataValue
            unsupportedValues.append(contentsOf: mappedUnsupportedValues)
        }

        return (unsupportedValues.isEmpty ? nil : .dictionary(metadata), unsupportedValues)

    case let array as [Any]:
        var metadataValues = [Logger.MetadataValue]()
        var unsupportedValues = [KeyValuePairs<String?, Any>]()
        for arrayValue in array {
            let (mappedMetadataValue, mappedUnsupportedValues) = mapKeyValue(key: nil, value: arrayValue)
            metadataValues += [mappedMetadataValue].compactMap { $0 }
            unsupportedValues.append(contentsOf: mappedUnsupportedValues)
        }

        return (metadataValues.isEmpty ? nil : .array(metadataValues), unsupportedValues)

    case let string as String:
        return (.string(string), [])

    case let stringConvertible as CustomStringConvertible:
        return (.stringConvertible(stringConvertible), [])

    default:
        return (nil, [[key: "\(value)"]])
    }
}

private func mapUnsupportedValues(_ unsupportedValues: [KeyValuePairs<String?, Any>]) -> Logger.MetadataValue {
    let keys = unsupportedValues.map { $0[0].key }
    let keysCount = keys.compactMap({ $0 }).count
    let values = unsupportedValues.map { $0[0].value }

    if keysCount == values.count {
        let uniqueKeysWithValues = keys.enumerated().map { ($1!, mapUnsupportedValue(values[$0])) }
        return .dictionary(Dictionary(uniqueKeysWithValues: uniqueKeysWithValues))
    } else if keysCount == 0 {
        return .array(values.map(mapUnsupportedValue))
    } else {
        var keyedValues = Logger.Metadata()
        var unkeyedValues = [Logger.MetadataValue]()
        keys.enumerated().forEach { index, key in
            let metadataValue = mapUnsupportedValue(values[index])
            if let key {
                keyedValues[key] = metadataValue
            } else {
                unkeyedValues.append(metadataValue)
            }
        }
        keyedValues["unkeyed"] = .array(unkeyedValues)

        return .dictionary(keyedValues)
    }
}

private func mapUnsupportedValue(_ unsupportedValue: Any) -> Logger.MetadataValue {
    switch unsupportedValue {
    case let dictionary as [String: Any]:
        return .dictionary(dictionary.mapValues(mapUnsupportedValue))

    case let array as [Any]:
        return .array(array.map(mapUnsupportedValue))

    case let string as String:
        return .string(string)

    default:
        fatalError()
    }
}
