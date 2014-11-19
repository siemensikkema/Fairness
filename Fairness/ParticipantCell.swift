import UIKit

class ParticipantCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(#participantTransactionViewModel: ParticipantTransactionViewModel) {

        amountLabel.text = participantTransactionViewModel.amountString
        nameLabel.text = participantTransactionViewModel.name

        self.backgroundColor = participantTransactionViewModel.isPayee ? UIColor.greenColor() : UIColor.whiteColor()
        self.layer.borderWidth = participantTransactionViewModel.isPayer ? 1 : 0
    }

    class func reuseIdentifier() -> String {

        return "Participant"
    }
}