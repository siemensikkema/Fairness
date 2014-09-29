import UIKit


class ParticipantCell: UITableViewCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabelWidthConstraint: NSLayoutConstraint!


    func configure(participantViewModel: ParticipantViewModel) {

        nameLabel.text = participantViewModel.name
        balanceLabel.text = participantViewModel.balanceString
        balanceLabelWidthConstraint.constant = balanceLabel.intrinsicContentSize().width
    }
}