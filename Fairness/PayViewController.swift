import UIKit


struct ParticipantStore {

    private let participants = [Participant(name: "Siemen"), Participant(name: "Willem")]
}


class Transaction {

    let participantStore = ParticipantStore()

    var cost = 0.0
    var amounts = [Double]()
    var payerIndex: Int? {

        didSet {

            if let index = payerIndex {

                transactionStatuses[index] = transactionStatuses[index] == TransactionStatusType.PayerSharingCost ? .Payee : .Payer
            }
        }
    }
    var payeeIndices = [Int]()
    var transactionStatuses = [TransactionStatusType]()
    var numberOfParticipants: Int { return participantStore.participants.count }


    init() {

        resetTransaction()
    }


    func apply() {

        for (index, participant) in enumerate(participantStore.participants) {

            participant.balance += amounts[index]
        }

        resetTransaction()
    }

    func resetTransaction() {

        amounts = [Double](count: numberOfParticipants, repeatedValue: 0.0)
        cost = 0.0
        payerIndex = nil
        payeeIndices = [Int]()
        transactionStatuses = [TransactionStatusType](count: numberOfParticipants, repeatedValue: .None)
    }

    func togglePayeeAtIndex(index: Int) {

        if let index = find(payeeIndices, index) {

            payeeIndices.removeAtIndex(index)
        }
        else {

            payeeIndices.append(index)
        }
    }

    func update() {

        if payerIndex == nil { return }

        // a transaction is valid when there is a nonzero amount and at least one participant who is not the payer is involved
        let transactionIsValid = cost > 0.0 && payeeIndices.filter { $0 != self.payerIndex }.count > 0

        if (!transactionIsValid) { return }

        for index in 0..<numberOfParticipants {

            var currentAmount = 0.0

            if find(payeeIndices, index) != nil {

                transactionStatuses[index] = .Payee
                currentAmount = -cost / Double(payeeIndices.count)
            }
            else {

                transactionStatuses[index] = .None // clear any value from previous update
            }

            if index == payerIndex {

                transactionStatuses[index] = transactionStatuses[index] == TransactionStatusType.Payee ? .PayerSharingCost : .Payer;
                currentAmount += cost
            }
            
            amounts[index] = currentAmount
        }
    }

    // TODO: replace with clearer way to access participant view models
    subscript(index: Int) -> ParticipantViewModel {

        return ParticipantViewModel(participant: participantStore.participants[index], amount: amounts[index], transactionStatus:transactionStatuses[index])
    }
}


class PayViewController: UITableViewController {

    let transaction = Transaction()

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet weak var amountTextField: UITextField!


    func updateTransaction() {

        transaction.update()
        tableView.reloadData()
    }

    func reset() {

        amountTextField.resignFirstResponder()
        amountTextField.text = ""
        transaction.resetTransaction()
        tableView.reloadData()
    }


    // MARK: UIViewController


    override func viewDidLoad() {

        super.viewDidLoad()

        amountTextField.inputAccessoryView = accessoryToolbar
    }


    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transaction.numberOfParticipants
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Participant", forIndexPath: indexPath) as ParticipantCell

        cell.configure(participantViewModel: transaction[indexPath.row])

        return cell
    }


    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let index = indexPath.row

        if transaction.payerIndex == nil {

            transaction.payerIndex = index
            amountTextField.userInteractionEnabled = true
            amountTextField.becomeFirstResponder()
        }
        else {

            transaction.togglePayeeAtIndex(index)
        }

        updateTransaction()
    }


    // MARK: Actions

    @IBAction func amountDidChange() {

        transaction.cost = (amountTextField.text as NSString).doubleValue
        updateTransaction()
    }

    @IBAction func didTapCancelButton(sender: AnyObject) {

        reset()
    }

    @IBAction func didTapDoneButton(sender: AnyObject) {

        transaction.apply()
        reset()
    }
}
