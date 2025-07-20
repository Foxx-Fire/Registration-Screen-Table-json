
import UIKit

enum ColorSet {
  static var yellow: UIColor {
    UIColor(named: "BackgroundColor") ?? .yellow
  }
  
  static var brown: UIColor {
    UIColor(named: "ButtonColor") ?? .brown
  }
  
  static var gray: UIColor {
    UIColor(named: "TextColor") ?? .brown
  }
}
