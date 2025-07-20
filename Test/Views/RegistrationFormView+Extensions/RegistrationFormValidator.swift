import UIKit

final class RegistrationFormValidator {
  
  // MARK: - Properties
  
  weak var view: RegistrationFormView?
  
  // MARK: - Functions
  @objc func fieldsChanged() {
    guard let view = view else { return }
    
    let allFieldsFilled = !(view.firstNameField.text ?? "").isEmpty &&
    !(view.lastNameField.text ?? "").isEmpty &&
    !(view.passwordField.text ?? "").isEmpty &&
    !(view.confirmPasswordField.text ?? "").isEmpty
    
    view.registerButton.isEnabled = allFieldsFilled
    validateFields(showErrors: false)
  }
  
  @objc func registerTapped() {
    guard let view = view else { return }
    
    view.wasInaccuracy = true
    let isValid = validateFields(showErrors: true)
    
    if isValid {
      view.delegate?.registrationFormDidSubmit(name: view.firstNameField.text ?? "")
    } else {
      scrollToFirstError()
    }
  }
  
  @discardableResult
  func validateFields(showErrors: Bool) -> Bool {
    guard let view = view else { return false }
    
    var isValid = true
    
    if (view.firstNameField.text ?? "").count < 2 {
      if showErrors || !(view.firstNameField.text ?? "").isEmpty {
        showError(for: view.firstNameField, label: view.firstNameErrorLabel)
      }
      isValid = false
    } else {
      hideErrorAndRequirement(for: view.firstNameField, label: view.firstNameErrorLabel)
    }
    
    if (view.lastNameField.text ?? "").count < 2 {
      if showErrors || !(view.lastNameField.text ?? "").isEmpty {
        showError(for: view.lastNameField, label: view.lastNameErrorLabel)
      }
      isValid = false
    } else {
      hideErrorAndRequirement(for: view.lastNameField, label: view.lastNameErrorLabel)
    }
    
    let password = view.passwordField.text ?? ""
    
    if password.count < 6 || !containsUppercase(password) || !containsDigit(password) {
      if showErrors || !password.isEmpty {
        showError(for: view.passwordField, label: view.passwordErrorLabel)
      }
      isValid = false
    } else {
      hideErrorAndRequirement(for: view.passwordField, label: view.passwordErrorLabel)
    }
    
    if password != view.confirmPasswordField.text {
      if showErrors || !(view.confirmPasswordField.text ?? "").isEmpty {
        showError(for: view.confirmPasswordField, label: view.confirmPasswordErrorLabel)
      }
      isValid = false
    } else {
      hideErrorAndRequirement(for: view.confirmPasswordField, label: view.confirmPasswordErrorLabel)
    }
    
    return isValid
  }
  
  // MARK: - Private
  
  private func showError(for field: UITextField, label: UILabel) {
    label.isHidden = false
    label.textColor = .red
    field.layer.borderColor = UIColor.red.cgColor
    field.layer.borderWidth = 1.0
  }
  
  private func hideErrorAndRequirement(for field: UITextField, label: UILabel) {
    label.isHidden = true
    field.layer.borderColor = UIColor.clear.cgColor
    field.layer.borderWidth = 0
  }
  
  private func scrollToFirstError() {
    guard let view = view else { return }
    
    if let errorField = [view.firstNameField, view.lastNameField,
                         view.passwordField, view.confirmPasswordField]
      .first(where: { $0.layer.borderColor == UIColor.red.cgColor }) {
      
      view.scrollView.scrollRectToVisible(
        errorField.convert(errorField.bounds, to: view.scrollView),
        animated: true
      )
    }
  }
  
  private func containsUppercase(_ text: String) -> Bool {
    text.rangeOfCharacter(from: .uppercaseLetters) != nil
  }
  
  private func containsDigit(_ text: String) -> Bool {
    text.rangeOfCharacter(from: .decimalDigits) != nil
  }
  
  @objc func togglePasswordVisibility(_ sender: UIButton) {
    guard let view = view else { return }
    
    let textField = sender.tag == 0 ? view.passwordField : view.confirmPasswordField
    let wasFirstResponder = textField.isFirstResponder
    let selectedRange = textField.selectedTextRange
    
    textField.isSecureTextEntry.toggle()
    sender.setImage(
      UIImage(systemName: textField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"),
      for: .normal
    )
    
    if let text = textField.text {
      textField.text = ""
      textField.text = text
    }
    
    if wasFirstResponder {
      textField.selectedTextRange = selectedRange
    }
  }
}
