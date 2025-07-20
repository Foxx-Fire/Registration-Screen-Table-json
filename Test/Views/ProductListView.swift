import UIKit

protocol ProductListViewDelegate: AnyObject {
  func didTapGreet()
}

final class ProductListView: UIView {
  
  // MARK: - Properties
  
  weak var delegate: ProductListViewDelegate?
  
  // MARK: - UI Elements
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .clear
    return tableView
  }()
  
  private lazy var greetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Приветствие", for: .normal)
    button.setTitleColor(ColorSet.gray, for: .normal)
    button.addTarget(self, action: #selector(greetTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [tableView, greetButton])
    stack.axis = .vertical
    stack.spacing = 16
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = ColorSet.yellow
    setupViews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup Methods
  
  private func setupViews() {
    addSubview(mainStackView)
    addSubview(activityIndicator)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  // MARK: - Actions
  
  @objc private func greetTapped() {
    delegate?.didTapGreet()
  }
}
