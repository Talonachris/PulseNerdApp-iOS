import SwiftUI
import AVFoundation

struct PulseView: View {
    @State private var isPulsing = false
    @State private var animate = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.05),
                    Color(red: 0.0, green: 0.08, blue: 0.18)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 60) {
                Text("PULSE NOW")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.cyan)

                ZStack {
                    Circle()
                        .fill(Color.cyan.opacity(0.12))
                        .frame(width: 160, height: 160)
                        .scaleEffect(animate ? 1.4 : 1.0)
                        .opacity(animate ? 0.2 : 0.35)
                        .animation(.easeOut(duration: 1.0).repeatForever(autoreverses: true), value: animate)

                    Circle()
                        .fill(Color.cyan.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .shadow(color: .cyan, radius: 16)

                    Image("wp-nb")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.25), value: isPulsing)
                }
                .onTapGesture {
                    triggerPulse()
                }

                Text("Tap to send your Pulse!")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .padding()
        }
        .onAppear {
            animate = true
        }
    }

    func triggerPulse() {
        isPulsing = true
        playBark()
        sendPulse()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isPulsing = false
        }
    }

    func playBark() {
        guard let url = Bundle.main.url(forResource: "barkingpelle", withExtension: "mp3") else {
            print("🐶 Sounddatei nicht gefunden!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("🔇 Fehler beim Abspielen: \(error.localizedDescription)")
        }
    }

    func sendPulse() {
        let ipAddress = UserDefaults.standard.string(forKey: "ipAddress") ?? "127.0.0.1"
        let port = UserDefaults.standard.string(forKey: "port") ?? "3490"

        guard let url = URL(string: "http://\(ipAddress):\(port)/v1/pulse") else {
            print("❌ Ungültige IP oder Port")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("📡 Pulse fehlgeschlagen: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("✅ Pulse gesendet! Status: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
