import UIKit

class UITableViewForTesting: UITableView {
    var didCallReloadData = false

    override func reloadData() {
        didCallReloadData = true
    }
}