import UIKit


/// SiteAddressViewController: Displays the site address field to log in.
///
class SiteAddressViewController: UIViewController {

    typealias Factory = LoginFieldLoaderFactory & ViewControllerFactory

    private let factory: Factory

    private lazy var loader = factory.makeLoginFieldLoader()

    init(factory: Factory) {
        self.factory = factory
        super.init(nibName:nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
