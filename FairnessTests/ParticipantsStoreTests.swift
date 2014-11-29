import XCTest

class ParticipantsStoreTests: XCTestCase {

    var sut: ParticipantsStore!
    var participants: [Participant]!

    override func setUp() {

        participants = ["name1", "name2"].map { Participant(name: $0) }
        sut = ParticipantsStore(participants: participants)
    }

    func testAddParticipantAddsNewNamelessParticipantAtEndOfArray() {

        sut.addParticipant()
        XCTAssertNil(sut.participantTransactionModels[2].nameOrNil)
    }

    func testApplyAmountsAddsSuppliedNumbersToParticipantsBalance() {

        let amounts = [0, 1.23]
        sut.applyAmounts(amounts)

        XCTAssertEqual(participants.map { $0.balance }, [0, 1.23])
    }

    func testRemoveParticipantsRemovesParticipant() {

        sut.removeParticipantAtIndex(0)
        XCTAssertEqual(sut.participantTransactionModels.first!.nameOrNil!, "name2")
    }
}