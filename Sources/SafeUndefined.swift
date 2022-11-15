public func safeUndefined(
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) {
    let message = message()
    log(message: message, with: metadata(), file, function, line)
    assertionFailure(message)
}

public func safeUndefined<T>(
    _ value: @autoclosure () -> T,
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    safeUndefined(
        message: message(), metadata: metadata(),
        file: file, function: function, line: line
    )

    return value()
}

public func safeUndefinedIf<T>(
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

    return safeUndefined(
        value(), message: message(), metadata: metadata(),
        file: file, function: function, line: line
    )
}

public func safeUndefinedIfNil<T>(
    _ value: @autoclosure () -> T?,
    fallback: @autoclosure () -> T,
    message: @autoclosure () -> String,
    metadata: @autoclosure () -> [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard let value = value() else {
        return safeUndefined(
            fallback(), message: message(), metadata: metadata(),
            file: file, function: function, line: line
        )
    }

    return value
}
