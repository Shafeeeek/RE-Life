import SwiftUI

struct WelcomeView: View {

    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.05, blue: 0.12),
                    Color(red: 0.12, green: 0.10, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 35) {

                Spacer()

                Text("🔥")
                    .font(.system(size: 90))

                Text("WELCOME TO\nRE-LIFE")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Text("Break the cycle.\nRebuild your brain.\nBecome your strongest self.")
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 40)

                Spacer()

                VStack(spacing: 20) {

                    FeatureRow(icon: "flame.fill", text: "Track your streak")
                    FeatureRow(icon: "trophy.fill", text: "Unlock achievements")
                    FeatureRow(icon: "brain.head.profile", text: "Rewire your brain")
                    FeatureRow(icon: "bolt.fill", text: "Beat urges instantly")

                }
                .padding(.horizontal, 40)

                Spacer()

                Button {

                    hasSeenWelcome = true

                } label: {

                    Text("START MY JOURNEY")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct FeatureRow: View {

    let icon: String
    let text: String

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.system(size: 20))

            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))

            Spacer()
        }
    }
}

#Preview {
    WelcomeView()
}
