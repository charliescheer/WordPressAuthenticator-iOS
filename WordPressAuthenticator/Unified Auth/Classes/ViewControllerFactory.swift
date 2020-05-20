import Foundation


protocol ViewControllerFactory {
    func makeSiteAddressViewController() -> SiteAddressViewController
}

protocol LoginFieldLoaderFactory {
    func makeLoginFieldLoader() -> LoginFields
}
