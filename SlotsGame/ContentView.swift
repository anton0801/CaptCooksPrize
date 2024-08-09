import SwiftUI

struct ContentView: View {
    
    @StateObject var userData: UserData = UserData()
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack {
                    VStack {
                        NavigationLink(destination: DailyRewardsView()) {
                            Image("daily_bonus")
                                .resizable()
                                .frame(width: 160, height: 190)
                        }
                        .offset(y: -75)
//                        NavigationLink(destination: EmptyView()) {
//                            Image("ads_bonus")
//                                .resizable()
//                                .frame(width: 160, height: 190)
//                        }
//                        .offset(y: -80)
                    }
                    Spacer()
                }
                VStack {
                    ZStack {
                        Image("money_bg")
                            .resizable()
                            .frame(width: 200, height: 50)
                        Text("\(userData.money)")
                            .font(.custom("K2D-ExtraBold", size: 24))
                            .foregroundColor(.white)
                            .offset(x: -30)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsGameView()
                            .navigationBarBackButtonHidden(true)) {
                            Image("sttngs_bttn")
                                .resizable()
                                .frame(width: 150, height: 80)
                        }
                        Spacer()
                        NavigationLink(destination: SlotsListView()
                            .environmentObject(userData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("play_bttn")
                                .resizable()
                                .frame(width: 220, height: 140)
                        }
                        Spacer()
                        NavigationLink(destination: ShopListView()
                            .environmentObject(userData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("shop_bttn")
                                .resizable()
                                .frame(width: 150, height: 80)
                        }
                        Spacer()
                    }
                    
                }
            }
            .background(
                Image("menu_bg")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height + 50)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
