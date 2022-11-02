public func undefined(
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> Never {
    let message = message()
    log(
        message: message, metadata: metadata,
        file: file, function: function, line: line
    )
    fatalError(message)
}

public func undefined<T>(
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    let _: Never = undefined(
        message: message(), metadata: metadata,
        file: file, function: function, line: line
    )
}

public func undefinedIf<T>(
    _ condition: @autoclosure () -> Bool,
    fallback: @autoclosure () -> T,
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard condition() else {
        return fallback()
    }

    return undefined(
        message: message(), metadata: metadata,
        file: file, function: function, line: line
    )
}

public func undefinedIfNil<T>(
    _ value: @autoclosure () -> T?,
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard let value = value() else {
        return undefined(
            message: message(), metadata: metadata,
            file: file, function: function, line: line
        )
    }

    return value
}
