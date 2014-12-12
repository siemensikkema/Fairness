import XCTest
import UIKit

class TransactionCalculatorControllerTestsBase: XCTestCase {
    class TransactionCalculatorForTesting: TransactionCalculatorInterface {
        var didCallAmounts = false
        var didSetCost = false
        var hasPayerForTesting = false
        var payerIndexForTesting: Int?
        var payeeIndexForTesting: Int?

        var participantTransactionModels: [ParticipantTransactionModel] = []

        var amounts: [Double] {
            didCallAmounts = true
            return []
        }

        var cost: Double = 0.0 {
            didSet { didSetCost = true }
        }

        var isValid = true
        var hasPayer: Bool { return hasPayerForTesting }

        func togglePayerAtIndex(index: Int) { payerIndexForTesting = index }
        func togglePayeeAtIndex(index: Int) { payeeIndexForTesting = index }
    }

    class ParticipantsControllerForTesting: ParticipantsControllerInterface {
        var argumentPassedToApplyAmounts: [Double] = []
        var participantTransactionModelUpdateCallbackOrNil: ParticipantTransactionModelUpdateCallback?

        func applyAmounts(amounts: [Double]) { argumentPassedToApplyAmounts = amounts }
    }

    var costTextFieldController: CostTextFieldController!
    var doneBarButtonItem: UIBarButtonItem!
    var notificationCenter: FairnessNotificationCenterForTesting!
    var participantsController: ParticipantsControllerForTesting!
    var sut: TransactionCalculatorController!
    var tableView: UITableViewForTesting!
    var transactionCalculator: TransactionCalculatorForTesting!

    override func setUp() {
        costTextFieldController = CostTextFieldController()
        doneBarButtonItem = UIBarButtonItem()
        notificationCenter = FairnessNotificationCenterForTesting()
        participantsController = ParticipantsControllerForTesting()
        tableView = UITableViewForTesting()
        transactionCalculator = TransactionCalculatorForTesting()

        sut = TransactionCalculatorController(notificationCenter: notificationCenter, transactionCalculator: transactionCalculator)

        sut.costTextFieldController = costTextFieldController
        sut.doneBarButtonItem = doneBarButtonItem
        sut.participantsController = participantsController
        sut.tableView = tableView
    }
}

class TransactionCalculatorControllerApplyTests: TransactionCalculatorControllerTestsBase {
    override func setUp() {
        super.setUp()
        sut.apply()
    }

    func testCallsApplyAmountsOnParticipantsController() {
        XCTAssertEqual(participantsController.argumentPassedToApplyAmounts, transactionCalculator.amounts)
    }

    func testTableViewIsReloaded() {
        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testTransactionWasEnded() {
        XCTAssertTrue(notificationCenter.didCallTransactionDidEnd)
    }
}

class TransactionCalculatorControllerResetTests: TransactionCalculatorControllerTestsBase {
    override func setUp() {
        super.setUp()
        sut.reset()
    }

    func testTableViewIsReloaded() {
        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testTransactionWasEnded() {
        XCTAssertTrue(notificationCenter.didCallTransactionDidEnd)
    }
}

class TransactionCalculatorControllerCostDidChangeTests: TransactionCalculatorControllerTestsBase {
    override func setUp() {
        super.setUp()
        doneBarButtonItem.enabled = false
        costTextFieldController.costDidChangeCallbackOrNil!(1)
    }

    func testTableViewIsReloaded() {
        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {
        XCTAssertTrue(doneBarButtonItem.enabled)
    }

    func testCostIsSetOnTransactionCalculator() {
        XCTAssertTrue(transactionCalculator.didSetCost)
    }
}

class TransactionCalculatorControllerParticipantUpdateCallbackTests: TransactionCalculatorControllerTestsBase {
    override func setUp() {
        super.setUp()
        let participants = ["name1", "name2"].map { ParticipantTransactionModel(participant: Participant(name: $0)) }
        participantsController.participantTransactionModelUpdateCallbackOrNil!(participants)
    }

    func testParticipantTransactionModelsAreSetOnTransactionCalculator() {
        XCTAssertEqual(transactionCalculator.participantTransactionModels.count, 2)
    }
}

class TransactionCalculatorControllerRowSelectionTests: TransactionCalculatorControllerTestsBase {
    override func setUp() {
        super.setUp()
        sut.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }

    func testPayerIsSetWhenTransactionCalculatorDoesNotHaveAPayer() {
        XCTAssertEqual(transactionCalculator.payerIndexForTesting!, 0)
    }

    func testPayeeIsSetWhenTransactionCalculatorHasAPayer() {
        transactionCalculator.hasPayerForTesting = true
        sut.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        XCTAssertEqual(transactionCalculator.payeeIndexForTesting!, 1)
    }

    func testTransactionDidStartIsCalledWhenTransactionCalculatorHasAPayer() {
        XCTAssertTrue(notificationCenter.didCallTransactionDidStart)
    }

    func testTableViewIsReloaded() {
        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {
        XCTAssertTrue(doneBarButtonItem.enabled)
    }
}