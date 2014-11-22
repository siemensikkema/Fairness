import UIKit
import XCTest

class Item: DataSourceItem {}

class Cell: UITableViewCell, ReusableCell {

    class func reuseIdentifier() -> String { return "Cell" }
}

class TableViewDataSourceTests: XCTestCase {

    typealias TestDataSource = TableViewDataSource<Item, Cell>

    let tableView: UITableView = UITableView()
    var sut: TestDataSource!
    var items: [Item]!

    override func setUp() {

        tableView.registerClass(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier())
        items = [Item(), Item()]
    }
}

extension TableViewDataSourceTests {

    func testNumberOfRowsEquals2() {

        sut = TestDataSource { (item, cell) in }
        sut.items = items
        let numberOfRows = sut.toObjC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 2)
    }

    func testFirstItemIsReturnedForFirstRow() {

        sut = TestDataSource { (item, cell) in

            XCTAssertTrue(item === self.items.first)
        }
        sut.items = items
        tableView.dataSource = sut.toObjC
        sut.toObjC.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
}
