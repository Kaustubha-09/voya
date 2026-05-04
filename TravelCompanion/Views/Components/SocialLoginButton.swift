import SwiftUI

struct SocialLoginButton: View {
    enum Provider {
        case apple, google
        var label: String { self == .apple ? "Continue with Apple" : "Continue with Google" }
        var icon:  String { self == .apple ? "apple.logo"          : "globe"               }
    }

    let provider: Provider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: provider.icon)
                    .font(.body)
                Text(provider.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color(UIColor.separator), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        SocialLoginButton(provider: .apple)  { }
        SocialLoginButton(provider: .google) { }
    }
    .padding()
}
