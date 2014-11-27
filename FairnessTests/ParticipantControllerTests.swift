import XCTest

class ParticipantControllerTests: XCTestCase {

    var sut: ParticipantController!
    var participantsFromCallback: [Participant]!

    override func setUp() {

        sut = ParticipantController()
        sut.participantUpdateCallbackOrNil = { participants in

            self.participantsFromCallback = participants
        }
    }

    func testApplyAmountsAddsSuppliedNumbersToParticipantsBalance() {

        sut.applyAmounts([0, 1.23])

        XCTAssertEqual(participantsFromCallback.map { $0.balance }, [0, 1.23])
    }

    func testAddParticipantAddsNewParticipantAtEndOfArray() {

        sut.addParticipant()
        XCTAssertNil(participantsFromCallback[2].nameOrNil)
    }
}