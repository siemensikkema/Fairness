import XCTest

class TransactionCalculatorTests: XCTestCase {

    var sut: TransactionCalculator!
    let participantStore = ParticipantStore(participants: [Participant(name: "name1"), Participant(name: "name2")])

    override func setUp() {

        sut = TransactionCalculator(modelDidBecomeInvalidCallback: { participantTransactionModels in }, participantStore: participantStore)
    }
}

extension TransactionCalculatorTests {

    func testNumberOfParticipantTransactionModelsEqualsNumberOfParticipants() {

        XCTAssertEqual(sut.participantTransactionModels.count, 2)
    }

    func testHasPayerReturnsFalseWhenNoParticipantsArePayer() {

        XCTAssertFalse(sut.hasPayer)
    }

    func testHasPayerReturnsTrueWhenOneParticipantsIsPayer() {

        sut.togglePayerAtIndex(0)
        XCTAssertTrue(sut.hasPayer)
    }

    func testTogglePayerTwiceSetsHasPayerStatusToFalse() {

        sut.togglePayerAtIndex(0)
        sut.togglePayerAtIndex(0)
        XCTAssertFalse(sut.hasPayer)
    }
}