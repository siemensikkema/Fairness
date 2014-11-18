import UIKit

class ParticipantCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(#participantViewModel: ParticipantViewModel) {

        amountLabel.text = participantViewModel.amountString
        nameLabel.text = participantViewModel.name

        self.backgroundColor = participantViewModel.isPayee ? UIColor.greenColor() : UIColor.whiteColor()
        self.layer.borderWidth = participantViewModel.isPayer ? 1 : 0
    }
}