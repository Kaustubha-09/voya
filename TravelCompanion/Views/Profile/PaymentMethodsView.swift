import SwiftUI

private struct PaymentCard: Identifiable {
    let id: String
    let brand: String
    let last4: String
    let expiry: String
    let isDefault: Bool
    var icon: String { brand == "Visa" ? "creditcard.fill" : "creditcard" }
}

struct PaymentMethodsView: View {
    @State private var cards: [PaymentCard] = [
        PaymentCard(id: "c1", brand: "Visa",       last4: "4242", expiry: "12/27", isDefault: true),
        PaymentCard(id: "c2", brand: "Mastercard", last4: "8210", expiry: "05/26", isDefault: false)
    ]
    @State private var showAddCard = false

    var body: some View {
        List {
            Section("Saved Cards") {
                ForEach(cards) { card in
                    cardRow(card)
                }
            }

            Section {
                Button {
                    showAddCard = true
                } label: {
                    Label("Add Payment Method", systemImage: "plus.circle.fill")
                        .foregroundStyle(Color.accentRed)
                }
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCard) {
            AddCardSheet()
        }
    }

    private func cardRow(_ card: PaymentCard) -> some View {
        HStack(spacing: 14) {
            Image(systemName: card.icon)
                .font(.title2)
                .foregroundStyle(Color.accentRed)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(card.brand) •••• \(card.last4)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    if card.isDefault {
                        Text("Default")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.accentRed.opacity(0.12))
                            .foregroundStyle(Color.accentRed)
                            .clipShape(Capsule())
                    }
                }
                Text("Expires \(card.expiry)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Card Sheet (UI only)

struct AddCardSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardNumber = ""
    @State private var expiry     = ""
    @State private var cvv        = ""
    @State private var name       = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Card Details") {
                    TextField("Card number", text: $cardNumber).keyboardType(.numberPad)
                    HStack {
                        TextField("MM/YY", text: $expiry).keyboardType(.numberPad)
                        Divider()
                        TextField("CVV", text: $cvv).keyboardType(.numberPad)
                    }
                    TextField("Name on card", text: $name)
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        HapticService.trigger(.success)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(cardNumber.count < 16)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack { PaymentMethodsView() }
}
