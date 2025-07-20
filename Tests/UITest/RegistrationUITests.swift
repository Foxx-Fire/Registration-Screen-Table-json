
import XCTest

final class RegistrationUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testRegistrationButtonDisabledInitially() throws {
        let registerButton = app.buttons["Регистрация"]
        XCTAssertFalse(registerButton.isEnabled)
    }

    func testRegistrationFlow() throws {
        let firstName = app.textFields["Имя"]
        let lastName = app.textFields["Фамилия"]
        let password = app.secureTextFields["Пароль"]
        let confirmPassword = app.secureTextFields["Повторите пароль"]

        firstName.tap()
        firstName.typeText("Фред")

        lastName.tap()
        lastName.typeText("Иванов")

        password.tap()
        password.typeText("Test123")

        confirmPassword.tap()
        confirmPassword.typeText("Test123")

        let registerButton = app.buttons["Регистрация"]
        XCTAssertTrue(registerButton.isEnabled)
    }
}


