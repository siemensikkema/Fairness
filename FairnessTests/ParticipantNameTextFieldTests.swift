import XCTest
import UIKit

class ParticipantNameTextFieldTests: XCTestCase {

    var sut: ParticipantNameTextField!

    override func setUp() {

        sut = ParticipantNameTextField()
    }

    func testBecomeFirstResponder() {

        sut.becomeFirstResponder()
        XCTAssertTrue(sut.userInteractionEnabled)
        XCTAssertEqual(sut.borderStyle, UITextBorderStyle.RoundedRect)
    }

    func testResignFirstResponder() {

        sut.resignFirstResponder()
        XCTAssertFalse(sut.userInteractionEnabled)
        XCTAssertEqual(sut.borderStyle, UITextBorderStyle.None)
    }
}