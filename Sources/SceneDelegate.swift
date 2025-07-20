
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: windowScene)
    
    let userName = UserDefaults.standard.string(forKey: "UserName")
    let rootVC: UIViewController
    
    if let name = userName {
      let productVC = ProductViewController()
      productVC.username = name
      rootVC = UINavigationController(rootViewController: productVC)
    } else {
      rootVC = UINavigationController(rootViewController: RegistrationViewController())
    }
    
    window.rootViewController = rootVC
    window.makeKeyAndVisible()
    self.window = window
  }
}

