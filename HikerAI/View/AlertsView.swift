import SwiftUI

struct AlertsView: View {
    @ObservedObject var viewModel: HikeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let park = viewModel.selectedPark {
                Text("Current Alerts")
                    .foregroundColor(Color(hex: "2B5740"))
                    .font(.headline)
                    .padding(.bottom, 5)

                if viewModel.alerts.isEmpty {
                    Text("No alerts for this park.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Display alerts with no text truncation
                    ForEach(viewModel.alerts, id: \.id) { alert in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(alert.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineLimit(nil) // Remove line limit
                                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion

                            Text(alert.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)

                            if let url = URL(string: alert.url) {
                                Link("More Info", destination: url)
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "2B5740"))
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            } else {
                Text("No park selected.")
                    .font(.headline)
                    .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .onAppear {
            viewModel.fetchAlertsForSelectedPark()
        }
    }
}
