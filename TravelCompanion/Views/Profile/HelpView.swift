import SwiftUI

struct HelpView: View {
    private let faqs: [(String, String)] = [
        ("How do I cancel a booking?",
         "Go to Trips → select your booking → tap Cancel Reservation. Cancellation policies vary by listing."),
        ("How do I contact my host?",
         "Once booked, visit your Trip Detail to find your host's contact information and message them directly."),
        ("What if something is wrong with the listing?",
         "Contact our 24/7 support team through the app. We investigate and resolve issues within 24 hours."),
        ("How are payments handled?",
         "Payments are processed securely via Stripe. Your card is charged at booking confirmation."),
        ("Can I modify my booking dates?",
         "Date modifications depend on host approval. Tap your booking and request a date change from the trip detail screen.")
    ]

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    ZStack {
                        Color.accentRed.opacity(0.1).clipShape(Circle())
                        Image(systemName: "headphones.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accentRed)
                    }
                    .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("24/7 Guest Support")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("We're here around the clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Contact")
            }

            Section("Frequently Asked Questions") {
                ForEach(faqs, id: \.0) { faq in
                    DisclosureGroup {
                        Text(faq.1)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 6)
                    } label: {
                        Text(faq.0)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }

            Section("Legal") {
                Link("Privacy Policy",      destination: URL(string: "https://www.apple.com")!)
                Link("Terms of Service",    destination: URL(string: "https://www.apple.com")!)
                Link("Cookie Policy",       destination: URL(string: "https://www.apple.com")!)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { HelpView() }
}
