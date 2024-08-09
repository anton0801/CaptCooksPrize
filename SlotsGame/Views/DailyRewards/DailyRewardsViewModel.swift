import Foundation

enum RewardStatus {
    case claimed
    case available
    case locked
}

class DailyRewardsViewModel: ObservableObject {
    @Published var currentDay: Int
    @Published var lastRewardDate: Date?
    @Published var rewards: [Int]
    
    init() {
        self.currentDay = UserDefaults.standard.integer(forKey: "currentDay")
        self.lastRewardDate = UserDefaults.standard.object(forKey: "lastRewardDate") as? Date
        self.rewards = Array(0..<16).map { 10000 + ($0 * 5000) }
    }
    
    var canClaimReward: Bool {
        guard let lastRewardDate = lastRewardDate else { return true }
        return Date().timeIntervalSince(lastRewardDate) >= 24 * 60 * 60
    }
    
    func claimReward() -> Int? {
        guard canClaimReward else { return nil }
        
        let reward = rewards[currentDay % rewards.count]
        currentDay += 1
        lastRewardDate = Date()
        
        UserDefaults.standard.set(currentDay, forKey: "currentDay")
        UserDefaults.standard.set(lastRewardDate, forKey: "lastRewardDate")
        
        return reward
    }
    
    func rewardStatus(forDay day: Int) -> RewardStatus {
        if day < currentDay {
            return .claimed
        } else if day == currentDay && canClaimReward {
            return .available
        } else {
            return .locked
        }
    }
}
