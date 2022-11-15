# Undefined

Wrappers around `assertionFailure()` and `fatalError()` with logging using [swift-log](https://github.com/apple/swift-log).

## Usage

This package provides two functions `safeUndefined()` and `undefined()` which are  
simply wrappers around `assertionFailure()` and `fatalError()` respectively. Each call  
logs message with metadata to [swift-log](https://github.com/apple/swift-log)'s `Logger` with label `Undefined`.

Here are different variants available for usage, `file`, `function` and `line` have  
default values as constants; `metadata`'s (of type `[String: Any]`) leafes should conform to  
`CustomStringConvertible` protocol in order to perform mapping to `swift-log`'s `Logger.Metadata`.

### safeUndefined

- `safeUndefined(message:metadata:file:function:line:)`  
Just a wrapper around `assertionFailure()`.

- `safeUndefined<T>(_:message:metadata:file:function:line:) -> T`  
Triggers `assertionFailure()` and returns `value`.

- `safeUndefinedIf(_:message:metadata:file:function:line:)`  
Triggers `assertionFailure()` if `condition` is `true`.

- `safeUndefinedIf<T>(_:value:message:metadata:file:function:line:) -> T`  
Triggers `assertionFailure()` if `condition` is `true` and returns `value`.

- `safeUndefinedIfNil<T>(_:fallback:message:metadata:file:function:line:) -> T`  
Triggers `assertionFailure()` if `value` is `nil` and returns `fallback` or just returns `value`.

### undefined

- `undefined(message:metadata:file:function:line:) -> Never`  
Just a wrapper around `fatalError()`.

- `undefined<T>(message:metadata:file:function:line:) -> T`  
Triggers `fatalError()` with `T` returning signature, can be useful as  placeholder for unimplemented  
properties/methods that requies some value.

- `undefinedIf(_:message:metadata:file:function:line:)`  
Triggers `fatalError()` if `condition` is `true`.

- `undefinedIf<T>(_:value:message:metadata:file:function:line:) -> T`  
Triggers `fatalError()` if `condition` is `true` and returns `value`.

- `undefinedIfNil<T>(_:message:metadata:file:function:line:) -> T`  
Triggers `fatalError()` if `value` is `nil` or returns unwrapped `value`.
