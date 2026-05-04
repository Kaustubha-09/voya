import SwiftUI

struct CategoryChipRow: View {
    @Binding var selected: StayCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(StayCategory.allCases) { category in
                    chip(category)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }

    private func chip(_ category: StayCategory) -> some View {
        let isSelected = category == selected

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selected = category
            }
            HapticService.trigger(.selection)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentRed : Color(UIColor.systemBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? Color.clear : Color(UIColor.separator), lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.accentRed.opacity(0.3) : Color.cardShadow,
                    radius: isSelected ? 6 : 2, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
    }
}

#Preview {
    CategoryChipRow(selected: .constant(.all))
        .padding(.vertical)
}
