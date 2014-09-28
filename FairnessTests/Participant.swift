
class Participant {

    var balance = 0.0

    func pay(amount: Double, forParticipants participants: [Participant]) {

        balance += amount
        let amountPerParticipant = amount/Double(participants.count)
        participants.map { $0.balance -= amountPerParticipant }
    }
}
