import XCTest

class BalanceFormatterTests: XCTestCase {

    let sut = BalanceFormatter()

    func testCurrencyPropertiesAreSet() {

        XCTAssertEqual(sut.numberStyle, NSNumberFormatterStyle.CurrencyStyle)
    }

    func testCurrencySymbolIsAbsent() {

        XCTAssertEqual(sut.currencySymbol!, "")
    }
}