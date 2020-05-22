import Foundation


/// Contains the core utility objects that are normally directly injected as dependencies.
///
final public class DependencyContainer {
    lazy var facade = WordPressXMLRPCAPIFacade()
    lazy var service = WordPressComBlogService()
}

/// Create all the viewControllers for the Unified Auth flow here.
///
extension DependencyContainer: ViewControllerFactory {
    func makeSiteAddressViewController(with loginFields: LoginFields) -> SiteAddressViewController {
        return SiteAddressViewController(loginFields: loginFields)
    }
}
