
import UIKit

class ProductCell: UITableViewCell {
  static let identifier = "ProductCell"
  
  func configure(with title: String, price: Double) {
    textLabel?.text = "\(title) — $\(price)"
    textLabel?.textColor = ColorSet.gray
    backgroundColor = .clear
  }
}

