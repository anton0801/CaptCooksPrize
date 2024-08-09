import SwiftUI

struct SlotsGameView: View {
    
    var slot: Slot
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            if slot.symbol == "slots_1" {
                SlotsLeprekonGameView(slot: slot)
                    .environmentObject(userData)
            } else if slot.symbol == "slots_2" {
                ZeusSlotsView(slot: slot)
                    .environmentObject(userData)
            } else if slot.symbol == "slots_3" {
                SlotsEgyptView(slot: slot)
                    .environmentObject(userData)
            }
        }
    }
}

#Preview {
    SlotsGameView(slot: Slot(symbol: "slots_1", isPurchased: true, symbolsCount: 8))
        .environmentObject(UserData())
}
