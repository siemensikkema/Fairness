import UIKit



class ParticipantCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!


    func configure(#participantViewModel: ParticipantViewModel) {

        amountLabel.text = participantViewModel.amountString
        nameLabel.text = participantViewModel.name
        balanceLabel.text = participantViewModel.balanceString

        switch (participantViewModel.transactionStatus) {

        // TODO: DRY off code
        case .None:
            self.backgroundColor = UIColor.whiteColor()
            self.layer.borderWidth = 0
        case .Payee:
            self.backgroundColor = UIColor.greenColor()
            self.layer.borderWidth = 0
        case .Payer:
            self.layer.borderWidth = 1
            self.backgroundColor = UIColor.whiteColor()
        case .PayerSharingCost:
            self.backgroundColor = UIColor.greenColor()
            self.layer.borderWidth = 1
        }
    }
}
