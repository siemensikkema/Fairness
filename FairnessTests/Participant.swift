
class Participant {

    var balance = 0.0
    var name: String

    init(name: String) {

        self.name = name
    }

    func pay(amount: Double, forParticipants participants: [Participant]) {

        balance += amount
        let amountPerParticipant = amount/Double(participants.count)
        participants.map { $0.balance -= amountPerParticipant }
    }
}
