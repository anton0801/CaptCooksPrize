import SwiftUI

struct DailyRewardsView: View {
    
    @StateObject private var viewModel = DailyRewardsViewModel()
    @Environment(\.presentationMode) var pr
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack {
            HStack {
                Button {
                    pr.wrappedValue.dismiss()
                } label: {
                    Image("menu_bttn")
                        .resizable()
                        .frame(width: 100, height: 50)
                }
                Spacer()
                Image("daily_rewards_title")
                    .resizable()
                    .frame(height: 70)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60)),
                GridItem(.fixed(60))
            ]) {
                ForEach(0..<viewModel.rewards.count, id: \.self) { day in
                    Button {
                        if viewModel.rewardStatus(forDay: day) == .available {
                            if let reward = viewModel.claimReward() {
                                userData.money += reward
                            }
                        }
                    } label: {
                        RewardView(day: day + 1, reward: viewModel.rewards[day], status: viewModel.rewardStatus(forDay: day))
                    }
                }
            }
        }
        .background(
            Image("daily_rewards_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height + 50)
                .ignoresSafeArea()
        )
    }
    
    
    func formattedTimeRemaining() -> String {
        guard let lastRewardDate = viewModel.lastRewardDate else { return "24:00:00" }
        let timeInterval = Date().timeIntervalSince(lastRewardDate)
        let timeRemaining = max(0, 24 * 60 * 60 - timeInterval)
        
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

#Preview {
    DailyRewardsView()
}

struct RewardView: View {
    let day: Int
    let reward: Int
    let status: RewardStatus
    
    var body: some View {
        VStack(spacing: 0) {
            if status == .available || status == .claimed {
                Text("DAY \(day)")
                    .font(.subheadline)
                    .font(.custom("K2D-ExtraBold", size: 24))
                    .foregroundColor(Color.init(red: 1, green: 38/255, blue: 207/255))
                    .padding(.vertical, 2)
                
                Image("daily_reward_unlocked")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                if status == .claimed {
                    Image("done")
                        .resizable()
                        .frame(width: 32, height: 32)
                } else {
                    Text("\(formatNumber(reward))")
                        .font(.custom("K2D-ExtraBold", size: 24))
                        .foregroundColor(Color.init(red: 1, green: 38/255, blue: 207/255))
                }
            } else {
                Text("DAY \(day)")
                    .font(.subheadline)
                    .font(.custom("K2D-ExtraBold", size: 24))
                    .foregroundColor(Color.init(red: 204/255, green: 204/255, blue: 204/255))
                    .padding(.vertical, 2)
                
                Image("daily_reward_locked")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("\(formatNumber(reward))")
                    .font(.custom("K2D-ExtraBold", size: 24))
                    .foregroundColor(Color.init(red: 204/255, green: 204/255, blue: 204/255))
            }
        }
        .frame(width: 100)
        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
    }
    
    func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let formattedNumber = Double(number) / 1000.0
            return String(format: "%.0fk", formattedNumber)
        } else {
            return String(number)
        }
    }
    
}
