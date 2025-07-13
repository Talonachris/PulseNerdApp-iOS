import SwiftUI

struct PulseyGlowView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // 🟣 Innerer leuchtender Glow-Kreis (vollflächig)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .cyan.opacity(0.8),
                            .blue.opacity(0.6),
                            .black.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 180
                    )
                )
                .frame(width: 320, height: 320)
                .blur(radius: 32)

            // 🌀 Außenring – glowing, animierend
            Circle()
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .cyan, .blue, .purple, .blue, .cyan
                        ]),
                        center: .center
                    ),
                    lineWidth: 24
                )
                .frame(width: 360, height: 360)
                .blur(radius: 8)
                .opacity(0.9)
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(.linear(duration: 14).repeatForever(autoreverses: false), value: animate)
                .shadow(color: .cyan.opacity(0.3), radius: 30)

            // 🤖 Pulsey
            Image("pulsey")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .shadow(color: .cyan.opacity(0.3), radius: 16, x: 0, y: 4)
        }
        .frame(width: 400, height: 400)
        .onAppear {
            animate = true
        }
    }
}
