import UIKit

class ParticipantCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(#participantTransactionModel: ParticipantTransactionModel) {

        amountLabel.text = participantTransactionModel.amountString
        nameLabel.text = participantTransactionModel.name

        self.backgroundColor = participantTransactionModel.isPayee ? UIColor.greenColor() : UIColor.whiteColor()
        self.layer.borderWidth = participantTransactionModel.isPayer ? 1 : 0
    }
}