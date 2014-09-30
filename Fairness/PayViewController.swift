import UIKit


class PayViewController: UITableViewController {

    let participants = [Participant(name: "Siemen"), Participant(name: "Willem")]
    var payer: Participant?
    var payees: [Participant] = []


    @IBOutlet weak var amountTextField: UITextField!


    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countElements(participants)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Participant", forIndexPath: indexPath) as ParticipantCell

        cell.configure(ParticipantViewModel(participant: participants[indexPath.row]))

        return cell
    }


    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
    }
}
