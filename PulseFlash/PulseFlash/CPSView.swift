import SwiftUI
import Charts

struct CPSView: View {
    @State private var cpsValues: [Double] = []
    @State private var timer: Timer?
    @State private var durationTimer: Timer?
    @State private var peakCPS: Double = 0
    @State private var averageCPS: Double = 0
    @State private var isRunning: Bool = false
    @State private var isReviewing: Bool = false
    @StateObject private var fetcher = WPAPIFetcher()
    @State private var lastClickCount: Int = 0
    @State private var lastTimestamp: Date = Date()
    @State private var duration: Int = 0
    @State private var hasMeasuredOnce = false
    @AppStorage("ipAddress") private var ipAddress: String = "127.0.0.1"
    @AppStorage("port") private var port: String = "3490"

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
                VStack(spacing: 24) {
                    Text("Clicks per Second")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.cyan)

                    Text(String(format: "%.2f", cpsValues.last ?? 0))
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, -8)

                    Chart {
                        ForEach(cpsValues.indices, id: \.self) { index in
                            LineMark(
                                x: .value("Time", index),
                                y: .value("CPS", cpsValues[index])
                            )
                            .interpolationMethod(.linear)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 160)
                    .padding(.horizontal)

                    VStack(spacing: 6) {
                        HStack {
                            Label("Peak", systemImage: "bolt.fill")
                            Spacer()
                            Text(String(format: "%.2f", peakCPS))
                        }

                        HStack {
                            Label("Average", systemImage: "waveform.path.ecg")
                            Spacer()
                            Text(String(format: "%.2f", averageCPS))
                        }

                        HStack {
                            Label("Samples", systemImage: "circle.grid.cross")
                            Spacer()
                            Text("\(cpsValues.count)")
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.cyan)
                    .padding(.horizontal)

                    HStack(spacing: 20) {
                        Button(action: startMeasurement) {
                            Text(isRunning ? "Running…" : "Start")
                                .bold()
                                .frame(minWidth: 80)
                                .padding()
                                .background(isRunning ? Color.green.opacity(0.1) : Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(10)
                        }
                        .disabled(isRunning)

                        Button(action: stopMeasurement) {
                            Text("Stop")
                                .bold()
                                .frame(minWidth: 80)
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                        .disabled(!isRunning)

                        Button(action: resetStats) {
                            Text("Reset")
                                .bold()
                                .frame(minWidth: 80)
                                .padding()
                                .background(Color.cyan.opacity(0.2))
                                .foregroundColor(.cyan)
                                .cornerRadius(10)
                        }
                    }

                    if isReviewing {
                        VStack(spacing: 8) {
                            Text("⏸ Review Mode – Tap Start to resume.")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Label("Peak CPS", systemImage: "flame.fill")
                                    Spacer()
                                    Text(String(format: "%.2f", peakCPS))
                                }

                                HStack {
                                    Label("Average CPS", systemImage: "waveform.path.ecg")
                                    Spacer()
                                    Text(String(format: "%.2f", averageCPS))
                                }

                                HStack {
                                    Label("Total Clicks", systemImage: "cursorarrow.click.2")
                                    Spacer()
                                    Text("\(Int(cpsValues.reduce(0, +)))")
                                }

                                HStack {
                                    Label("Total Duration", systemImage: "clock.arrow.circlepath")
                                    Spacer()
                                    Text("\(duration) seconds")
                                }
                            }
                            .font(.footnote)
                            .foregroundColor(.cyan)
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(10)

                            Button(action: shareResults) {
                                Label("Share Stats", systemImage: "square.and.arrow.up")
                                    .font(.footnote)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal)
                                    .background(Color.cyan.opacity(0.15))
                                    .cornerRadius(8)
                            }
                            .foregroundColor(.cyan)
                            .padding(.top, 4)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }

    func startMeasurement() {
        isRunning = true
        isReviewing = false

        fetcher.updateConnection(ip: ipAddress, port: Int(port) ?? 3490)

        lastClickCount = fetcher.stats.unpulsedClicks

        lastTimestamp = Date()

        // Start Dauer-Timer
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            duration += 1
        }

        // Poll-Logik mit Update nur bei Änderung
        // Poll-Logik mit Update nur bei Änderung
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            let currentClickCount = fetcher.stats.unpulsedClicks
            guard currentClickCount != lastClickCount else { return }

            let now = Date()
            let clickDelta = currentClickCount - lastClickCount
            let timeDelta = now.timeIntervalSince(lastTimestamp)
            guard timeDelta > 0 else { return }

            // Erstes Sample nur merken, nicht speichern
            if !hasMeasuredOnce {
                lastClickCount = currentClickCount
                lastTimestamp = now
                hasMeasuredOnce = true
                return
            }

            let newCPS = Double(clickDelta) / timeDelta

            if newCPS < 100 {
                cpsValues.append(newCPS)
                if cpsValues.count > 60 {
                    cpsValues.removeFirst()
                }

                peakCPS = max(peakCPS, newCPS)
                averageCPS = cpsValues.reduce(0, +) / Double(cpsValues.count)
            }

            lastClickCount = currentClickCount
            lastTimestamp = now
        }
    }

    func stopMeasurement() {
        timer?.invalidate()
        durationTimer?.invalidate()
        timer = nil
        durationTimer = nil
        fetcher.stopTimer()
        isRunning = false
        isReviewing = true
    }

    func resetStats() {
        timer?.invalidate()
        durationTimer?.invalidate()
        fetcher.stopTimer()
        cpsValues = []
        peakCPS = 0
        averageCPS = 0
        duration = 0
        isRunning = false
        isReviewing = false
    }

    func shareResults() {
        let appStoreLink = "" // später ergänzen
        let peak = String(format: "%.2f", peakCPS)
        let avg = String(format: "%.2f", averageCPS)
        let clicks = Int(cpsValues.reduce(0, +))

        var message = """
        PulseNerd™ Report: CPS ⚡️
        🔺 Peak: \(peak) | 🧮 Avg: \(avg)
        ⌚️ Duration: \(duration)s | 🖱 Total Clicks: \(clicks)
        """

        if !appStoreLink.isEmpty {
            message += "\n\n👉 Get the app: \(appStoreLink)"
        }

        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
