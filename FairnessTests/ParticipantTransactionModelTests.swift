import XCTest

class ParticipantTransactionModelTests: XCTestCase {

    let participant = Participant(name: "name")
    var sut: ParticipantTransactionModel!

    override func setUp() {

        participant.balance = 10
        sut = ParticipantTransactionModel(participant: participant)
    }

    func testAmountStringForNegativeAmount() {

        sut.maybeAmount = -1.23
        XCTAssertEqual(sut.toViewModel().amountString, "10.00 -1.23")
    }

    func testAmountStringForPositiveAmount() {

        sut.maybeAmount = 1.23
        XCTAssertEqual(sut.toViewModel().amountString, "10.00 +1.23")
    }

    func testNameOfViewModelEqualsNameOfParticipant() {

        XCTAssertEqual(sut.toViewModel().name, "name")
    }

    func testNameLessParticipantResultsInEmptyNameString() {

        participant.name = nil
        XCTAssertEqual(sut.toViewModel().name, "")
    }
}
