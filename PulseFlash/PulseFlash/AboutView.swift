import SwiftUI

struct AboutView: View {
    @AppStorage("pelleTapCount") private var tapCount = 0
    @State private var showPelle = false
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Image("pulseflash_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)) // App-Icon-Style
                        .shadow(color: .cyan.opacity(0.6), radius: 20)
                        .onTapGesture {
                            tapCount += 1
                            if tapCount >= 3 {
                                withAnimation(.easeInOut) {
                                    showPelle = true
                                }
                                tapCount = 0
                            }
                        }
                    
                    Text("PulseNerd")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.cyan)
                    
                    Text("Version \(appVersion) (Build \(buildNumber))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 24) {
                            VStack(spacing: 6) {
                                Image("Talonachris")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                
                                Text("Talonachris")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.cyan)
                                
                                Text("Built PulseNerd with ❤️")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            
                            VStack(spacing: 6) {
                                Image("smitmartijn")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                
                                Text("smitmartijn")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.cyan)
                                
                                Text("Thanks for the WhatPulse Client API!")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    
                    Divider().background(Color.white.opacity(0.1)).padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        linkCard(imageName: "nebuliton_logo", title: "nebuliton.de", url: "https://nebuliton.de")
                        linkCard(imageName: "whatpulse_icon", title: "WhatPulse.org", url: "https://whatpulse.org")
                        linkCard(imageName: "Talonachris", title: "Talonachris.de", url: "https://www.talonachris.de/english-homepage")
                    }
                    
                    Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)
                    
                    Text("PulseNerd is a fan-made companion for the local WhatPulse Client API. No login, no cloud – just your data, live.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 About PulseNerd")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        Text("PulseNerd was built to bring your real-time stats to life – directly from your own machine.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("It runs offline, updates every second, and requires no account.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("💬 Feedback or questions?")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        Text("Visit Nebuliton.io or ping Talonachris on the WhatPulse Discord.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    Section(header: Text("Privacy").foregroundColor(.cyan)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PulseNerd collects nothing. It only talks to your local WhatPulse Client API on your device.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            Link("🖋️ PulseNerd Privacy", destination: URL(string: "https://pulseview.nebuliton.de/pulseflash/flash_legal.html")!)
                                .foregroundColor(.cyan)
                                .font(.footnote)
                            
                            Link("🖋️ WhatPulse Privacy", destination: URL(string: "https://whatpulse.org/privacy/")!)
                                .foregroundColor(.cyan)
                                .font(.footnote)
                        }
                    }
                    
                    Image("nebuliton_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .orange.opacity(0.4), radius: 10)
                        .padding(.top, 16)
                    
                    Text("PulseNerd is a Nebuliton app")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("© 2025 by Nebuliton")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            
            if showPelle {
                ZStack {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                showPelle = false
                            }
                        }
                    
                    VStack(spacing: 16) {
                        PulseyGlowView()
                            .padding(.top, 24)
                        
                        Text("Say hi to Pulsey – your stat buddy! 🎉")
                            .foregroundColor(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .transition(.scale)
                }
                .transition(.opacity)
            }
        }
    }
    
    func linkCard(imageName: String, title: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square")
                    .font(.footnote)
                    .foregroundColor(.cyan)
            }
            .padding(10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
    }
}
