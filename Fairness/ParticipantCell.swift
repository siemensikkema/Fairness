import UIKit


class ParticipantCell: UITableViewCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!


    func configure(participantViewModel: ParticipantViewModel) {

        nameLabel.text = participantViewModel.name
        balanceLabel.text = participantViewModel.balanceString
    }
}