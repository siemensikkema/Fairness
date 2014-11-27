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
        XCTAssertEqual(sut.toViewModel().amountString, "10.00 -1.23")
    }

    func testAmountStringForPositiveAmount() {

        sut.amountOrNil = 1.23
        XCTAssertEqual(sut.toViewModel().amountString, "10.00 +1.23")
    }

    func testNameOfViewModelEqualsNameOfParticipant() {

        XCTAssertEqual(sut.toViewModel().nameOrNil!, "name")
    }

    func testNamelessParticipantResultsInNilString() {

        participant.nameOrNil = nil
        XCTAssertNil(sut.toViewModel().nameOrNil)
    }
}
