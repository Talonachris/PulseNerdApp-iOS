import Foundation

struct WPAPIFormatter {
    
    func formatBytes(_ bytes: Int) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        var value = Double(bytes)
        var index = 0

        while value >= 1024 && index < units.count - 1 {
            value /= 1024
            index += 1
        }

        return String(format: "%.2f %@", value, units[index])
    }

    static func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }

    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","  // US-Style
        formatter.locale = Locale(identifier: "en_US") // Damit es überall gleich ist
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func formatSeconds(_ seconds: Int) -> String {
        return formatTime(seconds: seconds)
    }
   
    func formatUptimeExtended(seconds: Int) -> String {
        let years = seconds / (365 * 24 * 3600)
        let months = (seconds % (365 * 24 * 3600)) / (30 * 24 * 3600)
        let hours = (seconds % (30 * 24 * 3600)) / 3600
        let minutes = (seconds % 3600) / 60

        var components: [String] = []
        if years > 0 { components.append("\(years)y") }
        if months > 0 { components.append("\(months)m") }
        if hours > 0 { components.append("\(hours)h") }
        if minutes > 0 { components.append("\(minutes)m") }

        return components.joined(separator: " ")
    }
    func formatRate(_ rate: Double) -> String {
        String(format: "%.2f", rate)
    }
}
