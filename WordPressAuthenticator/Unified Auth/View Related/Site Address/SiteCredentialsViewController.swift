import UIKit


/// Part two of the self-hosted sign in flow: username + password. Used by WPiOS and NiOS.
/// A valid site address should be acquired before presenting this view controller.
///
final class SiteCredentialsViewController: LoginViewController {

    /// Private properties.
    ///
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet var bottomContentConstraint: NSLayoutConstraint?

    private weak var usernameField: UITextField?
    private weak var passwordField: UITextField?
    private var rows = [Row]()
    private var errorMessage: String?
    private var shouldChangeVoiceOverFocus: Bool = false

    // Required for `NUXKeyboardResponder` but unused here.
    var verticalCenterConstraint: NSLayoutConstraint?

    override var sourceTag: WordPressSupportSourceTag {
        get {
            return .loginUsernamePassword
        }
    }

    override var loginFields: LoginFields {
        didSet {
            // Clear the password (if any) from LoginFields
            loginFields.password = ""
        }
    }

    // MARK: - Actions
    @IBAction func handleContinueButtonTapped(_ sender: NUXButton) {
        validateForm()
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loginFields.meta.userIsDotCom = false

        navigationItem.title = WordPressAuthenticator.shared.displayStrings.logInTitle
        styleNavigationBar(forUnified: true)

        // Store default margin, and size table for the view.
        defaultTableViewMargin = tableViewLeadingConstraint?.constant ?? 0
        setTableViewMargins(forWidth: view.frame.width)

        localizePrimaryButton()
        registerTableViewCells()
        loadRows()
        configureForAccessibility()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureSubmitButton(animating: false)

        registerForKeyboardEvents(keyboardWillShowAction: #selector(handleKeyboardWillShow(_:)),
                                  keyboardWillHideAction: #selector(handleKeyboardWillHide(_:)))
        configureViewForEditingIfNeeded()

        // Tracks go here. Old event: WordPressAuthenticator.track(.loginUsernamePasswordFormViewed)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardEvents()
    }


    // MARK: - Overrides

    /// Style individual ViewController backgrounds, for now.
    ///
    override func styleBackground() {
        guard let unifiedBackgroundColor = WordPressAuthenticator.shared.unifiedStyle?.viewControllerBackgroundColor else {
            super.styleBackground()
            return
        }

        view.backgroundColor = unifiedBackgroundColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return WordPressAuthenticator.shared.unifiedStyle?.statusBarStyle ?? WordPressAuthenticator.shared.style.statusBarStyle
    }

    /// Configures the appearance and state of the submit button.
    ///
    override func configureSubmitButton(animating: Bool) {
        submitButton?.showActivityIndicator(animating)

        submitButton?.isEnabled = (
            !animating &&
                !loginFields.username.isEmpty &&
                !loginFields.password.isEmpty
        )
    }

    /// Sets the view's state to loading or not loading.
    ///
    /// - Parameter loading: True if the form should be configured to a "loading" state.
    ///
    override func configureViewLoading(_ loading: Bool) {
        usernameField?.isEnabled = !loading
        passwordField?.isEnabled = !loading

        configureSubmitButton(animating: loading)
        navigationItem.hidesBackButton = loading
    }

    /// Set error messages and reload the table to display them.
    ///
    override func displayError(message: String, moveVoiceOverFocus: Bool = false) {
        if errorMessage != message {
            errorMessage = message
            shouldChangeVoiceOverFocus = moveVoiceOverFocus
            tableView.reloadData()
        }
    }

    /// No-op. Required by the SigninWPComSyncHandler protocol but the self-hosted
    /// controller's implementation does not use safari saved credentials.
    ///
    override func updateSafariCredentialsIfNeeded() {}

    /// No-op. Required by LoginFacade.
    func displayLoginMessage(_ message: String) {}
}


// MARK: - UITableViewDataSource
extension SiteCredentialsViewController: UITableViewDataSource {
    /// Returns the number of rows in a section.
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    /// Configure cells delegate method.
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        configure(cell, for: row, at: indexPath)

        return cell
    }
}


// MARK: - UITableViewDelegate conformance
extension SiteCredentialsViewController: UITableViewDelegate {
    /// After a textfield cell is done displaying, remove the textfield reference.
    ///
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if rows[indexPath.row] == .username {
            usernameField = nil
        } else if rows[indexPath.row] == .password {
            passwordField = nil
        }
    }
}


