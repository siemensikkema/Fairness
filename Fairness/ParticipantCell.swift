import UIKit


class ParticipantCell: UITableViewCell {

    func configure(participant: Participant) {

        self.textLabel?.text = participant.name
    }
}