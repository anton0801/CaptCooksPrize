import SwiftUI
import SpriteKit

struct SlotsLeprekonGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userData: UserData
    var slot: Slot
    
    var body: some View {
        VStack {
            SpriteView(scene: LeprekonSlotsView(slot: slot))
                .ignoresSafeArea()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("to_menu")), perform: { notif in
            guard let info = notif.userInfo,
                  let balance = info["balance"] as? Int else { return }
            userData.money = balance
            presMode.wrappedValue.dismiss()
        })
    }
    
}

#Preview {
    SlotsLeprekonGameView(slot: Slot(symbol: "slots_1", isPurchased: true, symbolsCount: 8))
        .environmentObject(UserData())
}
