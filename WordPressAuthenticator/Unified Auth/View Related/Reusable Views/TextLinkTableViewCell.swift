import UIKit


/// TextButtonTableViewCell: a plain text button with default styles.
///
final class TextLinkTableViewCell: UITableViewCell {

    /// Private properties
    ///
    @IBOutlet private weak var button: UIButton!
    @IBAction private func textLinkButtonTapped(_ sender: UIButton) {
        actionHandler?()
    }

    /// Public properties
    ///
    public static let reuseIdentifier = "TextLinkTableViewCell"

    public var actionHandler: (() -> Void)?

    public var buttonText: String? {
        get {
            return button.titleLabel?.text
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        button.setTitleColor(WordPressAuthenticator.shared.unifiedStyle?.textButtonColor, for: .normal)
        button.setTitleColor(WordPressAuthenticator.shared.unifiedStyle?.textButtonHighlightColor, for: .highlighted)
    }
}
