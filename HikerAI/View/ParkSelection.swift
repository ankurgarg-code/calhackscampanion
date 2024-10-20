import SwiftUI

struct ParkSelection: View {
    @ObservedObject var viewModel: HikeViewModel
    let latitude: Double
    let longitude: Double
    @State private var expandedParkIds: Set<String> = [] // Tracks which parks have expanded descriptions

    var body: some View {
        VStack {
            if viewModel.parks.isEmpty {
                Text("Fetching nearby parks...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.parks, id: \.id) { park in
                    VStack(alignment: .leading, spacing: 5) {
                        // Park Name (tap to select the park)
                        Text(park.fullName)
                            .font(.headline)
                            .foregroundColor(viewModel.selectedPark == park ? Color(hex: "2B5740") : .primary)
                            .bold()

                        // Park Description
                        Text(park.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(expandedParkIds.contains(park.id) ? nil : 2) // Expand or collapse description

                        // 'Read more' / 'Read less' button to toggle description
                        if park.description.count > 100 {
                            Button(action: {
                                toggleExpanded(for: park.id)
                            }) {
                                Text(expandedParkIds.contains(park.id) ? "Read less" : "Read more")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "2B5740"))
                            }
                            .buttonStyle(PlainButtonStyle()) // Avoid button effects
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                    .background(viewModel.selectedPark == park ? Color(.systemGray6) : Color.white) // Highlight selected item
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)  // Light shadow for each item
                    .contentShape(Rectangle()) // Make the entire area tappable
                    .onTapGesture {
                        viewModel.selectPark(park)  // Select the park when tapping the item
                    }
                }
                .listStyle(PlainListStyle())  // Cleaner list style
                .padding(.horizontal)
            }

            Spacer()

            // The 'Next' button, navigates to ItemInputScreen when a park is selected
            HStack {
                Spacer()

                NavigationLink(destination: ItemInputScreen(viewModel: viewModel)) {
                    HStack {
                        Text("next")
                            .font(.system(size: 18))
                            .foregroundColor(viewModel.selectedPark != nil ? Color(hex: "2B5740") : .gray)

                        Image(systemName: "arrow.right")
                            .foregroundColor(viewModel.selectedPark != nil ? Color(hex: "2B5740") : .gray)
                    }
                }
                .disabled(viewModel.selectedPark == nil)  // Disable if no park is selected
                .padding()
            }
            .padding([.trailing, .bottom], 20) // Align to bottom-right
        }
        .onAppear {
            // Fetch nearby parks based on the provided coordinates when the view appears
            viewModel.fetchNearbyParks(latitude: latitude, longitude: longitude)
        }
        .navigationTitle("Select a Park")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Toggle the expanded state of a park's description
    private func toggleExpanded(for parkId: String) {
        if expandedParkIds.contains(parkId) {
            expandedParkIds.remove(parkId)
        } else {
            expandedParkIds.insert(parkId)
        }
    }
}
