import Foundation


/// Contains the core utility objects that are normally directly injected as dependencies.
///
final public class DependencyContainer {
    lazy var facade = WordPressXMLRPCAPIFacade()

//    lazy var loginFacade: LoginFacade = {
//        let configuration = WordPressAuthenticator.shared.configuration
//        let facade = LoginFacade(dotcomClientID: configuration.wpcomClientId,
//                                 dotcomSecret: configuration.wpcomSecret,
//                                 userAgent: configuration.userAgent)
//        facade.delegate = self
//        return facade
//    }()

    lazy var service = WordPressComBlogService()
}

/// Create all the viewControllers for the Unified Auth flow here.
///
extension DependencyContainer: ViewControllerFactory {
    func makeSiteAddressViewController(with loginFields: LoginFields) -> SiteAddressViewController {
        return SiteAddressViewController(loginFields: loginFields)
    }
}
