import SpriteKit
import SwiftUI

struct SlotsEgyptView: View {
    
    var slot: Slot
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            SpriteView(scene: EgyptSlotsScene(slot: slot))
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
    SlotsEgyptView(slot: Slot(symbol: "slots_3", isPurchased: true, symbolsCount: 9))    .environmentObject(UserData())
}
