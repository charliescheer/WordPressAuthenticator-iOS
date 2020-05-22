import Foundation


protocol ViewControllerFactory {
    func makeSiteAddressViewController(with loginFields: LoginFields) -> SiteAddressViewController
}
