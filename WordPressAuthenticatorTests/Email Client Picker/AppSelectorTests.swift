import XCTest
@testable import WordPressAuthenticator


struct URLMocks {

    static let mockAppList = ["gmail": "googlemail://", "airmail": "airmail://"]
}

class AppSelectorTests: XCTestCase {

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

    func testAppSelectorTitlesLocallizedReturnCorrectStrings() {
        let appleMail = AppSelectorTitles.appleMail
        let gmail = AppSelectorTitles.gmail
        let airmail = AppSelectorTitles.airmail
        let msOutlook = AppSelectorTitles.msOutlook
        let spark = AppSelectorTitles.spark
        let yahooMail = AppSelectorTitles.yahooMail
        let fastMail = AppSelectorTitles.fastmail
        let cancel = AppSelectorTitles.cancel

        XCTAssertEqual(appleMail.localized, NSLocalizedString("Mail (Default)", comment: "Option to select the Apple Mail app when logging in with magic links"))
        XCTAssertEqual(gmail.localized, NSLocalizedString("Gmail", comment: "Option to select the Gmail app when logging in with magic links"))
        XCTAssertEqual(airmail.localized, NSLocalizedString("Airmail", comment: "Option to select the Airmail app when logging in with magic links"))
        XCTAssertEqual(msOutlook.localized, NSLocalizedString("Microsoft Outlook", comment: "Option to select the Microsft Outlook app when logging in with magic links"))
        XCTAssertEqual(spark.localized, NSLocalizedString("Spark", comment: "Option to select the Spark email app when logging in with magic links"))
        XCTAssertEqual(yahooMail.localized, NSLocalizedString("Yahoo Mail", comment: "Option to select the Yahoo Mail app when logging in with magic links"))
        XCTAssertEqual(fastMail.localized, NSLocalizedString("Fastmail", comment: "Option to select the Fastmail app when logging in with magic links"))
        XCTAssertEqual(cancel.localized, NSLocalizedString("Cancel", comment: "Option to cancel the email app selection when logging in with magic links"))
    }
}
