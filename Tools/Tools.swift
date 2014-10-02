
// credits: http://stackoverflow.com/a/25808713
extension NSRange {

    public func toRange(string: String) -> Range<String.Index> {

        let startIndex = advance(string.startIndex, location)
        let endIndex = advance(startIndex, length)
        return startIndex..<endIndex
    }
}