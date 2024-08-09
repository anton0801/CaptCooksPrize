import SwiftUI
import SpriteKit

struct ZeusSlotsView: View {
    var slot: Slot
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            SpriteView(scene: ZeusSlotsScene(slot: slot))
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
    ZeusSlotsView(slot: Slot(symbol: "slots_2", isPurchased: true, symbolsCount: 8))    .environmentObject(UserData())
}
