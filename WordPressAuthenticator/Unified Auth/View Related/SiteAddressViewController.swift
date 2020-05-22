import UIKit


/// SiteAddressViewController: Displays the site address field to log in.
///
class SiteAddressViewController: UIViewController {
    /// Login properties
    ///
    let loginFields: LoginFields

    /// Designated initializer.
    ///
    init(loginFields: LoginFields) {
        self.loginFields = loginFields
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set a special case login field.
        loginFields.meta.userIsDotCom = false
    }
}
