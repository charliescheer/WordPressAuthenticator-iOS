import XCTest
@testable import WordPressAuthenticator


struct URLMocks {

    static let mockAppList = ["gmail": "googlemail://", "airmail": "airmail://"]
}

class MockUrlHandler: URLHandler {

    var shouldOpenUrls = true

    var canOpenUrlExpectation: XCTestExpectation?
    var openUrlExpectation: XCTestExpectation?

    func canOpenURL(_ url: URL) -> Bool {
        canOpenUrlExpectation?.fulfill()
        canOpenUrlExpectation = nil
        return shouldOpenUrls
    }

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        openUrlExpectation?.fulfill()
    }
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


}
