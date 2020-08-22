import XCTest
@testable import WordPressAuthenticator


struct URLMocks {

    static let mockAppList = ["gmail": "googlemail://", "airmail": "airmail://"]
}


class AppSelectorTests: XCTestCase {

    // MARK: Initializer Tests

    func testSelectorInitializationSuccess() {
        // Given
        let urlHandler = MockUrlHandler()
        urlHandler.canOpenUrlExpectation = expectation(description: "canOpenUrl called")
        // When
        let appSelector = AppSelector(with: URLMocks.mockAppList, sourceView: UIView(), urlHandler: urlHandler)
        // Then
        XCTAssertNotNil(appSelector)
        XCTAssertNotNil(appSelector?.alertController)
        XCTAssertEqual(appSelector!.alertController.actions.count, 3)
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testSelectorInitializationFailsWithNoApps() {
        // Given
        let urlHandler = MockUrlHandler()
        // When
        let appSelector = AppSelector(with: [:], sourceView: UIView(), urlHandler: urlHandler)
        // Then
        XCTAssertNil(appSelector)
    }

    func testSelectorInitializationFailsWithInvalidUrl() {
        // Given
        let urlHandler = MockUrlHandler()
        urlHandler.canOpenUrlExpectation = expectation(description: "canOpenUrl called")
        urlHandler.shouldOpenUrls = false
        // When
        let appSelector = AppSelector(with: URLMocks.mockAppList, sourceView: UIView(), urlHandler: urlHandler)
        // Then
        XCTAssertNil(appSelector)
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testAppSelectorInitWithPlistFileSucceeds() {
        let plistPath = "MockValidEmailClients"
        let bundle = Bundle(for: type(of: self))
        let urlHandler = MockUrlHandler()

        let appSelector = AppSelector(with: plistPath,
                                      in: bundle,
                                      sourceView: UIView(),
                                      urlHandler: urlHandler)

        XCTAssertNotNil(appSelector)
    }

    func testAppSelectorInitWithoutValidPlistFile() {
        let plistPath = "Invalid Plist Name"
        let bundle = Bundle(for: type(of: self))
        let urlHandler = MockUrlHandler()

        let appSelector = AppSelector(with: plistPath,
                                      in: bundle,
                                      sourceView: UIView(),
                                      urlHandler: urlHandler)

        XCTAssertNil(appSelector)
    }

    func testAppSelectorInitWithEmptyPlistFileFails() {
        let plistPath = "MockEmptyEmailList"
        let bundle = Bundle(for: type(of: self))
        let urlHandler = MockUrlHandler()

        let appSelector = AppSelector(with: plistPath,
                                      in: bundle,
                                      sourceView: UIView(),
                                      urlHandler: urlHandler)

        XCTAssertNil(appSelector)
    }

    func testPresentEmailClientsPresentsCorrectAlert() throws {
        let appSelector = setupAppSelector(with: "MockValidEmailClients")
        let presenterSpy = ModalViewControllerPresentingSpy()
        let linkMailPresenter = LinkMailPresenter(emailAddress: "email@example.com")

        linkMailPresenter.presentEmailClients(on: presenterSpy, appSelector: appSelector)

        let alert = try XCTUnwrap(presenterSpy.presentedVC as? UIAlertController)
        XCTAssertNil(alert.message)
        XCTAssertEqual(alert.actions.count, 7)
        XCTAssertEqual(alert.actions[6].title, "Cancel")
    }

    func testLinkMailPresenterPresentEmailClientsFails() throws {
        let presenterSpy = ModalViewControllerPresentingSpy()
        let appSelector = setupAppSelector(with: "MockEmptyEmailList")
        let linkMailPresenter = LinkMailPresenter(emailAddress: "email@example.com")

        linkMailPresenter.presentEmailClients(on: presenterSpy, appSelector: appSelector)

        let alert = try XCTUnwrap(presenterSpy.presentedVC as? UIAlertController)
        XCTAssertEqual(alert.message,
                       String.localizedStringWithFormat(
                        NSLocalizedString(
                            "We just emailed a link to %@. Please check your mail app and tap the link to log in.",
                            comment: "message to ask a user to check their email for a WordPress.com email"),
                        "email@example.com")
        )
        XCTAssertEqual(alert.title, "Check your email!")
        XCTAssertEqual(alert.actions.count, 1)
    }

    func testLinkMailPresenterPresentEmailClientsFailsThree() throws {
        let appSelector = setupAppSelector(with: "MockEmptyEmailList")
        let linkMailPresenter = LinkMailPresenter(emailAddress: "email@example.com")
        MockMailComposeViewController.shouldSendMail = false
        let presenterSpy = ModalViewControllerPresentingSpy()

        linkMailPresenter.presentEmailClients(on: presenterSpy,
                                              appSelector: appSelector,
                                              mailComposerHandler: MockMailComposeViewController.self
                                              )

        let alert = try XCTUnwrap(presenterSpy.presentedVC as? UIAlertController)
        XCTAssertEqual(alert.message, "We just emailed a link to email@example.com. Please check your mail app and tap the link to log in.")
        XCTAssertEqual(alert.title, "Check your email!")
    }

    func testLinkMailPresenterPresentEmailClientsFailsAgain() throws {
        let appSelector = setupAppSelector(with: "MockEmptyEmailList")
        let urlHandler = MockUrlHandler()
        let linkMailPresenter = LinkMailPresenter(emailAddress: "email@example.com")

        linkMailPresenter.presentEmailClients(on: UIViewController(),
                                              appSelector: appSelector,
                                              mailComposerHandler: MockMailComposeViewController.self,
                                              urlHandler: urlHandler)

        XCTAssertEqual(urlHandler.lastUrl, URL(string: "message://"))
    }
}

extension AppSelectorTests {
    func setupAppSelector(with plist: String) -> AppSelector? {
        let plistPath = plist
        let bundle = Bundle(for: type(of: self))
        let urlHandler = MockUrlHandler()
        return AppSelector(with: plistPath,
                                      in: bundle,
                                      sourceView: UIView(),
                                      urlHandler: urlHandler)
    }
}

struct MockMailComposeViewController: MailComposerHandler {
    static var shouldSendMail: Bool = true

    static func canSendMail() -> Bool {
        return shouldSendMail
    }
}
