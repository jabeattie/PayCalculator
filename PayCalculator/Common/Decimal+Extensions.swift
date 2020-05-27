import UIKit

extension Decimal {
    var cgFloat: CGFloat {
        CGFloat(truncating: self as NSDecimalNumber)
    }
}
