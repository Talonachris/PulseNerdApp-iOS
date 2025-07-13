import Foundation

struct LocalStats: Codable {
    let keys: Int
    let clicks: Int
    let download: Int
    let upload: Int
    let uptime: Int

    let unpulsedKeys: Int
    let unpulsedClicks: Int
    let unpulsedDownload: Int
    let unpulsedUpload: Int
    let unpulsedUptime: Int
    let unpulsedScrolls: Int

    let kps: Double           // Keys per second
    let cps: Double           // Clicks per second
    let downloadSpeed: Int    // Bytes/sec
    let uploadSpeed: Int      // Bytes/sec

    static let empty = LocalStats(
        keys: 0,
        clicks: 0,
        download: 0,
        upload: 0,
        uptime: 0,
        unpulsedKeys: 0,
        unpulsedClicks: 0,
        unpulsedDownload: 0,
        unpulsedUpload: 0,
        unpulsedUptime: 0,
        unpulsedScrolls: 0,
        kps: 0.0,
        cps: 0.0,
        downloadSpeed: 0,
        uploadSpeed: 0
    )
}
