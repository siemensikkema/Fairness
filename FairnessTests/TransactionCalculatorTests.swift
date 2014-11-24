import XCTest

class TransactionCalculatorTests: XCTestCase {

    class ParticipantTransactionModelForTesting: ParticipantTransactionModel {

        var didCallReset = false

        init() {

            super.init(participant: Participant(name: ""))
        }

        override func reset() {

            didCallReset = true
        }
    }

    var sut: TransactionCalculator!
    var participantTransactionModels: [ParticipantTransactionModelForTesting]!

    override func setUp() {

        sut = TransactionCalculator()
        participantTransactionModels = [ParticipantTransactionModelForTesting(), ParticipantTransactionModelForTesting()]
        sut.participantTransactionModels = participantTransactionModels

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

    func testAmounts() {

        XCTAssertEqual(sut.amounts, [1.23,-1.23])
    }

    func testResetSetsCostToZero() {

        sut.reset()
        XCTAssertEqual(sut.cost, 0.0)
    }

    func testResetResetsParticipantViewModels() {

        sut.reset()
        XCTAssertEqual(participantTransactionModels.map { $0.didCallReset }, [true, true])
    }
}