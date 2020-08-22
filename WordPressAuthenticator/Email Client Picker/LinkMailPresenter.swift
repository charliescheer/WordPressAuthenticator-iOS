import MessageUI


/// Email picker presenter
class LinkMailPresenter {

    private let emailAddress: String

    init(emailAddress: String) {
        self.emailAddress = emailAddress
    }

    /// Presents the available mail clients in an action sheet. If none is available,
    /// Falls back to Apple Mail and opens it.
    /// If not even Apple Mail is available, presents an alert to check your email
    /// - Parameters:
    ///   - viewController: the UIViewController that will present the action sheet
    ///   - appSelector: the app picker that contains the available clients. Nil if no clients are available
    ///                  reads the supported email clients from EmailClients.plist
    func presentEmailClients(on viewController: UIViewController,
                             appSelector: AppSelector?,
                             mailComposerHandler: MailComposerHandler.Type = MFMailComposeViewController.self,
                             urlHandler: URLHandler = UIApplication.shared) {

        guard let picker = appSelector else {
            // fall back to Apple Mail if no other clients are installed
            if mailComposerHandler.canSendMail(), let url = URL(string: "message://") {
                urlHandler.open(url, options: [:], completionHandler: nil)
            } else {
                showAlertToCheckEmail(on: viewController)
            }
            return
        }
        viewController.present(picker.alertController, animated: true)
    }

    private func showAlertToCheckEmail(on viewController: UIViewController) {
        let title = NSLocalizedString("Check your email!",
                                      comment: "Alert title for check your email during logIn/signUp.")

        let message = String.localizedStringWithFormat(NSLocalizedString("We just emailed a link to %@. Please check your mail app and tap the link to log in.",
                                                                         comment: "message to ask a user to check their email for a WordPress.com email"), emailAddress)

        let alertController =  UIAlertController(title: title,
                                                 message: message,
                                                 preferredStyle: .alert)
        alertController.addCancelActionWithTitle(NSLocalizedString("OK",
                                                                   comment: "Button title. An acknowledgement of the message displayed in a prompt."))
        viewController.present(alertController, animated: true, completion: nil)
    }
}

protocol MailComposerHandler {
    static func canSendMail() -> Bool
}

extension MFMailComposeViewController: MailComposerHandler { }
