import Foundation

extension Notification.Name {
    static let taxYearChange = Notification.Name("TaxYearChange")
}

class TaxYears: NSObject {
    static var shared = TaxYears()
    
    private(set) var taxYears: [TaxYear] = []
    
    override init() {
        super.init()
        loadYears()
    }
    
    private func loadYears() {
        guard let url = Bundle.main.url(forResource: "YearRates", withExtension: "plist") else { return }
        do {
            let data = try Data(contentsOf: url)
            self.taxYears = try PropertyListDecoder().decode([TaxYear].self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getTaxYear(year: TaxYear.Year) -> TaxYear {
        guard let taxYear = taxYears.first(where: { $0.name == year }) else {
            fatalError("Tax years have failed to load")
        }
        return taxYear
    }
}

struct TaxYear: Codable {
    let name: Year
    let salaryCap: Decimal
    let allowance: Decimal
    let taxLevels: [Tax]
    let niLevels: [NI]
    let studentLoanLevels: [StudentLoan]
    
    func getTaxRate(bracket: TaxBracket) -> Decimal {
        getTaxLevel(bracket: bracket)?.rate ?? 0
    }
    
    func getTaxThreshold(bracket: TaxBracket) -> Decimal {
        getTaxLevel(bracket: bracket)?.threshold ?? 0
    }
    
    func getNIRate(code: NICode, level: NILevel) -> Decimal {
        getNILevel(code: code, level: level)?.rate ?? 0
    }
    
    func getNIThreshold(code: NICode, level: NILevel) -> Decimal {
        getNILevel(code: code, level: level)?.threshold ?? 0
    }
    
    func getStudentLoanRate(plan: StudentLoanPlan) -> Decimal {
        getStudentLoanLevel(plan: plan)?.rate ?? 0
    }
    
    func getStudentLoanThreshold(plan: StudentLoanPlan) -> Decimal {
        getStudentLoanLevel(plan: plan)?.threshold ?? 0
    }
    
    private func getTaxLevel(bracket: TaxBracket) -> Tax? {
        taxLevels.first(where: { $0.taxBracket == bracket })
    }
    
    private func getNILevel(code: NICode, level: NILevel) -> NI.Level? {
        niLevels.first(where: { $0.code == code })?.levels.first(where: { $0.level == level })
    }
    
    private func getStudentLoanLevel(plan: StudentLoanPlan) -> StudentLoan? {
        studentLoanLevels.first(where: { $0.name == plan })
    }
}

extension TaxYear {

    enum Year: String, Codable {
        case y1819
        case y1920
        case y2021
        
        var displayName: String {
            switch self {
            case .y1819: return "18/19"
            case .y1920: return "19/20"
            case .y2021: return "20/21"
            }
        }
    }
    
    struct Tax: Codable {
        let taxBracket: TaxBracket
        let rate: Decimal
        let threshold: Decimal
    }
    
    //swiftlint:disable:next type_name
    struct NI: Codable {
        let code: NICode
        let levels: [Level]
    }
    
    struct StudentLoan: Codable {
        let name: StudentLoanPlan
        let rate: Decimal
        let threshold: Decimal
    }
}

extension TaxYear.NI {
    struct Level: Codable {
        let level: NILevel
        let rate: Decimal
        let threshold: Decimal
    }
}
