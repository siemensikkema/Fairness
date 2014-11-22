class ParticipantStore {

    let participants: [Participant]

    init(participants: [Participant]) {

        self.participants = participants
    }

    convenience init() {

        self.init(participants: [Participant(name: "Siemen"), Participant(name: "Willem")])
    }
}