import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("notif_booking")    private var bookingUpdates  = true
    @AppStorage("notif_messages")  private var hostMessages    = true
    @AppStorage("notif_promos")    private var promotions      = false
    @AppStorage("notif_reminders") private var tripReminders   = true
    @AppStorage("notif_prices")    private var priceAlerts     = false

    var body: some View {
        List {
            Section {
                notifRow("Booking Updates",    icon: "calendar.badge.checkmark", binding: $bookingUpdates)
                notifRow("Messages from Hosts", icon: "message.fill",             binding: $hostMessages)
                notifRow("Trip Reminders",      icon: "bell.fill",                binding: $tripReminders)
            } header: {
                Text("Trip Notifications")
            } footer: {
                Text("Receive alerts about your upcoming and active bookings.")
            }

            Section {
                notifRow("Promotions & Deals", icon: "tag.fill",    binding: $promotions)
                notifRow("Price Alerts",        icon: "chart.line.downtrend.xyaxis", binding: $priceAlerts)
            } header: {
                Text("Offers")
            } footer: {
                Text("Stay informed about exclusive deals and price drops for saved listings.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func notifRow(_ title: String, icon: String, binding: Binding<Bool>) -> some View {
        Toggle(isOn: binding) {
            Label(title, systemImage: icon)
        }
        .tint(Color.accentRed)
        .onChange(of: binding.wrappedValue) { _, _ in
            HapticService.trigger(.selection)
        }
    }
}

#Preview {
    NavigationStack { NotificationSettingsView() }
}
