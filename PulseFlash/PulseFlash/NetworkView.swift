import SwiftUI
import Charts

struct NetworkView: View {
    @StateObject private var fetcher = WPAPIFetcher()
    @State private var isRunning = false
    @State private var isReviewing = false
    
    @State private var downloadSamples: [(time: Date, mbps: Double)] = []
    @State private var uploadSamples: [(time: Date, mbps: Double)] = []
    
    @State private var peakDownload: Double = 0
    @State private var peakUpload: Double = 0
    @State private var avgDownload: Double = 0
    @State private var avgUpload: Double = 0
    
    @State private var totalDownloaded: Double = 0
    @State private var totalUploaded: Double = 0
    @State private var realDownloaded: Int = 0
    @State private var realUploaded: Int = 0
    
    @State private var startTime: Date?
    @State private var durationTimer: Timer?
    @State private var duration: Int = 0
    
    @State private var lastRx: Int = 0
    @State private var lastTx: Int = 0
    @State private var lastTimestamp: Date = Date()

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
                    Text("Network Usage")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.cyan)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 36))
                                .foregroundColor(.cyan)
                            Text(String(format: "%.2f Mbps", Double(downloadSamples.last?.mbps ?? 0)))                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("Download")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 36))
                                .foregroundColor(.cyan)
                            Text(String(format: "%.2f Mbps", Double(uploadSamples.last?.mbps ?? 0)))                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("Upload")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Group {
                        Text("Download")
                            .foregroundColor(.cyan)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(downloadSamples, id: \.time) { sample in                                LineMark(x: .value("Time", sample.time),
                                                                                                                     y: .value("Download", sample.mbps))
                            .interpolationMethod(.linear)
                            }
                        }
                        .chartYAxisLabel("Mbps")
                        .frame(height: 120)
                        .padding(.horizontal)
                        
                        VStack(spacing: 4) {
                            statRow(title: "Peak", value: peakDownload)
                            statRow(title: "Average", value: avgDownload)
                        }
                    }
                    
                    Group {
                        Text("Upload")
                            .foregroundColor(.cyan)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(uploadSamples, id: \.time) { sample in                                LineMark(x: .value("Time", sample.time),
                                                                                                                   y: .value("Upload", sample.mbps))
                            .interpolationMethod(.linear)
                            }
                        }
                        .chartYAxisLabel("Mbps")
                        .frame(height: 120)
                        .padding(.horizontal)
                        
                        VStack(spacing: 4) {
                            statRow(title: "Peak", value: peakUpload)
                            statRow(title: "Average", value: avgUpload)
                        }
                    }
                    
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
                                reviewRow(label: "Downloaded", value: Double(realDownloaded) / 1_000_000)
                                reviewRow(label: "Uploaded", value: Double(realUploaded) / 1_000_000)
                                reviewRow(label: "Duration", value: Double(duration), unit: "seconds")
                            }
                            .font(.footnote)
                            .foregroundColor(.cyan)
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(10)
                            
                            Button(action: shareStats) {
                                Label("Share Stats", systemImage: "square.and.arrow.up")
                                    .font(.footnote)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal)
                                    .background(Color.cyan.opacity(0.15))
                                    .cornerRadius(8)
                            }
                            .foregroundColor(.cyan)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    func statRow(title: String, value: Double) -> some View {
        HStack {
            Label(title, systemImage: title == "Peak" ? "bolt.fill" : "waveform.path.ecg")
            Spacer()
            Text(String(format: "%.2f Mbps", Double(value)))
        }
        .font(.footnote)
        .foregroundColor(.cyan)
        .padding(.horizontal)
    }
    
    func reviewRow(label: String, value: Double, unit: String = "MB") -> some View {
        HStack {
            Label(label, systemImage: label.contains("Download") ? "arrow.down.circle" : label.contains("Upload") ? "arrow.up.circle" : "clock")
            Spacer()
            Text(String(format: "%.2f \(unit)", value))
        }
    }
    
    func startMeasurement() {
        isRunning = true
        isReviewing = false
        fetcher.updateConnection(ip: ipAddress, port: Int(port) ?? 3490)
        startTime = Date()
        duration = 0
        lastRx = fetcher.stats.unpulsedDownload
        lastTx = fetcher.stats.unpulsedUpload
        realDownloaded = 0
        realUploaded = 0
        lastTimestamp = Date()
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            duration += 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard isRunning else { return }
            
            let stats = fetcher.stats
            let now = Date()
            let timeDelta = now.timeIntervalSince(lastTimestamp)
            
            guard timeDelta > 0 else { return }
            
            let currentRx = stats.unpulsedDownload
            let currentTx = stats.unpulsedUpload
            
            if currentRx != lastRx || currentTx != lastTx {
                // Erstes echtes Sample: nur merken, nicht speichern
                if !hasMeasuredOnce {
                    lastRx = currentRx
                    lastTx = currentTx
                    lastTimestamp = now
                    hasMeasuredOnce = true
                    return
                }
                
                let rxDelta = currentRx - lastRx
                let txDelta = currentTx - lastTx
                
                realDownloaded += rxDelta
                realUploaded += txDelta
                
                let mbpsRx = Double(rxDelta) * 8 / timeDelta / 1_000_000
                let mbpsTx = Double(txDelta) * 8 / timeDelta / 1_000_000
                
                guard mbpsRx >= 0, mbpsRx < 1000, mbpsTx >= 0, mbpsTx < 1000 else {
                    print("⚠️ Unrealistic spike detected – skipping sample. Rx: \(mbpsRx), Tx: \(mbpsTx)")
                    return
                }
                
                downloadSamples.append((time: now, mbps: mbpsRx))
                uploadSamples.append((time: now, mbps: mbpsTx))
                
                peakDownload = max(peakDownload, mbpsRx)
                peakUpload = max(peakUpload, mbpsTx)
                
                avgDownload = downloadSamples.map { $0.mbps }.reduce(0, +) / Double(downloadSamples.count)
                avgUpload = downloadSamples.map { $0.mbps }.reduce(0, +) / Double(uploadSamples.count)
                
                lastRx = currentRx
                lastTx = currentTx
                lastTimestamp = now
                
                let fiveMinutesAgo = now.addingTimeInterval(-300)
                downloadSamples.removeAll { $0.time < fiveMinutesAgo }
                uploadSamples.removeAll { $0.time < fiveMinutesAgo }
            }
        }
    }
    
    func stopMeasurement() {
        isRunning = false
        isReviewing = true
        durationTimer?.invalidate()
        durationTimer = nil
    }
    
    func resetStats() {
        isRunning = false
        isReviewing = false
        durationTimer?.invalidate()
        duration = 0
        downloadSamples = []
        uploadSamples = []
        peakDownload = 0
        peakUpload = 0
        avgDownload = 0
        avgUpload = 0
        totalDownloaded = 0
        totalUploaded = 0
        realDownloaded = 0
        realUploaded = 0
        startTime = nil
        hasMeasuredOnce = false
    }
    
    func shareStats() {
        let usedDownload = String(format: "%.2f MB", Double(realDownloaded) / 1_000_000)
        let usedUpload = String(format: "%.2f MB", Double(realUploaded) / 1_000_000)
        let totalUsed = String(format: "%.2f MB", Double(realDownloaded + realUploaded) / 1_000_000)
        
        let message = """
        Look at my network stats! 🤯
        Tracked with PulseNerd 💡
        
        📡 PulseNerd Report: Network
        🔽 Peak: \(String(format: "%.2f", peakDownload)) | 🧮 Avg: \(String(format: "%.2f", avgDownload)) Mbps
        🔼 Peak: \(String(format: "%.2f", peakUpload)) | 🧮 Avg: \(String(format: "%.2f", avgUpload)) Mbps
        ⌚️ Duration: \(duration)s
        📦 Downloaded: \(usedDownload)
        📤 Uploaded: \(usedUpload)
        📊 Total: \(totalUsed)
        
        #PulseNerd #NetworkTracking
        """
        
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
