import UIKit


class PayViewController: UITableViewController {

    let participants = [Participant(name: "Siemen"), Participant(name: "Willem")]


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

        amountTextField.becomeFirstResponder()
    }
}
