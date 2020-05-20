import Foundation


/// Contains the core utility objects that are normally directly injected as dependencies.
///
class DependencyContainer {
    private lazy var facade = WordPressXMLRPCAPIFacade()
    private lazy var service = WordPressComBlogService()
}

/// Create all the viewControllers for the Unified Auth flow here.
///
extension DependencyContainer: ViewControllerFactory {
    func makeSiteAddressViewController() -> SiteAddressViewController {
        return SiteAddressViewController(factory: self)
    }
}

/// Create the loginFields used in the Unified Auth flows here.
///
extension DependencyContainer: LoginFieldLoaderFactory {
    func makeLoginFieldLoader() -> LoginFields {
        let loginFields = LoginFields()
        return loginFields
    }
}
