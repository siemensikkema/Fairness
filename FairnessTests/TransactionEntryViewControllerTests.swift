import XCTest
import UIKit

class TransactionEntryViewControllerTests: XCTestCase {

    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: TransactionEntryViewControllerTests.self))
    var sut: TransactionEntryViewController!

    override func setUp() {

        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        sut = navigationController?.viewControllers.first as? TransactionEntryViewController
        sut.view.hidden = false
    }

    func testA() {

        XCTAssertEqual(sut.costTextField.inputAccessoryView!, sut.accessoryToolbar)
    }
}