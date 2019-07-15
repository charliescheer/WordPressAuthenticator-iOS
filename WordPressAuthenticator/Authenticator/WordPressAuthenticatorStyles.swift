import UIKit
import Gridicons
import WordPressShared

// MARK: - WordPress Authenticator Styles
//
public struct WordPressAuthenticatorStyle {
    /// Style: Primary + Normal State
    ///
    public let primaryNormalBackgroundColor: UIColor

    public let primaryNormalBorderColor: UIColor

    /// Style: Primary + Highlighted State
    ///
    public let primaryHighlightBackgroundColor: UIColor

    public let primaryHighlightBorderColor: UIColor

    /// Style: Secondary
    ///
    public let secondaryNormalBackgroundColor: UIColor

    public let secondaryNormalBorderColor: UIColor

    public let secondaryHighlightBackgroundColor: UIColor

    public let secondaryHighlightBorderColor: UIColor

    /// Style: Disabled State
    ///
    public let disabledBackgroundColor: UIColor

    public let disabledBorderColor: UIColor

    public let primaryTitleColor: UIColor

    public let secondaryTitleColor: UIColor

    public let disabledTitleColor: UIColor

    /// Style: Labels
    ///
    public let instructionColor: UIColor

    public let subheadlineColor: UIColor

    /// Style: Login screen background colors
    ///
    public let viewControllerBackgroundColor: UIColor

    /// Style: nav bar logo
    ///
    public let navBarImage: UIImage

    /// Style: prologue background colors
    ///
    public let prologueBackgroundColor: UIColor

    /// Style: prologue background colors
    ///
    public let prologueTitleColor: UIColor

    /// Designated initializer
    ///
    public init(primaryNormalBackgroundColor: UIColor, primaryNormalBorderColor: UIColor, primaryHighlightBackgroundColor: UIColor, primaryHighlightBorderColor: UIColor, secondaryNormalBackgroundColor: UIColor, secondaryNormalBorderColor: UIColor, secondaryHighlightBackgroundColor: UIColor, secondaryHighlightBorderColor: UIColor, disabledBackgroundColor: UIColor, disabledBorderColor: UIColor, primaryTitleColor: UIColor, secondaryTitleColor: UIColor, disabledTitleColor: UIColor, instructionColor: UIColor, subheadlineColor: UIColor, viewControllerBackgroundColor: UIColor, navBarImage: UIImage, prologueBackgroundColor: UIColor = WPStyleGuide.wordPressBlue(), prologueTitleColor: UIColor = .white) {
        self.primaryNormalBackgroundColor = primaryNormalBackgroundColor
        self.primaryNormalBorderColor = primaryNormalBorderColor
        self.primaryHighlightBackgroundColor = primaryHighlightBackgroundColor
        self.primaryHighlightBorderColor = primaryHighlightBorderColor
        self.secondaryNormalBackgroundColor = secondaryNormalBackgroundColor
        self.secondaryNormalBorderColor = secondaryNormalBorderColor
        self.secondaryHighlightBackgroundColor = secondaryHighlightBackgroundColor
        self.secondaryHighlightBorderColor = secondaryHighlightBorderColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.disabledBorderColor = disabledBorderColor
        self.primaryTitleColor = primaryTitleColor
        self.secondaryTitleColor = secondaryTitleColor
        self.disabledTitleColor = disabledTitleColor
        self.instructionColor = instructionColor
        self.subheadlineColor = subheadlineColor
        self.viewControllerBackgroundColor = viewControllerBackgroundColor
        self.navBarImage = navBarImage
        self.prologueBackgroundColor = prologueBackgroundColor
        self.prologueTitleColor = prologueTitleColor
    }
}
