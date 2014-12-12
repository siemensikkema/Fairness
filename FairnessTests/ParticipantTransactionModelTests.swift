import XCTest

class ParticipantTransactionModelTests: XCTestCase {
    let participant = Participant(name: "name")
    var sut: ParticipantTransactionModel!

    override func setUp() {
        participant.balance = 10
        sut = ParticipantTransactionModel(participant: participant)
    }

    func testAmountStringForNegativeAmount() {
        sut.amountOrNil = -1.23
        XCTAssertEqual(sut.amountString, "10.00 -1.23")
    }

    func testAmountStringForPositiveAmount() {
        sut.amountOrNil = 1.23
        XCTAssertEqual(sut.amountString, "10.00 +1.23")
    }

    func testNameOfViewModelEqualsNameOfParticipant() {
        XCTAssertEqual(sut.nameOrNil!, "name")
    }

    func testNamelessParticipantResultsInNilString() {
        participant.nameOrNil = nil
        XCTAssertNil(sut.nameOrNil)
    }

    func testReset() {
        sut.isPayee = true
        sut.isPayer = true
        sut.amountOrNil = 1

        sut.reset()

        XCTAssertFalse(sut.isPayee)
        XCTAssertFalse(sut.isPayer)
        XCTAssertNil(sut.amountOrNil)
    }

    func testNameIsEqualToParticipantName() {
        XCTAssertEqual(sut.nameOrNil!, participant.nameOrNil!)
    }

    func testSettingNameSetsNameOnParticipant() {
        let newName = "new name"
        sut.nameOrNil = newName
        XCTAssertEqual(participant.nameOrNil!, newName)
    }
}
