func isRunningTests() -> Bool {

    return NSProcessInfo.processInfo().environment["XCInjectBundle"] != nil
}