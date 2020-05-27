import Foundation

enum StudentLoanPlan: String, Codable, CaseIterable {
    case none
    case plan1
    case plan2
    
    init?(displayName: String) {
        switch displayName {
        case StudentLoanPlan.none.displayName:
            self = .none
        case StudentLoanPlan.plan1.displayName:
            self = .plan1
        case StudentLoanPlan.plan2.displayName:
            self = .plan2
        default:
            return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .plan1: return "Plan 1"
        case .plan2: return "Plan 2"
        }
    }
}
