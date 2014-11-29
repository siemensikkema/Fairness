import UIKit

class ParticipantCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!

    let textEditController: TextEditControllerInterface

    override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        self.init(style: style, reuseIdentifier: reuseIdentifier, textEditController: TextEditController())
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String?, textEditController: TextEditControllerInterface) {

        self.textEditController = textEditController
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {

        textEditController = TextEditController()
        super.init(coder: aDecoder)
    }

    class func reuseIdentifier() -> String {

        return "Participant"
    }

    func configureWithParticipantTransactionViewModel(participantTransactionViewModel: ParticipantTransactionViewModelInterface, textChangeCallback: TextChangeCallback) {

        amountLabel.text = participantTransactionViewModel.amountString
        nameTextField.text = participantTransactionViewModel.nameOrNil

        backgroundColor = participantTransactionViewModel.isPayee ? UIColor.greenColor() : UIColor.whiteColor()
        layer.borderWidth = participantTransactionViewModel.isPayer ? 1 : 0

        textEditController.configureWithTextField(nameTextField, textChangeCallback: textChangeCallback)
    }

    override func setEditing(editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        if editing == false {

            nameTextField.endEditing(false)
        }
    }
}