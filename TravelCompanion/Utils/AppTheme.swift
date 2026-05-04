import SwiftUI
import UIKit

enum AppTheme {

    // MARK: - Colors

    enum Colors {
        // Brand
        static let primary      = Color(red: 0.91, green: 0.19, blue: 0.31)   // coral red  #E8304F
        static let primaryDark  = Color(red: 0.62, green: 0.08, blue: 0.18)   // deep red   #9E1430
        static let navy         = Color(red: 0.06, green: 0.10, blue: 0.18)   // deep navy  #0F1A2E
        static let gold         = Color(red: 1.00, green: 0.80, blue: 0.18)   // amber gold #FFCC2E
        static let coral        = Color(red: 1.00, green: 0.42, blue: 0.33)   // warm coral #FF6B55

        // Semantic
        static let success      = Color(red: 0.06, green: 0.72, blue: 0.51)   // emerald    #10B882
        static let warning      = Color(red: 0.95, green: 0.62, blue: 0.07)   // amber      #F29E12
        static let info         = Color(red: 0.05, green: 0.64, blue: 0.91)   // sky blue   #0DA3E8

        // Surfaces
        static let surface      = Color(UIColor.systemBackground)
        static let surfaceSecondary = Color(UIColor.secondarySystemBackground)
        static let surfaceTertiary  = Color(UIColor.tertiarySystemBackground)

        // Text
        static let textPrimary  = Color(UIColor.label)
        static let textSecondary = Color(UIColor.secondaryLabel)
        static let textTertiary  = Color(UIColor.tertiaryLabel)

        // Gradients
        static let brandGradient = LinearGradient(
            colors: [primary, primaryDark],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let navyGradient = LinearGradient(
            colors: [primary, navy],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let goldGradient = LinearGradient(
            colors: [gold, coral],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let cardGradient = LinearGradient(
            colors: [Color.white.opacity(0.0), Color.black.opacity(0.55)],
            startPoint: .top, endPoint: .bottom
        )
    }

    // MARK: - Typography

    enum Fonts {
        static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
            .system(size: 34, weight: weight, design: .rounded)
        }
        static func title(_ weight: Font.Weight = .bold) -> Font {
            .system(size: 28, weight: weight, design: .rounded)
        }
        static func title2(_ weight: Font.Weight = .semibold) -> Font {
            .system(size: 22, weight: weight, design: .rounded)
        }
        static func title3(_ weight: Font.Weight = .semibold) -> Font {
            .system(size: 20, weight: weight, design: .rounded)
        }
        static func headline(_ weight: Font.Weight = .semibold) -> Font {
            .system(size: 17, weight: weight)
        }
        static func body(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 17, weight: weight)
        }
        static func callout(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 16, weight: weight)
        }
        static func subheadline(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 15, weight: weight)
        }
        static func footnote(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 13, weight: weight)
        }
        static func caption(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 12, weight: weight)
        }
        static func caption2(_ weight: Font.Weight = .regular) -> Font {
            .system(size: 11, weight: weight)
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs:  CGFloat = 8
        static let sm:  CGFloat = 12
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 20
        static let xl:  CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum Radius {
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 12
        static let lg:  CGFloat = 16
        static let xl:  CGFloat = 20
        static let pill: CGFloat = 999
    }

    // MARK: - Shadows

    enum Shadow {
        static let card  = (color: Color.black.opacity(0.08), radius: CGFloat(8),  x: CGFloat(0), y: CGFloat(4))
        static let float = (color: Color.black.opacity(0.14), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
        static let brand = (color: Colors.primary.opacity(0.30), radius: CGFloat(12), x: CGFloat(0), y: CGFloat(6))
    }
}

// MARK: - View Modifiers

extension View {
    func themeCard() -> some View {
        self
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
            .shadow(color: AppTheme.Shadow.card.color,
                    radius: AppTheme.Shadow.card.radius,
                    x: AppTheme.Shadow.card.x,
                    y: AppTheme.Shadow.card.y)
    }

    func primaryButton() -> some View {
        self
            .font(AppTheme.Fonts.headline())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.Colors.brandGradient)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md, style: .continuous))
            .shadow(color: AppTheme.Shadow.brand.color,
                    radius: AppTheme.Shadow.brand.radius,
                    x: 0, y: AppTheme.Shadow.brand.y)
    }

    func secondaryButton() -> some View {
        self
            .font(AppTheme.Fonts.headline())
            .foregroundStyle(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.Colors.primary.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md, style: .continuous))
    }

    func chipStyle(isSelected: Bool = false) -> some View {
        self
            .font(AppTheme.Fonts.caption(.semibold))
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xxs + 2)
            .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.surfaceSecondary)
            .foregroundStyle(isSelected ? Color.white : AppTheme.Colors.textSecondary)
            .clipShape(Capsule())
    }
}

// MARK: - LogoView (reusable in-app logo mark)

struct VoyaLogoView: View {
    var size: CGFloat = 80
    var showWordmark: Bool = true

    var body: some View {
        VStack(spacing: size * 0.10) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.navyGradient)
                    .frame(width: size, height: size)
                    .shadow(color: AppTheme.Colors.primary.opacity(0.4), radius: 12, y: 6)

                // Globe ring
                Circle()
                    .stroke(Color.white.opacity(0.85), lineWidth: size * 0.04)
                    .frame(width: size * 0.68, height: size * 0.68)

                // Equator
                Rectangle()
                    .fill(Color.white.opacity(0.30))
                    .frame(width: size * 0.68, height: size * 0.018)

                // Flight arc
                ArcShape()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: size * 0.045, lineCap: .round))
                    .frame(width: size * 0.64, height: size * 0.64)

                // Gold pin
                Circle()
                    .fill(AppTheme.Colors.gold)
                    .frame(width: size * 0.12, height: size * 0.12)
                    .offset(x: size * 0.20, y: -size * 0.14)
            }

            if showWordmark {
                Text("VOYA")
                    .font(.system(size: size * 0.22, weight: .black, design: .rounded))
                    .foregroundStyle(Color.white)
                    .tracking(size * 0.02)
            }
        }
    }
}

private struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.14, y: h * 0.70))
        p.addCurve(
            to: CGPoint(x: w * 0.86, y: h * 0.36),
            control1: CGPoint(x: w * 0.42, y: h * 0.04),
            control2: CGPoint(x: w * 0.58, y: h * 0.04)
        )
        return p
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VoyaLogoView(size: 120)
    }
}
