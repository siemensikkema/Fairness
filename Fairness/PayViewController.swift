import UIKit


struct ParticipantStore {

    private let participants = [Participant(name: "Siemen"), Participant(name: "Willem")]
}


class Transaction {

    let participantStore = ParticipantStore()

    var cost = 0.0
    var amounts = [Double]()
    var payerIndex: Int?
    var payeeIndices = [Int]()
    var numberOfParticipants: Int { return participantStore.participants.count }

    init() {

        resetTransaction()
    }


    func apply() {

        for (index, participant) in enumerate(participantStore.participants) {

            participant.balance += amounts[index]
        }
    }

    func resetTransaction() {

        amounts = [Double](count: numberOfParticipants, repeatedValue: 0.0)
        cost = 0.0
        payerIndex = nil
        payeeIndices = [Int]()
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

                currentAmount = -cost / Double(payeeIndices.count)
            }

            if index == payerIndex {

                currentAmount += cost
            }
            
            amounts[index] = currentAmount
        }
    }

    subscript(index: Int) -> ParticipantViewModel {

        return ParticipantViewModel(participant: participantStore.participants[index], amount: amounts[index])
    }
}


class PayViewController: UITableViewController {

    let transaction = Transaction()


    @IBOutlet weak var amountTextField: UITextField!


    func updateTransaction() {

        transaction.update()
        tableView.reloadData()
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

        amountTextField.resignFirstResponder()

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
}
