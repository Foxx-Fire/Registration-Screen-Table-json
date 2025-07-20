import UIKit

protocol RegistrationFormViewDelegate: AnyObject {
  func registrationFormDidSubmit(name: String)
}

final class RegistrationFormView: UIView {
  
  // MARK: - Enums
  
  enum Constants {
    enum ContentView {
      static let top: CGFloat = 20
      static let bottom: CGFloat = -20
      static let leading: CGFloat = 20
      static let trailing: CGFloat = -20
      static let width: CGFloat = -40
    }
    enum Layout {
      static let buttonSize: CGFloat = 30
      static let rightInset: CGFloat = 8
      static let cornerRadius: CGFloat = 16
      static let stackSpacing: CGFloat = 10
    }
  }
  
  // MARK: - Properties
  
  weak var delegate: RegistrationFormViewDelegate?
  var wasInaccuracy = false
  var activeTextField: UITextField?
  let validator = RegistrationFormValidator()
  var keyboardHeight: CGFloat = 0
  var isKeyboardAdjustmentNeeded = false
  
  // MARK: - UI Elements
  
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.keyboardDismissMode = .interactive
    return view
  }()
  
  private lazy var contentView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = Constants.Layout.stackSpacing
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var firstNameField: UITextField = createTextField(
    placeholder: "Имя",
    returnKeyType: .next
  )
  
  lazy var firstNameErrorLabel: UILabel = createErrorLabel(
    text: "Имя должно содержать минимум 2 символа"
  )
  
  lazy var lastNameField: UITextField = createTextField(
    placeholder: "Фамилия",
    returnKeyType: .next
  )
  
  lazy var lastNameErrorLabel: UILabel = createErrorLabel(
    text: "Фамилия должна содержать минимум 2 символа"
  )
  
  lazy var birthDatePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.datePickerMode = .date
    picker.preferredDatePickerStyle = .wheels
    picker.translatesAutoresizingMaskIntoConstraints = false
    return picker
  }()
  
  lazy var passwordEyeButton: UIButton = createEyeButton(tag: 0)
  lazy var confirmPasswordEyeButton: UIButton = createEyeButton(tag: 1)
  
  lazy var passwordField: UITextField = createTextField(
    placeholder: "Пароль",
    returnKeyType: .next,
    isSecure: true
  )
  
  lazy var passwordErrorLabel: UILabel = createErrorLabel(
    text: "Пароль должен содержать не менее 6 символов, 1 заглавную букву и цифру"
  )
  
  lazy var confirmPasswordField: UITextField = createTextField(
    placeholder: "Повторите пароль",
    returnKeyType: .done,
    isSecure: true
  )
  
  lazy var confirmPasswordErrorLabel: UILabel = createErrorLabel(
    text: "Пароли должны совпадать"
  )
  
  lazy var registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Регистрация", for: .normal)
    button.setTitleColor(ColorSet.gray, for: .normal)
    button.setTitleColor(ColorSet.gray.withAlphaComponent(0.5), for: .disabled)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.isEnabled = false
    button.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var tapGesture: UITapGestureRecognizer = {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    return tap
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = ColorSet.yellow
    validator.view = self
    setupScrollView()
    setupContent()
    setupKeyboardNotifications()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Setup
  
  private func setupScrollView() {
    addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func setupContent() {
    scrollView.addSubview(contentView)
    scrollView.addGestureRecognizer(tapGesture)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: Constants.ContentView.top
      ),
      contentView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: Constants.ContentView.bottom
      ),
      contentView.leadingAnchor.constraint(
        equalTo: scrollView.leadingAnchor,
        constant: Constants.ContentView.leading
      ),
      contentView.trailingAnchor.constraint(
        equalTo: scrollView.trailingAnchor,
        constant: Constants.ContentView.trailing
      ),
      contentView.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: Constants.ContentView.width
      )
    ])
    
    contentView.addArrangedSubview(firstNameField)
    contentView.addArrangedSubview(firstNameErrorLabel)
    contentView.addArrangedSubview(lastNameField)
    contentView.addArrangedSubview(lastNameErrorLabel)
    contentView.addArrangedSubview(birthDatePicker)
    
    addPasswordFieldWithButton(field: passwordField, errorLabel: passwordErrorLabel)
    addPasswordFieldWithButton(field: confirmPasswordField, errorLabel: confirmPasswordErrorLabel)
    
    contentView.addArrangedSubview(registerButton)
  }
  
  private func createTextField(
    placeholder: String,
    returnKeyType: UIReturnKeyType = .next,
    isSecure: Bool = false
  ) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.textColor = ColorSet.gray
    textField.borderStyle = .roundedRect
    textField.returnKeyType = returnKeyType
    textField.isSecureTextEntry = isSecure
    textField.layer.borderColor = UIColor.clear.cgColor
    textField.layer.cornerRadius = Constants.Layout.cornerRadius
    textField.layer.masksToBounds = true
    textField.delegate = self
    textField.addTarget(self, action: #selector(fieldsChange), for: .editingChanged)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }
  
  private func createErrorLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = ColorSet.brown
    label.font = UIFont.systemFont(ofSize: 12)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  private func createEyeButton(tag: Int) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
    button.tintColor = ColorSet.gray
    button.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tag = tag
    return button
  }
  
  private func addPasswordFieldWithButton(
    field: UITextField,
    errorLabel: UILabel
  ) {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    
    let button = field == passwordField ? passwordEyeButton : confirmPasswordEyeButton
    
    container.addSubview(field)
    container.addSubview(button)
    
    let buttonRightOffset = field.borderStyle == .roundedRect ?
    -5 : -Constants.Layout.rightInset
    
    NSLayoutConstraint.activate([
      field.topAnchor.constraint(equalTo: container.topAnchor),
      field.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      field.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      field.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      
      button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      button.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: buttonRightOffset
      ),
      button.widthAnchor.constraint(
        equalToConstant: Constants.Layout.buttonSize
      ),
      button.heightAnchor.constraint(
        equalToConstant: Constants.Layout.buttonSize
      )
    ])
    
    let paddingView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: 40,
      height: field.frame.height
    ))
    field.rightView = paddingView
    field.rightViewMode = .always
    
    contentView.addArrangedSubview(container)
    contentView.addArrangedSubview(errorLabel)
  }
  
  //MARK: - Actions
  
  @objc private func registerTap() {
    validator.registerTapped()
  }
  
  @objc private func togglePassword(_ sender: UIButton) {
    validator.togglePasswordVisibility(sender)
  }
  
  @objc private func fieldsChange() {
    validator.fieldsChanged()
  }
  
  @objc private func dismissKeyboard() {
    endEditing(true)
  }
}
