import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showPulseEffect = false

    @AppStorage("ipAddress") private var ipAddress: String = "127.0.0.1"
    @AppStorage("port") private var port: String = "3490"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Globaler dunkler Background – liegt unter ALLEN Tabs + unter der TabBar
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.03, green: 0.05, blue: 0.10),
                        Color(red: 0.00, green: 0.10, blue: 0.20)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Tabs
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)

                    GeekView()
                        .tabItem { Label("Geek", systemImage: "bolt.fill") }
                        .tag(1)

                    PulseView()
                        .tabItem { Label("PULSE!", systemImage: "waveform.path.ecg") }
                        .tag(2)

                    CPSView()
                        .tabItem { Label("CPS", systemImage: "cursorarrow.click.2") }
                        .tag(3)

                    NetworkView()
                        .tabItem { Label("Network", systemImage: "arrow.up.arrow.down.circle") }
                        .tag(4)
                }
                .tint(.cyan)                                     // Akzentfarbe
                .toolbarBackground(.visible, for: .tabBar)       // nicht transparent
                .toolbarColorScheme(.dark, for: .tabBar)         // dunkles Farbschema
                .preferredColorScheme(.dark)                     // App-weit dunkel
                .onAppear(perform: configureTabBarAppearance)    // iOS 15+ ScrollEdge fix

                // Pulse-Effekt (Strahl)
                if showPulseEffect {
                    Capsule()
                        .fill(Color.cyan.opacity(0.6))
                        .frame(width: 10, height: 80)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 60)
                        .offset(y: -geometry.size.height)
                        .animation(.easeOut(duration: 0.6), value: showPulseEffect)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                showPulseEffect = false
                            }
                        }
                }
            }
        }
    }

    // Falls du den Effekt manuell triggern willst
    func triggerPulse() {
        let trimmedIP = ipAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPort = port.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedIP.isEmpty,
              !trimmedPort.isEmpty,
              let url = URL(string: "http://\(trimmedIP):\(trimmedPort)/v1/pulse") else {
            print("Invalid IP or Port")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Pulse failed: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Pulse response: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

// MARK: - TabBar Appearance (fix für „helle“ ScrollEdge-Variante)
private func configureTabBarAppearance() {
    let bg = UIColor(red: 0.03, green: 0.05, blue: 0.10, alpha: 1.0)
    let cyan = UIColor.systemCyan

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = bg

    // iPhone (stacked)
    appearance.stackedLayoutAppearance.selected.iconColor = cyan
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: cyan]

    // iPad (inline/compactInline)
    appearance.inlineLayoutAppearance.selected.iconColor = cyan
    appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: cyan]
    appearance.compactInlineLayoutAppearance.selected.iconColor = cyan
    appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: cyan]

    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
        UITabBar.appearance().scrollEdgeAppearance = appearance // verhindert hellen ScrollEdge
    }
}
