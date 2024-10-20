import SwiftUI

struct HikeSummaryView: View {
    @ObservedObject var viewModel: HikeViewModel
    @State private var tripStarted = false  // State to track whether the trip has started
    @State private var showingAddContacts = false  // To manage showing Add Contacts modal
    @State private var contacts: [EmergencyContact] = []  // List of contacts
    @State private var showSOS = false      // State to show the SOS view


    var body: some View {
        ZStack {
            // Conditional background image
            if tripStarted {
                // Replace "trail_background" with your image asset name
                Image("trail_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                if !tripStarted {
                    // Fixed top part (Location, Contacts, Start Trip)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let selectedPark = viewModel.selectedPark {
                            Text(selectedPark.fullName)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        } else {
                            Text("No park selected.")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }

                        Divider()

                        // Emergency contacts
                        HStack {
                            Text("Emergency contacts")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                showingAddContacts = true  // Show Add Contacts modal
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Add contacts")
                                }
                                .foregroundColor(.primary)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $showingAddContacts) {
                                AddContactsView(isPresented: $showingAddContacts, contacts: $contacts)
                            }
                        }

                        // Display added contacts (if there are any)
                        if !contacts.isEmpty {
                            ForEach(contacts, id: \.id) { contact in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Name: \(contact.name)")
                                    Text("Phone: \(contact.phone)")
                                    Text("Relation: \(contact.relation)")
                                }
                                .padding(.vertical, 5)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            }
                        } else {
                            Text("No contacts added yet.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // Start trip button
                        Button(action: {
                            tripStarted = true  // Start the trip and change layout
                        }) {
                            Text("Start trip")
                                .fontWeight(.bold)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(hex: "2B5740"))
                                .cornerRadius(10)
                        }
                        .padding(.top, 15)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                }

                // Scrollable section for the rest of the content
                ScrollView {
                    VStack(spacing: 20) {
                        if tripStarted {
                            // The layout once the trip has started (new design)
                            VStack(alignment: .center, spacing: 5) {
                                Text(viewModel.selectedPark?.fullName ?? "Half Dome")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.init(top: 40, leading: 16, bottom: 0, trailing: 16))


                            HStack {
                                VStack {
                                    Text("Time on trail")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("00:00")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                VStack {
                                    Text("Distance covered")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("00.00")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()

                            // Current Conditions card
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Current Conditions")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Temperature")
                                            .font(.subheadline)
                                        Text("68°F")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Sunset in")
                                            .font(.subheadline)
                                        Text("4h 32m")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                }
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Wind")
                                            .font(.subheadline)
                                        Text("8 mph NW")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Precipitation")
                                            .font(.subheadline)
                                        Text("Last 24 hrs: 0mm")
                                        Text("Next 24 hrs: 0mm")
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 1)
                            .padding(.horizontal)

                            // Status card
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Status")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                HStack {
                                    Text("Tracking")
                                    Spacer()
                                    Text("Active")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                        .padding(5)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                Divider()
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("Last satellite ping")
                                        Spacer()
                                        Text("2 min ago")
                                            .foregroundColor(.secondary)
                                    }
                                    HStack {
                                        Text("Emergency contacts updated")
                                        Spacer()
                                        Text("45 min ago")
                                            .foregroundColor(.secondary)
                                    }
                                    HStack {
                                        Text("Next check-in")
                                        Spacer()
                                        Text("45 min ago")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                        }

                        // **Essential Safety Information** section (as before)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Essential Safety Information")
                                .font(.headline)
                                .foregroundColor(.primary)

                            if let selectedPark = viewModel.selectedPark {
                                Text(selectedPark.fullName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Updated 2 hours ago")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            AlertsView(viewModel: viewModel)

                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
            }
            
            if tripStarted {
                VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                // Add SOS action here
                                showSOS = true
                            }) {
                                Text("SOS!")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 50)
                                    .background(Color.red)
                                    .cornerRadius(25)
                            }
                            .padding()
                            .padding(.bottom, 40)
                        }
                    }

            }
            
            Spacer()
            
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showSOS) {
                    SOSBotView()  // Present SOS Bot view when SOS is triggered
                }// Background color
        
        
    }
    
    
}







struct HikeTabView: View {
    @ObservedObject var viewModel: HikeViewModel

    var body: some View {
        TabView {
            // Home Tab
            HikeSummaryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            // Chat Tab
            ChatView(
                parkName: viewModel.selectedPark?.fullName ?? "Unknown Park",  // Safely unwrap park name
                packedItems: viewModel.hikerDetails.items.map { $0.name }.joined(separator: ", ")  // Combine packed items into a string
            )
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
        }
        .accentColor(Color(hex: "2B5740"))  // Set the accent color to match your style
    }
}

