

// MARK: - WordPressAuthenticator Delegate Protocol
//
public protocol WordPressAuthenticatorDelegate: class {

    /// Indicates if the active Authenticator can be dismissed, or not.
    ///
    var dismissActionEnabled: Bool { get }

    /// Indicates if the Support button action should be enabled, or not.
    ///
    var supportActionEnabled: Bool { get }

    /// Indicates if the Support notification indicator should be displayed.
    ///
    var showSupportNotificationIndicator: Bool { get }

    /// Indicates if Support is available or not.
    ///
    var supportEnabled: Bool { get }

    /// Signals the Host App that a new WordPress.com account has just been created.
    ///
    /// - Parameters:
    ///     - username: WordPress.com Username.
    ///     - authToken: WordPress.com Bearer Token.
    ///     - onCompletion: Closure to be executed on completion.
    ///
    func createdWordPressComAccount(username: String, authToken: String)

    /// Presents the Support new request, from a given ViewController, with a specified SourceTag.
    ///
    func presentSupportRequest(from sourceViewController: UIViewController, sourceTag: WordPressSupportSourceTag)

    /// Presents the Login Epilogue, in the specified NavigationController.
    ///
    func presentLoginEpilogue(in navigationController: UINavigationController, for credentials: WordPressCredentials, onDismiss: @escaping () -> Void)

    /// Presents the Login Epilogue, in the specified NavigationController.
    ///
    func presentSignupEpilogue(in navigationController: UINavigationController, for credentials: WordPressCredentials, service: SocialService?)

    /// Presents the Support Interface from a given ViewController, with a specified SourceTag.
    ///
    func presentSupport(from sourceViewController: UIViewController, sourceTag: WordPressSupportSourceTag)

    /// Indicates if the Login Epilogue should be displayed.
    ///
    /// - Parameter isJetpackLogin: Indicates if we've just logged into a WordPress.com account for Jetpack purposes!.
    ///
    func shouldPresentLoginEpilogue(isJetpackLogin: Bool) -> Bool

    /// Indicates if the Signup Epilogue should be displayed.
    ///
    func shouldPresentSignupEpilogue() -> Bool

    /// Signals the Host App that a WordPress Site (wpcom or wporg) is available with the specified credentials.
    ///
    /// - Parameters:
    ///     - credentials: WordPress Site Credentials.
    ///     - onCompletion: Closure to be executed on completion.
    ///
    func sync(credentials: WordPressCredentials, onCompletion: @escaping (Error?) -> Void)

    /// Signals the Host App that a given Analytics Event has occurred.
    ///
    func track(event: WPAnalyticsStat)

    /// Signals the Host App that a given Analytics Event (with the specified properties) has occurred.
    ///
    func track(event: WPAnalyticsStat, properties: [AnyHashable: Any])

    /// Signals the Host App that a given Analytics Event (with an associated Error) has occurred.
    ///
    func track(event: WPAnalyticsStat, error: Error)
}