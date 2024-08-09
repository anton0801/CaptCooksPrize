import SwiftUI

struct SlotsListView: View {
    
    @Environment(\.presentationMode) var pr
    
    @StateObject var viewModel = SlotViewModel()
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
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
                    Image("slots_list_title")
                        .resizable()
                        .frame(height: 70)
                    Spacer()
                }
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 30) {
                                ForEach(viewModel.slots.indices, id: \.self) { index in
                                    if viewModel.slots[index].isPurchased {
                                        NavigationLink(destination: SlotsGameView(slot: viewModel.slots[index])
                                            .navigationBarBackButtonHidden(true)
                                            .environmentObject(userData)) {
                                            SlotView(slot: viewModel.slots[index], isSelected: viewModel.selectedIndex == index)
                                                .id(index)
                                                .environmentObject(userData)
                                        }
                                    } else {
                                        SlotView(slot: viewModel.slots[index], isSelected: viewModel.selectedIndex == index)
                                            .id(index)
                                            .onTapGesture {
                                                withAnimation {
                                                    viewModel.selectSlot(at: index)
                                                }
                                            }
                                            .environmentObject(userData)
                                    }
                                    
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.selectedIndex) { newIndex in
                            withAnimation {
                                proxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                    }
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.moveToPrevious()
                            }
                        } label: {
                            Image("arrow_left")
                                .resizable()
                                .frame(width: 42, height: 42)
                        }
                        
                        Spacer()
                       
                        Button {
                            withAnimation {
                                viewModel.moveToNext()
                            }
                        } label: {
                            Image("arrow_right")
                                .resizable()
                                .frame(width: 42, height: 42)
                        }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SlotsListView()
        .environmentObject(UserData())
}

struct SlotView: View {
    var slot: Slot
    var isSelected: Bool
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            VStack {
                Image(slot.symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .animation(.spring())
                
            }
            if !slot.isPurchased {
                RoundedRectangle(cornerRadius: 18.0, style: .continuous)
                    .fill(.black.opacity(0.4))
                    .frame(width: 170, height: 150)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .padding(.bottom, 24)
                Image("locked_slot")
                    .resizable()
                    .frame(width: 150, height: 130)
                    .padding(.bottom)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                VStack {
                    Spacer()
                    NavigationLink(destination: SlotsListView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("open_btn")
                            .resizable()
                            .frame(width: 130, height: 50)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}
