import SwiftUI

struct PulseCircleView: View {
    let icon: String
    let color: Color
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: size * 1.2, height: size * 1.2)
                .scaleEffect(1.1)
                .blur(radius: 4)

            Circle()
                .strokeBorder(color.opacity(0.4), lineWidth: 4)
                .frame(width: size, height: size)
                .shadow(color: color, radius: 10)

            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.5, height: size * 0.5)
                .foregroundColor(color)
        }
    }
}
