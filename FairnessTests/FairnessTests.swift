import UIKit
import XCTest


class TwoParticipantTransactionTests: XCTestCase {

    var participants: [Participant]!

    override func setUp() {

        participants = [Participant(), Participant()]
    }
    
    func testSharedPaymentFromA() {

        participants[0].pay(10, forParticipants: participants)
        XCTAssertEqual(participants.map { $0.balance }, [5, -5])
    }

    func testPaymentToSelf() {

        participants[0].pay(10, forParticipants: [participants[0]])
        XCTAssertEqual(participants[0].balance, 0)
    }
}
