import UIKit

// MARK: - Keyboard

extension RegistrationFormView {
  func setupKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrame),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
  }
  
  @objc private func keyboardWillChangeFrame(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
          let activeField = activeTextField else { return }
    
    let keyboardHeight = keyboardFrame.height
    let isKeyboardShowing = keyboardFrame.minY < UIScreen.main.bounds.height
    
    if isKeyboardShowing {
      self.keyboardHeight = keyboardHeight
      adjustForKeyboard(activeField: activeField)
    } else {
      resetKeyboardAdjustment()
    }
  }
  
  func adjustForKeyboard(activeField: UITextField) {
    let contentInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: keyboardHeight,
      right: 0
    )
    
    UIView.animate(withDuration: 0.25) {
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      
      let targetView = activeField == self.passwordField
      ? self.confirmPasswordField
      : activeField
      
      let targetFrame = targetView.convert(targetView.bounds, to: self.scrollView)
      let visibleHeight = self.scrollView.frame.height - self.keyboardHeight - 20
      
      if targetFrame.maxY > visibleHeight {
        let scrollPoint = CGPoint(
          x: 0,
          y: targetFrame.maxY - visibleHeight
        )
        self.scrollView.setContentOffset(scrollPoint, animated: false)
      }
    }
  }
  
  private func resetKeyboardAdjustment() {
    UIView.animate(withDuration: 0.25) {
      self.scrollView.contentInset = .zero
      self.scrollView.scrollIndicatorInsets = .zero
    }
  }
}
