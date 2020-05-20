import UIKit


/// SiteAddressViewController: Displays the site address field to log in.
///
class SiteAddressViewController: UIViewController {

    /// Use protocol composition to create a Factory type that
    /// includes all the factory protocols that this VC needs.
    ///
    typealias Factory = LoginFieldLoaderFactory & ViewControllerFactory
    private let factory: Factory

    /// Lazily create the loginFields by using the injected factory.
    ///
    private lazy var loginFields = factory.makeLoginFieldLoader()

    /// Designated initializer.
    ///
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName:nil, bundle: nil)
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
