import UIKit

class NavigationBarReappearBehavior: NSObject {

    @IBOutlet weak var navigationController: UINavigationController!

    private let notificationCenter: FairnessNotificationCenter

    convenience override init() {

        self.init(notificationCenter: NotificationCenter())
    }

    init(notificationCenter: FairnessNotificationCenter) {

        self.notificationCenter = notificationCenter
        super.init()
        notificationCenter.observeKeyboardWillHide {

            self.navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
}