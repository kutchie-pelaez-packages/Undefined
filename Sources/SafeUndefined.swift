public func safeUndefined(
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) {
    let message = message()
    log(
        message: message, metadata: metadata,
        file: file, function: function, line: line
    )
    assertionFailure(message)
}

public func safeUndefined<T>(
    _ value: T,
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    safeUndefined(
        message: message(), metadata: metadata,
        file: file, function: function, line: line
    )

    return value
}

public func safeUndefinedIf<T>(
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

    return safeUndefined(
        fallback(), message: message(), metadata: metadata,
        file: file, function: function, line: line
    )
}

public func safeUndefinedIfNil<T>(
    _ value: @autoclosure () -> T?,
    fallback: @autoclosure () -> T,
    message: @autoclosure () -> String,
    metadata: [String: Any]? = nil,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
) -> T {
    guard let value = value() else {
        return safeUndefined(
            fallback(), message: message(),
            metadata: metadata,
            file: file, function: function, line: line
        )
    }

    return value
}
