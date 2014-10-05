import UIKit


class PayViewController: UITableViewController {

    let participants = [Participant(name: "Siemen"), Participant(name: "Willem")]
    var payer: Participant?
    var payees: [Participant] = []
    var amounts = [0.0, 0.0]


    @IBOutlet weak var amountTextField: UITextField!


    func updateTransaction() {

        if let actualPayer = payer {

            let amount = (self.amountTextField.text as NSString).doubleValue

            // a transaction is valid when there is a nonzero amount and at least one participant who is not the payer is involved
            let transactionIsValid = amount > 0.0 && countElements(payees.filter { $0 != actualPayer }) > 0

            if transactionIsValid {

                for (index, participant) in enumerate(participants) {

                    var currentAmount = 0.0

                    if find(payees, participant) != nil {

                        currentAmount = -amount / Double(payees.count)
                    }

                    if participant == payer {

                        currentAmount += amount
                    }

                    amounts[index] = currentAmount
                }

                tableView.reloadData()
            }
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countElements(participants)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Participant", forIndexPath: indexPath) as ParticipantCell

        cell.configure(ParticipantViewModel(participant: participants[indexPath.row], amount: amounts[indexPath.row]))

        return cell
    }


    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        amountTextField.resignFirstResponder()

        let participant = participants[indexPath.row]

        if payer == nil {

            payer = participant
            amountTextField.userInteractionEnabled = true
            amountTextField.becomeFirstResponder()
        }
        else {

            if let index = find(payees, participant) {

                payees.removeAtIndex(index)
            }
            else {

                payees.append(participant)
            }
        }

        updateTransaction()
    }


    // MARK: Actions

    @IBAction func amountChanged(sender: AnyObject) {

        updateTransaction()
    }
}
