
import UIKit

final class GreetingViewController: UIViewController {
  
  // MARK: - Properties
  
  private let username: String
  
  // MARK: - Init
  
  init(username: String) {
    self.username = username
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .formSheet
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColorSet.yellow
    setupUI()
  }
  
  // MARK: - Private
  
  private func setupUI() {
    let label = UILabel()
    label.text = "Добро пожаловать, \(username)!"
    label.font = .systemFont(ofSize: 25)
    label.textAlignment = .center
    label.numberOfLines = 0
    
    let button = UIButton(type: .system)
    button.setTitle("Закрыть", for: .normal)
    button.setTitleColor(ColorSet.brown, for: .normal)
    button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
      
      button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc private func closeTapped() {
    dismiss(animated: true)
  }
}


