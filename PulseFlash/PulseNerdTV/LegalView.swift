import SwiftUI

struct LegalView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer(minLength: 60)

                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.cyan)

                Text("PulseNerd is an independent companion app that connects to the local WhatPulse Client API on your device.")
                    .foregroundColor(.white)

                Text("No Data Collection")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("This app does not collect, store, or transmit any personal or usage data. All data processing occurs locally on your device.")
                    .foregroundColor(.white.opacity(0.85))

                Text("API Usage")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("PulseNerd connects directly to the local WhatPulse Client API (running on your own machine) to fetch live and unpulsed statistics, including keystrokes, clicks, bandwidth, uptime, and system metrics.\n\nNo login, cloud sync, or transmission of private information to external servers occurs at any time.")
                    .foregroundColor(.white.opacity(0.85))

                Text("Third-Party Policy")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                VStack(alignment: .leading, spacing: 8) {
                    Text("PulseNerd relies solely on the official WhatPulse client running locally. For more details about WhatPulse and their own data policies, visit:")
                        .foregroundColor(.white.opacity(0.85))

                    Text("https://whatpulse.org/privacy")
                        .foregroundColor(.cyan)
                        .italic()
                }

                Text("Developer Info")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("This app is developed and published by Nebuliton.")
                    .foregroundColor(.white.opacity(0.85))

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
}
