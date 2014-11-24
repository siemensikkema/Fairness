import XCTest
import UIKit

class TransactionEntryViewControllerTests: XCTestCase {

    var accessoryToolbar: UIToolbar!
    var addParticipantButton: UIBarButtonItem!
    var costTextField: UITextField!
    var sut: TransactionEntryViewController!

    override func setUp() {

        sut = TransactionEntryViewController()
        costTextField = UITextField()
        sut.costTextField = costTextField
        accessoryToolbar = UIToolbar()
        sut.accessoryToolbar = accessoryToolbar
        sut.viewDidLoad()
        addParticipantButton = UIBarButtonItem()
        sut.addParticipantButton = addParticipantButton
    }
}

extension TransactionEntryViewControllerTests {

    func testCostTextFieldInputAccessoryViewIsSet() {

        XCTAssertEqual(costTextField.inputAccessoryView!, sut.accessoryToolbar)
    }

    func testEditButtonIsAddedTo() {

        XCTAssertEqual(sut.navigationItem.leftBarButtonItem!, sut.editButtonItem())
    }

    func testLeftBarButtonItemIsEmptyWhenNotInEditMode() {

        sut.editing = false
        XCTAssertNil(sut.navigationItem.rightBarButtonItem)
    }

    func testAddParticipantButtonIsAddedToNavigationItemWhenInEditMode() {

        sut.editing = true
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem!, sut.addParticipantButton)
    }
}