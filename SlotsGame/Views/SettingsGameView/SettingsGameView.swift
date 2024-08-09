import SwiftUI

struct SettingsGameView: View {
    
    @Environment(\.presentationMode) var presmode
    
    @State var soundsApp = UserDefaults.standard.bool(forKey: "sounds_app") {
        didSet {
            UserDefaults.standard.set(soundsApp, forKey: "sounds_app")
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("settings_bg")
                    .resizable()
                    .frame(width: 600, height: 350)
                VStack {
                    Spacer()
                    Image("settings_title")
                        .resizable()
                        .frame(width: 500, height: 55)
                    Spacer()
                    Button {
                        presmode.wrappedValue.dismiss()
                    } label: {
                        Image("close_bttn")
                            .resizable()
                            .frame(width: 150, height: 60)
                    }
                    Spacer()
                    Image("sound_title")
                        .resizable()
                        .frame(width: 500, height: 55)
                    Spacer()
                    Button {
                        withAnimation(.linear(duration: 0.4)) {
                            soundsApp = !soundsApp
                        }
                    } label: {
                        HStack {
                            Image("sound_off")
                                .resizable()
                                .frame(width: 52, height: 52)
                            if soundsApp {
                                Image("slider_on")
                                    .resizable()
                                    .frame(width: 400, height: 30)
                            } else {
                                Image("slider_off")
                                    .resizable()
                                    .frame(width: 400, height: 30)
                            }
                            Image("sound_on")
                                .resizable()
                                .frame(width: 52, height: 52)
                        }
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
}

#Preview {
    SettingsGameView()
}
