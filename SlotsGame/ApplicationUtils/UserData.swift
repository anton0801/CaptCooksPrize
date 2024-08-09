import Foundation

class UserData: ObservableObject {
    
    var money: Int = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            UserDefaults.standard.set(money, forKey: "money")
        }
    }
    
    init() {
        if !UserDefaults.standard.bool(forKey: "is_not_first_start") {
            UserDefaults.standard.set(money, forKey: "money")
            self.money = 100000
            UserDefaults.standard.set(true, forKey: "is_not_first_start")
        }
    }
    
}
