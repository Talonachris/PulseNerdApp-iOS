import SwiftUI

struct HomeView: View {
    @StateObject private var fetcher = WPAPIFetcher()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color.cyan.opacity(0.1))
                                .frame(width: 140, height: 140)
                                .scaleEffect(1.1)
                                .blur(radius: 4)

                            Circle()
                                .strokeBorder(Color.cyan.opacity(0.4), lineWidth: 4)
                                .frame(width: 120, height: 120)
                                .shadow(color: .cyan, radius: 10)

                            Image("pulseflash_logo")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                                )
                                .shadow(color: .cyan.opacity(0.5), radius: 5)
                        }

                        Text("Welcome to")
                            .foregroundColor(.cyan)
                            .font(.title3)

                        Text("PulseNerd")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()

                        Text("Live view for your WhatPulse stats – optimized for landscape.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.horizontal)

                        Text("⚡️ Connect to your local WhatPulse client and enjoy real-time visual feedback.")
                            .font(.headline)
                            .foregroundColor(.cyan)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)

                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) {
                            FeatureRow(icon: "bolt.fill", title: "Real-Time Charts", subtitle: "Clicks, keys and bandwidth – updated every second.")
                            FeatureRow(icon: "arrow.triangle.2.circlepath", title: "Pulse Button", subtitle: "Instantly trigger a new pulse right from the app.")
                            FeatureRow(icon: "display", title: "Designed for Landscape", subtitle: "Perfect for desks, streamers and horizontal docks.")
                            FeatureRow(icon: "cpu.fill", title: "Runs Locally", subtitle: "Connects to the local WhatPulse client API.")
                            FeatureRow(icon: "sparkles", title: "Made with ❤️", subtitle: "A geek window for power users – from Nebuliton.")
                        }
                        .padding(.horizontal)

                        Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)

                        Text("🔗 Links")
                            .font(.headline)
                            .foregroundColor(.cyan)

                        HStack(alignment: .top, spacing: 32) {
                            Link(destination: URL(string: "https://nebuliton.io")!) {
                                VStack(spacing: 8) {
                                    Image("nebuliton_logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .shadow(color: .orange.opacity(0.3), radius: 8)

                                    Text("Nebuliton")
                                        .font(.footnote)
                                        .foregroundColor(.cyan)
                                }
                                .frame(width: 72)
                            }

                            Link(destination: URL(string: "https://whatpulse.org")!) {
                                VStack(spacing: 8) {
                                    Image("whatpulse_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .shadow(color: .cyan.opacity(0.5), radius: 8)

                                    Text("WhatPulse")
                                        .font(.footnote)
                                        .foregroundColor(.cyan)
                                }
                                .frame(width: 72)
                            }
                        }
                        .padding(.top, 24)

                        Spacer(minLength: 60)
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                                .foregroundColor(.cyan)
                                .padding(8)
                                .background(Color.cyan.opacity(0.1))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        }
                    }
                }
            }
        }

    struct FeatureRow: View {
        let icon: String
        let title: String
        let subtitle: String

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .bold()

                    Text(subtitle)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
    }
}
