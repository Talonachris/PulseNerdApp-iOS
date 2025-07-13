import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.03, green: 0.05, blue: 0.1),
                    Color(red: 0.0, green: 0.1, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    InfoSection(title: "About PulseNerd", items: [
                        InfoRow(title: "What is PulseNerd?", subtitle: "PulseNerd is a lightweight live viewer for your WhatPulse stats – optimized for landscape use on your desk or stream setup."),
                        InfoRow(title: "Runs locally", subtitle: "The app connects directly to your local WhatPulse client API and does not send or store any data."),
                        InfoRow(title: "Developed by Nebuliton", subtitle: "This app is developed and maintained by Nebuliton. Not affiliated with WhatPulse.")
                    ])
                    
                    InfoSection(title: "Use with care", items: [
                        InfoRow(title: "Use a cable", subtitle: "PulseNerd works best when plugged in – avoid frequent battery drains."),
                        InfoRow(title: "OLED burn-in protection", subtitle: "The app shifts pixels slightly to reduce burn-in. Still, avoid leaving it on-screen 24/7."),
                        InfoRow(title: "Use a device stand", subtitle: "Place your phone or tablet near your monitor for easy viewing of your stats."),
                        InfoRow(title: "No overheating risk", subtitle: "PulseNerd is very lightweight. But charging and direct sunlight can still warm up your phone."),
                        InfoRow(title: "Disclaimer", subtitle: "We do not take responsibility for screen or hardware damage. Please use PulseNerd responsibly.")
                    ])
                    
                    InfoSection(title: "Legal", items: [
                        Button(action: {
                            if let url = URL(string: "https://pulseview.nebuliton.de/pulseflash/flash_legal.html") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            InfoRow(title: "Privacy Policy", subtitle: "Read how PulseNerd handles your data (spoiler: it doesn't).")
                        }
                    ])
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let items: [Content]

    init(title: String, items: [Content]) {
        self.title = title
        self.items = items
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.cyan)
            ForEach(0..<items.count, id: \.self) { index in
                items[index]
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // ← volle Breite im Parent
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
}
