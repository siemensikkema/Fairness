import XCTest

class TransactionCalculatorTests: XCTestCase {

    var sut: TransactionCalculator!
    var participantStore: ParticipantStore!

    override func setUp() {

        participantStore = ParticipantStore(participants: [Participant(name: "name1"), Participant(name: "name2")])
        sut = TransactionCalculator(modelDidBecomeInvalidCallback: { participantTransactionModels in }, participantStore: participantStore)

        sut.togglePayerAtIndex(0)
        sut.togglePayeeAtIndex(1)
        sut.cost = 1.23
    }
}

extension TransactionCalculatorTests {

    func testNumberOfParticipantTransactionModelsEqualsNumberOfParticipants() {

        XCTAssertEqual(sut.participantTransactionModels.count, 2)
    }

    func testHasPayerReturnsTrueWhenOneParticipantsIsPayer() {

        XCTAssertTrue(sut.hasPayer)
    }
    
    func testHasPayerReturnsFalseWhenNoParticipantsArePayer() {

        sut.togglePayerAtIndex(0)
        XCTAssertFalse(sut.hasPayer)
    }

    func testTransactionWithPayerAndPayeeAndNonZeroCostIsValid() {

        XCTAssertTrue(sut.isValid)
    }

    func testTransactionIsInvalidWithoutPayer() {

        sut.togglePayerAtIndex(0)
        XCTAssertFalse(sut.isValid)
    }

    func testTransactionIsInvalidWithoutPayee() {

        sut.togglePayeeAtIndex(1)
        XCTAssertFalse(sut.isValid)
    }

    func testTransactionIsInvalidWithZeroCost() {

        sut.cost = 0
        XCTAssertFalse(sut.isValid)
    }

    func testTransactionIsInvalidWhenPayerIsTheOnlyPayee() {

        sut.togglePayeeAtIndex(0)
        sut.togglePayeeAtIndex(1)
        XCTAssertFalse(sut.isValid)
    }

    func testTransactionIsValidWhenPayerIsOneOfThePayees() {

        sut.togglePayeeAtIndex(0)
        XCTAssertTrue(sut.isValid)
    }

    func testTransactionAmountsForSimpleTransactionAreCorrect() {

        XCTAssertEqual(sut.participantTransactionModels.map { $0.maybeAmount! }, [1.23, -1.23])
    }

    func testTransactionAmountsForSharedTransactionAreCorrect() {

        sut.togglePayeeAtIndex(0)
        XCTAssertEqual(sut.participantTransactionModels.map { $0.maybeAmount! }, [0.615, -0.615])
    }
}