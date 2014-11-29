import XCTest
import UIKit

class ParticipantControllerTests: XCTestCase {

    var sut: ParticipantController!
    var participantTransactionModelsFromCallback: [ParticipantTransactionModel]!
    var participants: [Participant]!
    var tableView: UITableViewForTesting!

    var participantTransactionModelDataSource: TableViewDataSourceObjC!

    override func setUp() {

        participants = ["name1", "name2"].map { Participant(name: $0) }
        tableView = UITableViewForTesting()

        sut = ParticipantController(participants: participants)
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

        sut.applyAmounts([0, 1.23])

        XCTAssertEqual(participants.map { $0.balance }, [0, 1.23])
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

    func testAddParticipantAddsNewNamelessParticipantAtEndOfArray() {

        sut.addParticipant()
        XCTAssertNil(participantTransactionModelsFromCallback[2].nameOrNil)
    }

    func testAddParticipantUpdatesDataSource() {

        sut.addParticipant()
        XCTAssertEqual(participantTransactionModelDataSource.items.count, 3)
    }

    func testDeletionCallbackCallsDeleteOnParticipantController() {

        participantTransactionModelDataSource.deletionCallback?(tableView, NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertEqual(participantTransactionModelsFromCallback.first!.nameOrNil!, "name2")
    }
}