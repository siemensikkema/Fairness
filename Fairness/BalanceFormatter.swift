import Foundation

private let sharedBalanceFormatter = BalanceFormatter()

class BalanceFormatter: NSNumberFormatter {

    class var sharedInstance: BalanceFormatter {

        return sharedBalanceFormatter
    }

    override init() {

        super.init()
        numberStyle = .CurrencyStyle
        currencySymbol = ""
    }

    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}