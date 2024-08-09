import SwiftUI

struct ShopListView: View {
    
    @Environment(\.presentationMode) var pr
    
    @EnvironmentObject var userData: UserData
    @StateObject var viewModel = SlotViewModel()
    
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
                Image("shop_title")
                    .resizable()
                    .frame(height: 70)
                Spacer()
            }
            
            HStack {
                ForEach(viewModel.slots.filter { !$0.isPurchased }, id: \.id) { slot in
                    ShopSlotItem(slot: slot) {
                        userData.money -= slot.price!
                        let _ = viewModel.purchaseSlot(slot: slot)
                    }.environmentObject(userData)
                }
            }
            
        }
        .background(
            Image("slots_list_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height + 50)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ShopListView()
        .environmentObject(UserData())
}

struct ShopSlotItem: View {
    var slot: Slot
    @EnvironmentObject var userData: UserData
    var buyAction: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Image(slot.symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                    .animation(.spring())
                
            }
            if userData.money <= slot.price! {
                RoundedRectangle(cornerRadius: 18.0, style: .continuous)
                    .fill(.black.opacity(0.4))
                    .frame(width: 170, height: 150)
                    .padding(.bottom, 24)
                Image("not_enought_money")
                    .resizable()
                    .frame(width: 150, height: 130)
                    .padding(.bottom)
                
                ZStack {
                    Image("price_bg")
                        .resizable()
                        .frame(width: 170, height: 60)
                    Text("\(slot.price!)")
                        .font(.custom("K2D-ExtraBold", size: 22))
                        .foregroundColor(Color.init(red: 73/255, green: 18/255, blue: 0))
                        .offset(x: -10)
                }
                .offset(y: 90)
            } else {
                Button {
                    buyAction()
                } label: {
                    ZStack {
                        Image("price_bg")
                            .resizable()
                            .frame(width: 170, height: 60)
                        Text("\(slot.price!)")
                            .font(.custom("K2D-ExtraBold", size: 22))
                            .foregroundColor(Color.init(red: 1, green: 182/255, blue: 71/255))
                            .offset(x: -10)
                    }
                }
                .offset(y: 90)
            }
            
        }
    }
}
