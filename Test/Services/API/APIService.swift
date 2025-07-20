
import Foundation
import OSLog

class APIService {
  
  // MARK: - Properties
  private let urlString: String
  private let logger: LoggerService = OSLogLogger.shared
  
  // MARK: - Init
  init(urlString: String = "https://fakestoreapi.com/products") {
      self.urlString = urlString
  }
  
  // MARK: - Functions
  func fetchProducts(completion: @escaping ([Product]?) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(nil)
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let data = data {
        let products = try? JSONDecoder().decode([Product].self, from: data)
        completion(products)
      } else {
        self.logger.logEvent(
            message: "[APIService ошибка]: \(error?.localizedDescription ?? "Неизвестно")",
            type: .error
        )
        completion(nil)
      }
    }.resume()
  }
}

