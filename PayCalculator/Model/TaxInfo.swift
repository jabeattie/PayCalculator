import Foundation

struct TaxInfo: Codable {
    var code: TaxCode = .L
    var value: Decimal = 12500
    
    init(code: TaxCode = .L, value: Decimal = 12500) {
        self.code = code
        self.value = value
    }
    
    init(taxCode: String, isBlind: Bool) {
        var allowanceValue: Decimal = Decimal(string: taxCode.trimmingCharacters(in: .letters)) ?? 0
        if isBlind {
            allowanceValue += 229
        }
        self.code = TaxCode(rawValue: taxCode.trimmingCharacters(in: .decimalDigits)) ?? .L
        self.value = allowanceValue * 10
    }
}
