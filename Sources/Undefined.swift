public func undefined(
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> Never {
    let message = message()
    log(message: message, with: metadata(), file, function, line)
    fatalError(message)
}

public func undefined<T>(
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    let _: Never = undefined(
        message: message(), metadata: metadata(),
        file: file, function: function, line: line
    )
}

public func undefinedIf<T>(
    _ condition: @autoclosure () -> Bool,
    value: @autoclosure () -> T,
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard condition() else {
        return value()
    }

    return undefined(
        message: message(), metadata: metadata(),
        file: file, function: function, line: line
    )
}

public func undefinedIfNil<T>(
    _ value: @autoclosure () -> T?,
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard let value = value() else {
        return undefined(
            message: message(), metadata: metadata(),
            file: file, function: function, line: line
        )
    }

    return value
}
