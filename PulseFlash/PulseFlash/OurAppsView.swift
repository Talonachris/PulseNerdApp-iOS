import SwiftUI

// Datenmodell für eine App
struct AppInfo: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
    let appStoreURL: URL
}

// Die eigentliche View mit allen Apps
struct OurAppsView: View {
    let apps: [AppInfo] = [
        AppInfo(
            iconName: "pulseview_icon",
            title: "PulseView",
            description: "The unofficial companion app for WhatPulse. View your keystrokes, clicks, bandwidth & more – with style.",
            appStoreURL: URL(string: "https://apps.apple.com/us/app/pulseview/id6746577408")!
        )
    ]
        // Weitere Apps kannst du hier einfach ergänzen

    var body: some View {
        ZStack {
            // Hintergrund in PulseFlash-Farben
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
                VStack(spacing: 32) {
                    Text("Our Apps")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top)

                    ForEach(apps) { app in
                        AppCardView(app: app)
                            .frame(maxWidth: 600)
                    }

                    Color.clear.frame(height: 60) // schöner Abschluss
                }
                .padding()
            }
        }
    }
}

// Einzelne App-Karte im PulseFlash-Design
struct AppCardView: View {
    let app: AppInfo

    var body: some View {
        VStack(spacing: 16) {
            Image(app.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.cyan.opacity(0.6), radius: 10)

            Text(app.title)
                .font(.title2.bold())
                .foregroundColor(.white)

            Text(app.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button(action: {
                UIApplication.shared.open(app.appStoreURL)
            }) {
                Text("View in App Store")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.cyan)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}
