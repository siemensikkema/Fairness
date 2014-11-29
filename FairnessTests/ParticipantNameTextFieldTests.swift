import XCTest
import UIKit

class ParticipantNameTextFieldTests: XCTestCase {

    var sut: ParticipantNameTextField!

    override func setUp() {

        sut = ParticipantNameTextField()
    }

    func testEnableEditing() {

        sut.enableEditing(true)
        XCTAssertTrue(sut.userInteractionEnabled)
        XCTAssertEqual(sut.borderStyle, UITextBorderStyle.RoundedRect)
    }

    func testDisableEditing() {

        sut.enableEditing(false)
        XCTAssertFalse(sut.userInteractionEnabled)
        XCTAssertEqual(sut.borderStyle, UITextBorderStyle.None)
    }
}