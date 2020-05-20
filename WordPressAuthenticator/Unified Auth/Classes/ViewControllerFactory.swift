import Foundation


protocol ViewControllerFactory {
    func makeSiteAddressViewController() -> SiteAddressViewController
    func makeUsernamePasswordViewController() -> LoginUsernamePasswordViewController
}

protocol LoginFieldLoaderFactory {
    func makeLoginFieldLoader() -> LoginFields
}

