import UIKit

@objc protocol TableViewDelegate { }

@objc protocol TableViewSelectionDelegate: TableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class TableViewDelegateSplitter: NSObject, UITableViewDelegate {
    @IBOutlet weak var selectionDelegate: TableViewSelectionDelegate!

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectionDelegate?.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
}