// MARK: - Keyboard Notifications
extension SiteCredentialsViewController: NUXKeyboardResponder {
    @objc func handleKeyboardWillShow(_ notification: Foundation.Notification) {
        keyboardWillShow(notification)
    }

    @objc func handleKeyboardWillHide(_ notification: Foundation.Notification) {
        keyboardWillHide(notification)
    }
}


// MARK: - TextField Delegate conformance
extension SiteCredentialsViewController: UITextFieldDelegate {

    /// Handle the keyboard `return` button action.
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField?.becomeFirstResponder()
        } else if textField == passwordField {
            validateForm()
        }
        return true
    }
}


// MARK: - Private Methods
private extension SiteCredentialsViewController {

    /// Registers all of the available TableViewCells.
    ///
    func registerTableViewCells() {
        let cells = [
            TextLabelTableViewCell.reuseIdentifier: TextLabelTableViewCell.loadNib(),
            TextFieldTableViewCell.reuseIdentifier: TextFieldTableViewCell.loadNib(),
            TextLinkButtonTableViewCell.reuseIdentifier: TextLinkButtonTableViewCell.loadNib()
        ]

        for (reuseIdentifier, nib) in cells {
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        }
    }

    /// Describes how the tableView rows should be rendered.
    ///
    func loadRows() {
        rows = [.instructions, .username, .password]

        if errorMessage != nil {
            rows.append(.errorMessage)
        }

        if WordPressAuthenticator.shared.configuration.displayHintButtons {
            rows.append(.forgotPassword)
        }
    }

    /// Configure cells.
    ///
    func configure(_ cell: UITableViewCell, for row: Row, at indexPath: IndexPath) {
        switch cell {
        case let cell as TextLabelTableViewCell where row == .instructions:
            configureInstructionLabel(cell)
        case let cell as TextFieldTableViewCell where row == .username:
            configureUsernameTextField(cell)
        case let cell as TextFieldTableViewCell where row == .password:
            configurePasswordTextField(cell)
        case let cell as TextLinkButtonTableViewCell:
            configureForgotPassword(cell)
        case let cell as TextLabelTableViewCell where row == .errorMessage:
            configureErrorLabel(cell)
        default:
            DDLogError("Error: Unidentified tableViewCell type found.")
        }
    }

    /// Configure the instruction cell.
    ///
    func configureInstructionLabel(_ cell: TextLabelTableViewCell) {
        let displayURL = sanitizedSiteAddress(siteAddress: loginFields.siteAddress)
        let text = String.localizedStringWithFormat(WordPressAuthenticator.shared.displayStrings.siteCredentialInstructions, displayURL)
        cell.configureLabel(text: text, style: .body)
    }

    /// Configure the username textfield cell.
    ///
    func configureUsernameTextField(_ cell: TextFieldTableViewCell) {
        cell.configureTextFieldStyle(with: .username,
                                     and: WordPressAuthenticator.shared.displayStrings.usernamePlaceholder)
        // Save a reference to the textField so it can becomeFirstResponder.
        usernameField = cell.textField
        cell.textField.delegate = self
        SigninEditingState.signinEditingStateActive = true
        cell.onePasswordHandler = { [weak self] in
            guard let self = self else {
                return
            }

            guard let sourceView = self.usernameField else {
                return
            }

            self.view.endEditing(true)

            WordPressAuthenticator.fetchOnePasswordCredentials(self, sourceView: sourceView, loginFields: self.loginFields) { [unowned self] loginFields in
                self.usernameField?.text = loginFields.username
                self.passwordField?.text = loginFields.password
                self.validateForm()
            }
        }

        cell.onChangeSelectionHandler = { [weak self] textfield in
            self?.loginFields.username = textfield.nonNilTrimmedText()
            self?.configureSubmitButton(animating: false)
        }
    }

    /// Configure the password textfield cell.
    ///
    func configurePasswordTextField(_ cell: TextFieldTableViewCell) {
        cell.configureTextFieldStyle(with: .password,
                                     and: WordPressAuthenticator.shared.displayStrings.passwordPlaceholder)
        passwordField = cell.textField
        cell.textField.delegate = self
        cell.onChangeSelectionHandler = { [weak self] textfield in
            self?.loginFields.password = textfield.nonNilTrimmedText()
            self?.configureSubmitButton(animating: false)
        }
    }

