import SwiftUI

struct TVNerdView: View {
    @StateObject private var fetcher = WPAPIFetcher()
    @State private var ipAddress: String = UserDefaults.standard.string(forKey: "last_tv_ip") ?? "127.0.0.1"
    @State private var port: String = UserDefaults.standard.string(forKey: "last_tv_port") ?? "3490"
    @State private var connectionMessage: String? = nil
    @FocusState private var focusedField: Field?

    enum Field {
        case ip, port
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.07, green: 0.09, blue: 0.13),
                        Color(red: 0.05, green: 0.07, blue: 0.10),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        let stats = fetcher.stats

                        Grid(horizontalSpacing: 40, verticalSpacing: 20) {
                            GridRow {
                                statBox(icon: "keyboard", title: "KEYSTROKES", value: "\(stats.unpulsedKeys)", extra: "KPS: \(format(stats.kps))")
                                statBox(icon: "cursorarrow.click", title: "CLICKS", value: "\(stats.unpulsedClicks)", extra: "CPS: \(format(stats.cps))")
                            }
                            GridRow {
                                statBox(icon: "arrow.down.circle", title: "DOWNLOAD", value: formatBytes(stats.unpulsedDownload))
                                statBox(icon: "arrow.up.circle", title: "UPLOAD", value: formatBytes(stats.unpulsedUpload))
                            }
                            GridRow {
                                statBox(icon: "clock", title: "UPTIME", value: formatUptime(stats.unpulsedUptime))
                                statBox(icon: "scroll", title: "SCROLLS", value: "\(stats.unpulsedScrolls)")
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.top, 40)
                        .padding(.bottom, 80)
                    }

                    // Verbindungshinweis (zentriert, dezent)
                    Text(fetcher.isConnected ? "✅ Connected" : "❌ Not connected - Showing demo stats")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

                    Divider().background(Color.white.opacity(0.1))

                    HStack(spacing: 24) {
                        // IP-Feld
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(focusedField == .ip ? Color.gray : Color.clear)
                                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                            TextField("127.0.0.1", text: $ipAddress)
                                .foregroundColor(.cyan)
                                .padding(.horizontal)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .accentColor(.black)
                                .focused($focusedField, equals: .ip)
                                .onAppear {
                                    UITextField.appearance().defaultTextAttributes = [.foregroundColor: UIColor.black]
                                }
                        }
                        .frame(width: 360, height: 45)

                        // Port-Feld
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(focusedField == .port ? Color.gray : Color.clear)
                                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                            TextField("3490", text: $port)
                                .foregroundColor(.cyan)
                                .padding(.horizontal)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .accentColor(.black)
                                .focused($focusedField, equals: .port)
                                .onAppear {
                                    UITextField.appearance().defaultTextAttributes = [.foregroundColor: UIColor.black]
                                }
                        }
                        .frame(width: 180, height: 45)

                        // Save-Button
                        Button("Save & Test") {
                            if let portInt = Int(port) {
                                saveConnectionSettings()
                                fetcher.updateConnection(ip: ipAddress, port: portInt)
                                connectionMessage = fetcher.isConnected ? "✅ Connected" : "❌ Failed"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    connectionMessage = nil
                                }
                            }
                        }
                        .foregroundColor(.cyan)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray))
                        .frame(height: 45)

                        Spacer()

                        // About-Button
                        NavigationLink(destination: AboutView()) {
                            Image(systemName: "info.circle.fill")
                                .font(.body)
                                .padding(8)
                                .background(Circle().fill(Color.cyan.opacity(0.2)))
                                .foregroundColor(.cyan)
                        }
                        .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                    .background(Color.black.opacity(0.1))
                }
            }
        }
        .onAppear {
            // ✅ Autoconnect bei App-Start
            if let savedPort = Int(port) {
                fetcher.updateConnection(ip: ipAddress, port: savedPort)
            }
        }
    }

    // MARK: - Private helpers

    private func statBox(icon: String, title: String, value: String, extra: String? = nil) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            if let extra = extra {
                Text(extra)
                    .font(.footnote)
                    .foregroundColor(.cyan)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.09, green: 0.11, blue: 0.17))
        .cornerRadius(16)
    }

    private func formatUptime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    private func saveConnectionSettings() {
        UserDefaults.standard.set(ipAddress, forKey: "last_tv_ip")
        UserDefaults.standard.set(port, forKey: "last_tv_port")
    }

    private func formatBytes(_ bytes: Int) -> String {
        let byteCount = Double(bytes)
        
        if byteCount >= 1_099_511_627_776 { // 1 TB
            return String(format: "%.2f TB", byteCount / 1_099_511_627_776)
        } else if byteCount >= 1_073_741_824 { // 1 GB
            return String(format: "%.2f GB", byteCount / 1_073_741_824)
        } else if byteCount >= 1_048_576 { // 1 MB
            return String(format: "%.1f MB", byteCount / 1_048_576)
        } else if byteCount >= 1024 {
            return String(format: "%.0f KB", byteCount / 1024)
        } else {
            return "\(bytes) B"
        }
    }

    private func format(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}
