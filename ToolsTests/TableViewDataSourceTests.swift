import UIKit
import XCTest

extension String: DataSourceItem {}

class Cell: UITableViewCell, ReusableCell {

    class func reuseIdentifier() -> String { return "Cell" }
}

class TableViewDataSourceTests: XCTestCase {

    typealias TestDataSource = TableViewDataSource<String, Cell>

    let tableView: UITableViewForTesting = UITableViewForTesting()
    var sut: TestDataSource!
    var items: [String]!
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)

    var configurator: TestDataSource.Configurator!

    override func setUp() {

        configurator = { (item, cell) in }
        tableView.registerClass(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier())
        items = ["a", "b"]
        sut = TestDataSource { (item, cell) in

            self.configurator(item, cell) }
        sut.items = items

        items.first
    }
}

extension TableViewDataSourceTests {

    func testNumberOfRowsEquals2() {

        let numberOfRows = sut.toObjC.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 2)
    }

    func testFirstItemIsReturnedForFirstRow() {

        configurator = { (item: String, cell) in

            XCTAssertTrue(item == self.items.first)
        }
        tableView.dataSource = sut.toObjC
        sut.toObjC.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    func testDeleteRow() {

        sut.toObjC.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
        XCTAssertEqual(sut.items, ["b"])
        XCTAssertTrue(tableView.didCallReloadData)
    }
}