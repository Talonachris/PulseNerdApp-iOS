import SwiftUI

struct GeekView: View {
    @AppStorage("ipAddress") private var ipAddress: String = "127.0.0.1"
    @AppStorage("port") private var port: String = "3490"
    
    @StateObject private var fetcher = WPAPIFetcher()
    let formatter = WPAPIFormatter()
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 16
            let isPortrait = geometry.size.height > geometry.size.width
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            
            let safeTop = geometry.safeAreaInsets.top
            let safeBottom = geometry.safeAreaInsets.bottom
            let tabBarHeight: CGFloat = 49
            let baseTopPadding: CGFloat = isPad ? 30 : (isPortrait ? 24 : 40)
            let baseBottomPadding: CGFloat = isPad ? 30 : (isPortrait ? 20 : 40)
            
            let columnCount = isPortrait ? 2 : 3
            let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer(minLength: safeTop + baseTopPadding)
                    
                    LazyVGrid(columns: columns, spacing: spacing) {
                        AnimatedStatCard(
                            title: "Keys",
                            value: formatter.formatNumber(fetcher.stats.unpulsedKeys),
                            icon: "⌨️",
                            subtitle: "\(formatter.formatRate(fetcher.stats.kps)) / sec"
                        )
                        
                        AnimatedStatCard(
                            title: "Clicks",
                            value: formatter.formatNumber(fetcher.stats.unpulsedClicks),
                            icon: "🖱",
                            subtitle: "\(formatter.formatRate(fetcher.stats.cps)) / sec"
                        )
                        
                        AnimatedStatCard(
                            title: "Scrolls",
                            value: formatter.formatNumber(fetcher.stats.unpulsedScrolls),
                            icon: "🌀",
                            subtitle: nil
                        )
                        
                        AnimatedStatCard(
                            title: "Download",
                            value: formatter.formatBytes(fetcher.stats.unpulsedDownload),
                            icon: "⬇️",
                            subtitle: nil
                        )
                        
                        AnimatedStatCard(
                            title: "Upload",
                            value: formatter.formatBytes(fetcher.stats.unpulsedUpload),
                            icon: "⬆️",
                            subtitle: nil
                        )
                        
                        AnimatedStatCard(
                            title: "Uptime",
                            value: formatter.formatUptimeExtended(seconds: fetcher.stats.unpulsedUptime),
                            icon: "🕖",
                            subtitle: nil
                        )
                    }
                    .padding(.horizontal, spacing)
                    
                    Spacer(minLength: safeBottom + baseBottomPadding + tabBarHeight)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    fetcher.updateConnection(ip: ipAddress, port: Int(port) ?? 3490)
                }
                .onChange(of: ipAddress) { newValue in
                    fetcher.updateConnection(ip: newValue, port: Int(port) ?? 3490)
                }
                .onChange(of: port) { newValue in
                    fetcher.updateConnection(ip: ipAddress, port: Int(newValue) ?? 3490)
                }
            }
            
            if !fetcher.isConnected {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.headline)
                        Text("❌ Not connected to client! - Showing demo stats")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.9))
                            .shadow(color: Color.red.opacity(0.4), radius: 10, y: 4)
                    )
                    .padding(.bottom, safeBottom + 18)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeOut(duration: 0.4), value: fetcher.isConnected)
                }
            }
        }
    }
}

// Mit Animationen!
struct AnimatedStatCard: View {
    let title: String
    let value: String
    let icon: String
    let subtitle: String? // ⬅️ Neu!

    @State private var displayedValue: String = ""

    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 30))
                .padding(.top, 8)

            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.cyan)

            Text(displayedValue)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .onChange(of: value) { newValue in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        displayedValue = newValue
                    }
                }
                .onAppear {
                    displayedValue = value
                }

            // 👇 Untertitel z. B. „0.35 / sec“
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.03), Color.blue.opacity(0.08)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}
