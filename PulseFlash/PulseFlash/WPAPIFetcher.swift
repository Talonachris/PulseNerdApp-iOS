import Foundation
import Combine

class WPAPIFetcher: ObservableObject {
    @Published var stats: LocalStats = .empty
    @Published var isConnected: Bool = false
    @Published var isDemoMode: Bool = false

    private var timer: Timer?
    private var cancellable: AnyCancellable?
    private var ipAddress: String = "127.0.0.1"
    private var port: Int = 3490

    init() {}

    func updateConnection(ip: String, port: Int) {
        self.ipAddress = ip
        self.port = port

        if timer == nil {
            startTimer()
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.fetchData()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func fetchData() {
        guard let url = URL(string: "http://\(ipAddress):\(port)/v1/all-stats") else {
            self.isConnected = false
            self.isDemoMode = true
            self.stats = LocalStats.demoData()
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WPAllStatsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    self.isConnected = false
                    self.isDemoMode = true
                    self.stats = LocalStats.demoData()
                }
            }, receiveValue: { response in
                let unpulsed = response.unpulsed
                let realtime = response.realtime

                let kps = Double(realtime.keys.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let cps = Double(realtime.clicks.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                let downloadSpeed = Self.parseSpeedString(realtime.download)
                let uploadSpeed = Self.parseSpeedString(realtime.upload)

                self.stats = LocalStats(
                    keys: 0,
                    clicks: 0,
                    download: 0,
                    upload: 0,
                    uptime: 0,
                    unpulsedKeys: unpulsed.keys,
                    unpulsedClicks: unpulsed.clicks,
                    unpulsedDownload: unpulsed.download,
                    unpulsedUpload: unpulsed.upload,
                    unpulsedUptime: unpulsed.uptime,
                    unpulsedScrolls: unpulsed.scrolls,
                    kps: kps,
                    cps: cps,
                    downloadSpeed: downloadSpeed,
                    uploadSpeed: uploadSpeed
                )
                self.isConnected = true
                self.isDemoMode = false
            })
    }

    static func parseSpeedString(_ speedString: String) -> Int {
        let cleaned = speedString.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
        if cleaned.hasSuffix("KB/s") {
            let kb = Double(cleaned.replacingOccurrences(of: "KB/s", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
            return Int(kb * 1024)
        } else if cleaned.hasSuffix("MB/s") {
            let mb = Double(cleaned.replacingOccurrences(of: "MB/s", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
            return Int(mb * 1024 * 1024)
        } else if cleaned.hasSuffix("GB/s") {
            let gb = Double(cleaned.replacingOccurrences(of: "GB/s", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
            return Int(gb * 1024 * 1024 * 1024)
        }
        return 0
    }
}

// 📊 Neues Struct für /v1/all-stats
struct WPAllStatsResponse: Codable {
    let unpulsed: WPUnpulsedResponse
    let realtime: WPRealtimeStats
}

struct WPUnpulsedResponse: Codable {
    let clicks: Int
    let download: Int
    let keys: Int
    let upload: Int
    let uptime: Int
    let scrolls: Int
}

struct WPRealtimeStats: Codable {
    let clicks: String
    let keys: String
    let download: String
    let upload: String
}

extension LocalStats {
    static func demoData() -> LocalStats {
        return LocalStats(
            keys: 0,
            clicks: 0,
            download: 0,
            upload: 0,
            uptime: 0,
            unpulsedKeys: 123456,
            unpulsedClicks: 98765,
            unpulsedDownload: 12_345_678_901,
            unpulsedUpload: 2_345_678_901,
            unpulsedUptime: 987654,
            unpulsedScrolls: 321,
            kps: 4.2,
            cps: 5.1,
            downloadSpeed: 0,
            uploadSpeed: 0
        )
    }
}
