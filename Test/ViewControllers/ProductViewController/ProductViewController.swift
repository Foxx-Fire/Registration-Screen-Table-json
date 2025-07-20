
import UIKit

final class ProductViewController: UIViewController {
  
  private let viewModel = ProductViewModel()
  private let productListView = ProductListView()
  
  var username: String = "Пользователь"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Товары"
    view.backgroundColor = ColorSet.yellow
    setupNavigationBar()
    setupLogoutButton()
    setupLayout()
    bindViewModel()
    
    productListView.delegate = self
    productListView.activityIndicator.startAnimating()
    viewModel.fetchProducts()
  }
  
  private func setupNavigationBar() {
    navigationItem.hidesBackButton = true
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = ColorSet.yellow
    appearance.titleTextAttributes = [.foregroundColor: ColorSet.brown]
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.tintColor = ColorSet.brown
  }
  
  private func setupLayout() {
    view.addSubview(productListView)
    productListView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      productListView.topAnchor.constraint(equalTo: view.topAnchor),
      productListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      productListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      productListView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    productListView.tableView.dataSource = self
  }
  
  private func setupLogoutButton() {
    let logoutButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logoutTapped))
    logoutButton.tintColor = ColorSet.gray
    navigationItem.rightBarButtonItem = logoutButton
  }
  
  private func bindViewModel() {
    viewModel.didUpdate = { [weak self] in
      self?.productListView.activityIndicator.stopAnimating()
      self?.productListView.tableView.reloadData()
    }
  }
  
  @objc private func logoutTapped() {
    UserDefaults.standard.removeObject(forKey: "UserName")
    let registrationVC = RegistrationViewController()
    let navVC = UINavigationController(rootViewController: registrationVC)
    
    if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
      sceneDelegate.window?.rootViewController = navVC
    }
  }
}

// MARK: - ProductListViewDelegate
extension ProductViewController: ProductListViewDelegate {
  func didTapGreet() {
    let greetingVC = GreetingViewController(username: username)
    present(greetingVC, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension ProductViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let product = viewModel.item(at: indexPath.row)
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
    cell.configure(with: product.title ?? "Нет названия", price: product.price ?? 0)
    return cell
  }
}
