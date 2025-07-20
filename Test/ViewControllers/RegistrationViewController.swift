import UIKit

final class RegistrationViewController: UIViewController {
  
  private let registrationFormView = RegistrationFormView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Регистрация"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = ColorSet.yellow
    appearance.titleTextAttributes = [.foregroundColor: ColorSet.brown]
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.tintColor = ColorSet.brown
    
    registrationFormView.delegate = self
    setupLayout()
  }
  
  private func setupLayout() {
    view.addSubview(registrationFormView)
    registrationFormView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      registrationFormView.topAnchor.constraint(equalTo: view.topAnchor),
      registrationFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      registrationFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      registrationFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

extension RegistrationViewController: RegistrationFormViewDelegate {
  func registrationFormDidSubmit(name: String) {
    UserDefaults.standard.set(name, forKey: "UserName")
    let productVC = ProductViewController()
    productVC.username = name
    navigationController?.pushViewController(productVC, animated: true)
  }
}
