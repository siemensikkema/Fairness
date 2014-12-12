import UIKit

class TableViewDataSource<ItemType, CellType: UITableViewCell where CellType: ReusableCell> {
    typealias Configurator = (ItemType, CellType) -> ()
    typealias DeletionCallback = (Int) -> ()

    let toObjC: TableViewDataSourceObjC

    var deletionCallback: DeletionCallback?
    var items: [ItemType] = [] {
        didSet { toObjC.items = itemsObjC() }
    }

    init(configurator: Configurator) {
        toObjC = TableViewDataSourceObjC(cellIdentifier: CellType.reuseIdentifier()) { (item, cell) in
            configurator(item as ItemType, cell as CellType)
        }

        self.toObjC.deletionCallback = { (tableView, indexPath) in
            self.items.removeAtIndex(indexPath.row)
            tableView.reloadData()
            self.deletionCallback?(indexPath.row)
        }
    }

    private func itemsObjC() -> [Any] {
        return items.map { item -> Any in
            return item as Any
        }
    }
}

class TableViewDataSourceObjC: NSObject, UITableViewDataSource {
    typealias ConfiguratorObjC = (Any, AnyObject) -> Void
    typealias DeletionCallbackObjC = (UITableView, NSIndexPath) -> Void

    let cellIdentifier: String
    let configurator: ConfiguratorObjC
    var deletionCallback: DeletionCallbackObjC?
    var items: [Any] = []

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell {
            configurator(items[indexPath.row], cell)
            return cell;
        } else {
            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deletionCallback?(tableView, indexPath)
        }
    }

    init(cellIdentifier: String, configurator: ConfiguratorObjC) {
        self.cellIdentifier = cellIdentifier
        self.configurator = configurator
    }
}