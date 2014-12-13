import XCTest
import UIKit

class ParticipantsControllerTests: XCTestCase {
    class ParticipantsStoreForTesting: ParticipantsStoreInterface {
        var argumentPassedToApplyAmounts: [Double] = []
        var participantTransactionModels = ["name1", "name2"].map { ParticipantTransactionModel(participant: Participant(name: $0)) }

        func addParticipant() {
            participantTransactionModels.append(ParticipantTransactionModel(participant: Participant(name: "name3")))
        }
        func applyAmounts(amounts: [Double]) { argumentPassedToApplyAmounts = amounts }
        func removeParticipantAtIndex(index: Int) { participantTransactionModels.removeAtIndex(index) }
    }

    var sut: ParticipantsController!
    var participantTransactionModelsFromCallback: [ParticipantTransactionModel]!
    var participantsStore: ParticipantsStoreForTesting!
    var tableView: UITableViewForTesting!
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)

    var participantTransactionModelDataSource: TableViewDataSourceObjC!

    override func setUp() {
        tableView = UITableViewForTesting()

        participantsStore = ParticipantsStoreForTesting()

        sut = ParticipantsController(participantsStore: participantsStore)
        sut.participantTransactionModelUpdateCallbackOrNil = { participantTransactionModels in
            self.participantTransactionModelsFromCallback = participantTransactionModels
        }
        sut.tableView = tableView
        participantTransactionModelDataSource = tableView.dataSource as TableViewDataSourceObjC

        sut.participantTransactionModelUpdateCallbackOrNil = { participantTransactionModels in
            self.participantTransactionModelsFromCallback = participantTransactionModels
        }
    }

    func testApplyAmountsAddsSuppliedNumbersToParticipantsBalance() {
        let amounts = [0, 1.23]
        sut.applyAmounts(amounts)

        XCTAssertEqual(participantsStore.argumentPassedToApplyAmounts, amounts)
    }

    func testDataSourceIsSet() {
        XCTAssertNotNil(participantTransactionModelDataSource)
    }

    func testParticipantTransactionModelUpdateCallbackAfterSettingIt() {
        XCTAssertEqual(participantTransactionModelsFromCallback!.count, 2)
        XCTAssertEqual(participantTransactionModelDataSource.items.count, 2)
    }

    func testParticipantTransactionModelsFromCallbackAndDataSourceAreSameInstances() {
        XCTAssertEqual(
            ObjectIdentifier(participantTransactionModelsFromCallback.first!),
            ObjectIdentifier(participantTransactionModelDataSource.items.first! as ParticipantTransactionModel))
    }

    func testAddParticipantUpdatesDataSource() {
        sut.addParticipant()
        XCTAssertEqual(participantTransactionModelDataSource.items.count, 3)
    }

    func testAddParticipantReloadsTableView() {
        sut.addParticipant()
        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDeletionCallbackCallsDeleteOnParticipantsController() {
        participantTransactionModelDataSource.deletionCallback?(tableView, indexPath)
        XCTAssertEqual(participantTransactionModelsFromCallback.first!.nameOrNil!, "name2")
    }
}