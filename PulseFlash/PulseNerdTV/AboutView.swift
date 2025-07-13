import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Spacer(minLength: 60)

                // 🔹 App Icon mit PulseCircleView
                HStack {
                    Spacer()
                    ZStack {
                        PulseCircleView(icon: "bolt.fill", color: .cyan, size: 200)
                        Image("pulseflash_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 6)
                    }
                    Spacer()
                }

                // 🔹 App Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("📺 About PulseNerd")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.cyan)

                    Text("PulseNerd is a WhatPulse companion app, optimized for Apple TV. It shows real-time stats like keystrokes, clicks, bandwidth, and uptime — all in stunning visuals and live charts. Ideal for streamers, data lovers and curious minds.")
                        .foregroundColor(.white.opacity(0.85))
                        .font(.body)
                }

                // 🔹 Haiku Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("🧠 Haiku Mode")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.cyan)

                    Text("""
                    Clicks in perfect sync  
                    Charts unfold on glowing screens  
                    Nerds rejoice again
                    """)
                        .font(.callout)
                        .foregroundColor(.white)
                        .italic()
                        .padding(.leading, 10)
                }

                // 🔹 Legal Link
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink(destination: LegalView()) {
                        Text("📜 Legal & Privacy")
                            .foregroundColor(.cyan)
                            .font(.headline)
                    }
                }

                // 🔹 Footer
                VStack(alignment: .leading, spacing: 6) {
                    Divider().background(Color.white.opacity(0.2))

                    Text("© Nebuliton – made with ❤️ by Talonachris")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Text("Version \(appVersion) (Build \(buildNumber))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                Spacer(minLength: 60)
            }
            .padding(.horizontal, 60)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.07, green: 0.09, blue: 0.13)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}
