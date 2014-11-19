import UIKit

protocol DataSourceItem {}

class TableViewDataSource<ItemType: DataSourceItem, CellType: UITableViewCell where CellType: ReusableCell> {

    typealias Configurator = (ItemType, CellType) -> ()
    let configurator: Configurator
    let toObjC: TableViewDataSourceObjC!
    var items: [ItemType] = [] {

        didSet {

            toObjC.items = itemsObjC()
        }
    }

    init(configurator: Configurator) {

        self.configurator = configurator

        self.toObjC = TableViewDataSourceObjC(cellIdentifier: CellType.reuseIdentifier()) { (item, cell) in

            self.configurator(item as ItemType, cell as CellType)
        }
    }

    private func itemsObjC() -> [DataSourceItem] {

        return items.map { item -> DataSourceItem in

            return item as DataSourceItem
        }
    }
}

public class TableViewDataSourceObjC: NSObject, UITableViewDataSource {

    typealias ConfiguratorObjC = (DataSourceItem, AnyObject) -> Void

    let cellIdentifier: String
    let configurator: ConfiguratorObjC
    var items: [DataSourceItem] = []

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell {

            configurator(items[indexPath.row], cell)
            return cell;
        }
        else {

            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
    }

    init(cellIdentifier: String, configurator: ConfiguratorObjC) {
        
        self.cellIdentifier = cellIdentifier
        self.configurator = configurator
    }
}