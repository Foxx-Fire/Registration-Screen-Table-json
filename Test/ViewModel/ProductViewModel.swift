
import Foundation

class ProductViewModel {
  
  // MARK: - Properties
  private let apiService = APIService()
  private(set) var products: [Product] = []
  
  var didUpdate: (() -> Void)?
  
  // MARK: - Functions
  func fetchProducts() {
    apiService.fetchProducts { [weak self] products in
      DispatchQueue.main.async {
        self?.products = products ?? [Product(title: "нет данных", price: 0)]
        self?.didUpdate?()
      }
    }
  }
  
  func numberOfItems() -> Int {
    return products.count
  }
  
  func item(at index: Int) -> Product {
    return products[index]
  }
}

