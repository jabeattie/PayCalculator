import Foundation

//swiftlint:disable identifier_name
enum CategoryType: String, Codable {
    case pension
    case tax
    case ni
    case studentLoan
    case takeHomePay
    
    var description: String {
        return self.rawValue.stringFromCamelCase()
    }
}