    /// Configure the forgot password cell.
    ///
    func configureForgotPassword(_ cell: TextLinkButtonTableViewCell) {
        cell.configureButton(text: WordPressAuthenticator.shared.displayStrings.resetPasswordButtonTitle, accessibilityTrait: .link)
        cell.actionHandler = { [weak self] in
            guard let self = self else {
                return
            }

            // If information is currently processing, ignore button tap.
            guard self.enableSubmit(animating: false) else {
                return
            }

            WordPressAuthenticator.openForgotPasswordURL(self.loginFields)
            // TODO: add new tracks. Old track: WordPressAuthenticator.track(.loginForgotPasswordClicked)
        }
    }

    /// Configure the error message cell.
    ///
    func configureErrorLabel(_ cell: TextLabelTableViewCell) {
        cell.configureLabel(text: errorMessage, style: .error)
    }

    /// Sets up necessary accessibility labels and attributes for the all the UI elements in self.
    ///
    func configureForAccessibility() {
        usernameField?.accessibilityLabel =
            NSLocalizedString("Username", comment: "Accessibility label for the username text field in the self-hosted login page.")
        passwordField?.accessibilityLabel =
            NSLocalizedString("Password", comment: "Accessibility label for the password text field in the self-hosted login page.")

        if UIAccessibility.isVoiceOverRunning {
            // Remove the placeholder if VoiceOver is running. VoiceOver speaks the label and the
            // placeholder together. In this case, both labels and placeholders are the same so it's
            // like VoiceOver is reading the same thing twice.
            usernameField?.placeholder = nil
            passwordField?.placeholder = nil
        }
    }

    /// Configure the view for an editing state.
    ///
    func configureViewForEditingIfNeeded() {
        // Check the helper to determine whether an editing state should be assumed.
        adjustViewForKeyboard(SigninEditingState.signinEditingStateActive)
        if SigninEditingState.signinEditingStateActive {
            usernameField?.becomeFirstResponder()
        }
    }
    
    // MARK: - Private Constants

    /// Rows listed in the order they were created.
    ///
    enum Row {
        case instructions
        case username
        case password
        case forgotPassword
        case errorMessage

        var reuseIdentifier: String {
            switch self {
            case .instructions:
                return TextLabelTableViewCell.reuseIdentifier
            case .username:
                return TextFieldTableViewCell.reuseIdentifier
            case .password:
                return TextFieldTableViewCell.reuseIdentifier
            case .forgotPassword:
                return TextLinkButtonTableViewCell.reuseIdentifier
            case .errorMessage:
                return TextLabelTableViewCell.reuseIdentifier
            }
        }
    }
}


// MARK: - Instance Methods
/// Implementation methods copied from LoginSelfHostedViewController.
///
extension SiteCredentialsViewController {
    /// Sanitize and format the site address we show to users.
    ///
    @objc func sanitizedSiteAddress(siteAddress: String) -> String {
        let baseSiteUrl = WordPressAuthenticator.baseSiteURL(string: siteAddress) as NSString
        if let str = baseSiteUrl.components(separatedBy: "://").last {
            return str
        }
        return siteAddress
    }

    /// Validates what is entered in the various form fields and, if valid,
    /// proceeds with the submit action.
    ///
    @objc func validateForm() {
        validateFormAndLogin()
    }

    func finishedLogin(withUsername username: String, password: String, xmlrpc: String, options: [AnyHashable: Any]) {
        guard let delegate = WordPressAuthenticator.shared.delegate else {
            fatalError("Error: Where did the delegate go?")
        }

        let wporg = WordPressOrgCredentials(username: username, password: password, xmlrpc: xmlrpc, options: options)
        let credentials = AuthenticatorCredentials(wporg: wporg)
        delegate.sync(credentials: credentials) { [weak self] in
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: WordPressAuthenticator.WPSigninDidFinishNotification), object: nil)
            self?.showLoginEpilogue(for: credentials)
        }
    }

    override func displayRemoteError(_ error: Error) {
        configureViewLoading(false)
        let err = error as NSError
        if err.code == 403 {
            let message = NSLocalizedString("It looks like this username/password isn't associated with this site.",
                                            comment: "An error message shown during log in when the username or password is incorrect.")
            displayError(message: message, moveVoiceOverFocus: true)
        } else {
            displayError(error as NSError, sourceTag: sourceTag)
        }
    }
}
