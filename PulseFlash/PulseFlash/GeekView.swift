import SwiftUI

struct GeekView: View {
    @AppStorage("ipAddress") private var ipAddress: String = "127.0.0.1"
    @AppStorage("port") private var port: String = "3490"

    @StateObject private var fetcher = WPAPIFetcher()
    let formatter = WPAPIFormatter()

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 16
            let isPortrait = geo.size.height > geo.size.width
            let isLandscape = !isPortrait

            // Raster: 2×3 (Portrait), 3×2 (Landscape)
            let columnsCount = isPortrait ? 2 : 3
            let rowsCount    = isPortrait ? 3 : 2

            // Safe Areas / Padding
            let topPad: CGFloat = max(geo.safeAreaInsets.top, 12)
            let bottomPad: CGFloat = max(geo.safeAreaInsets.bottom, 12)

            // Verfügbare Fläche
            let outerHPad: CGFloat = spacing
            let availableWidth  = geo.size.width  - outerHPad * 2
            let availableHeight = geo.size.height - topPad - bottomPad

            // Sicherheitsmargen (gegen Rundung + Effekte)
            let epsilonW: CGFloat = 2
            let epsilonH: CGFloat = isPortrait ? 8 : 20   // ↑ Landscape deutlich mehr Luft

            // Zellgrößen berechnen
            let rawItemW  = (availableWidth  - CGFloat(columnsCount - 1) * spacing) / CGFloat(columnsCount)
            let rawItemH  = (availableHeight - CGFloat(rowsCount    - 1) * spacing) / CGFloat(rowsCount)
            let itemWidth  = floor(rawItemW) - epsilonW
            let itemHeight = floor(rawItemH) - epsilonH

            // Fixe Spalten
            let columns: [GridItem] = Array(
                repeating: GridItem(.fixed(itemWidth), spacing: spacing, alignment: .top),
                count: columnsCount
            )

            ZStack {
                // Hintergrund
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Color.clear.frame(height: topPad)

                    LazyVGrid(columns: columns, alignment: .center, spacing: spacing) {
                        AnimatedStatCard(
                            title: "Keys",
                            value: formatter.formatNumber(fetcher.stats.unpulsedKeys),
                            icon: "⌨️",
                            subtitle: "\(formatter.formatRate(fetcher.stats.kps)) / sec",
                            showShadow: isPortrait   // 👈 Schatten nur im Portrait
                        )
                        .frame(width: itemWidth, height: itemHeight)

                        AnimatedStatCard(
                            title: "Clicks",
                            value: formatter.formatNumber(fetcher.stats.unpulsedClicks),
                            icon: "🖱",
                            subtitle: "\(formatter.formatRate(fetcher.stats.cps)) / sec",
                            showShadow: isPortrait
                        )
                        .frame(width: itemWidth, height: itemHeight)

                        AnimatedStatCard(
                            title: "Scrolls",
                            value: formatter.formatNumber(fetcher.stats.unpulsedScrolls),
                            icon: "🌀",
                            subtitle: nil,
                            showShadow: isPortrait
                        )
                        .frame(width: itemWidth, height: itemHeight)

                        AnimatedStatCard(
                            title: "Download",
                            value: formatter.formatBytes(fetcher.stats.unpulsedDownload),
                            icon: "⬇️",
                            subtitle: nil,
                            showShadow: isPortrait
                        )
                        .frame(width: itemWidth, height: itemHeight)

                        AnimatedStatCard(
                            title: "Upload",
                            value: formatter.formatBytes(fetcher.stats.unpulsedUpload),
                            icon: "⬆️",
                            subtitle: nil,
                            showShadow: isPortrait
                        )
                        .frame(width: itemWidth, height: itemHeight)

                        AnimatedStatCard(
                            title: "Uptime",
                            value: formatter.formatUptimeExtended(seconds: fetcher.stats.unpulsedUptime),
                            icon: "🕖",
                            subtitle: nil,
                            showShadow: isPortrait
                        )
                        .frame(width: itemWidth, height: itemHeight)
                    }
                    .padding(.horizontal, outerHPad)
                    .id(isPortrait ? "portrait" : "landscape")   // frisches Layout beim Rotieren
                    .transaction { $0.animation = nil }          // kein Zwischen-Quetschen

                    Color.clear.frame(height: bottomPad)
                }
                .onAppear {
                    fetcher.updateConnection(ip: ipAddress, port: Int(port) ?? 3490)
                }
                .onChange(of: ipAddress) { newValue in
                    fetcher.updateConnection(ip: newValue, port: Int(port) ?? 3490)
                }
                .onChange(of: port) { newValue in
                    fetcher.updateConnection(ip: ipAddress, port: Int(newValue) ?? 3490)
                }

                // Offline/Demo-Badge
                if !fetcher.isConnected {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .font(.headline)
                            Text("Not connected to client — showing demo stats")
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
                        .padding(.bottom, max(geo.safeAreaInsets.bottom, 12) + 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeOut(duration: 0.4), value: fetcher.isConnected)
                    }
                }
            }
        }
    }
}

// MARK: - Cards

struct AnimatedStatCard: View {
    let title: String
    let value: String
    let icon: String
    let subtitle: String?         // immer Platz für 1 Zeile reservieren
    var showShadow: Bool = true   // 👉 steuerbar je Orientation

    @State private var displayedValue: String = ""
    @ScaledMetric(relativeTo: .caption2) private var subtitleLineHeight: CGFloat = 14

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
                    withAnimation(.easeInOut(duration: 0.3)) { displayedValue = newValue }
                }
                .onAppear { displayedValue = value }

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(height: subtitleLineHeight)
            } else {
                Color.clear.frame(height: subtitleLineHeight)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

                shape
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.03), Color.blue.opacity(0.08)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        shape.stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 1)
                    // Wichtig: Schatten/Glow werden hier AUF die Form gelegt …
                    .mask(shape) // … und mit derselben Form hart beschnitten (kein Overflow!)
            }
        )
        .clipped(antialiased: true) // optional, schadet nicht
    }
}
