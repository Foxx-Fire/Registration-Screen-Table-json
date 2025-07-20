
import UIKit

// MARK: - UITextFieldDelegate

extension RegistrationFormView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
    validator.fieldsChanged()
    textField.returnKeyType = .done
    
    if keyboardHeight > 0 {
      adjustForKeyboard(activeField: textField)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
    validator.fieldsChanged()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case firstNameField:
      lastNameField.becomeFirstResponder()
    case lastNameField:
      passwordField.becomeFirstResponder()
    case passwordField:
      confirmPasswordField.becomeFirstResponder()
    default:
      textField.resignFirstResponder()
    }
    return true
  }
}
