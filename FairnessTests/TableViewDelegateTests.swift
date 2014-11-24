import XCTest
import UIKit

class TableViewDelegateSplitterTests: XCTestCase {

    class TableViewSelectionDelegateForTesting: TableViewSelectionDelegate {

        var didCallDidSelectRowAtIndexPath = false

        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

            didCallDidSelectRowAtIndexPath = true
        }
    }

    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    let tableView = UITableView()
    var sut: TableViewDelegateSplitter!
    var tableViewSelectionDelegate: TableViewSelectionDelegateForTesting!

    override func setUp() {

        sut = TableViewDelegateSplitter()
        tableViewSelectionDelegate = TableViewSelectionDelegateForTesting()
        sut.selectionDelegate = tableViewSelectionDelegate
    }

    func testDidSelectRowAtIndexPathIsForwarded() {

        sut.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        XCTAssertTrue(tableViewSelectionDelegate.didCallDidSelectRowAtIndexPath)
    }
}