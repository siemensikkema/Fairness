import UIKit


class ParticipantCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!


    func configure(#participantViewModel: ParticipantViewModel) {

        amountLabel.text = participantViewModel.amountString
        nameLabel.text = participantViewModel.name
        balanceLabel.text = participantViewModel.balanceString
    }
}
