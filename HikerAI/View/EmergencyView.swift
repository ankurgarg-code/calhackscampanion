import SwiftUI

struct EmergencyModeView: View {
    @State private var showSOSBot = false

    var body: some View {
        ZStack {
            Color(hex: "FDEDED").edgesIgnoringSafeArea(.all) // Light red background
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Close button action
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("⚠️ Emergency mode activated")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("• Emergency services notified\n• Emergency contacts notified\n• Location sharing active\n• Satellite connection stable")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showSOSBot = true
                        }) {
                            Text("I am lost")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showSOSBot = true
                        }) {
                            Text("I am injured")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                HStack {
                    TextField("Ask for tips, directions, and more", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            
            // Navigate to SOS Bot flow
            NavigationLink(destination: SOSBotView(), isActive: $showSOSBot) {
                EmptyView()
            }
        }
    }
}


import SwiftUI

struct SOSBotView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showSecondQuestion = false
    @State private var showThirdQuestion = false
    @State private var showNeedsQuestion = false
    
    @State private var isPhysicallyInjured: String? = nil
    @State private var isLocationSafe: String? = nil
    @State private var urgentNeed: String? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "FDEDED").edgesIgnoringSafeArea(.all)  // Light red background

            VStack(alignment: .leading, spacing: 20) {
                // Close button at the top-right corner
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                
                // Emergency mode header
                VStack(alignment: .leading, spacing: 5) {
                    Text("⚠️ Emergency mode")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("✓ Emergency services notified")
                        Text("✓ Emergency contacts notified")
                        Text("✓ Location sharing active")
                        Text("✓ Satellite connection stable")
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                }
                
                Divider().background(Color.red)
                
                // Location information
                VStack(alignment: .leading, spacing: 10) {
                    Text("📍 Your location has been shared.")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Help is being contacted\nStay where you are if safe to do so")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                
                // First question: "Are you physically injured?"
                if !showSecondQuestion {
                    VStack(alignment: .leading) {
                        Text("Are you physically injured?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Button(action: {
                                isPhysicallyInjured = "Yes"
                                showSecondQuestion = true
                            }) {
                                Text("Yes")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isPhysicallyInjured == "Yes" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                isPhysicallyInjured = "No"
                                showSecondQuestion = true
                            }) {
                                Text("No")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isPhysicallyInjured == "No" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                isPhysicallyInjured = "Not sure"
                                showSecondQuestion = true
                            }) {
                                Text("Not sure")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isPhysicallyInjured == "Not sure" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .transition(.slide)
                }
                
                // Second question: "Is your location safe?"
                if showSecondQuestion && !showThirdQuestion {
                    VStack(alignment: .leading) {
                        Text("Is your location safe?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Button(action: {
                                isLocationSafe = "Yes"
                                showThirdQuestion = true
                            }) {
                                Text("Yes")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isLocationSafe == "Yes" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                isLocationSafe = "No"
                                showThirdQuestion = true
                            }) {
                                Text("No")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isLocationSafe == "No" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                isLocationSafe = "Not sure"
                                showThirdQuestion = true
                            }) {
                                Text("Not sure")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isLocationSafe == "Not sure" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .transition(.slide)
                }
                
                // Third question: "What is your most urgent need?"
                if showThirdQuestion {
                    VStack(alignment: .leading) {
                        Text("What is your most urgent need?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 10) {
                            Button(action: {
                                urgentNeed = "Medical attention"
                            }) {
                                Text("Medical attention")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(urgentNeed == "Medical attention" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                urgentNeed = "Lost/Navigation"
                            }) {
                                Text("Lost/Navigation")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(urgentNeed == "Lost/Navigation" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                urgentNeed = "Wildlife encounter"
                            }) {
                                Text("Wildlife encounter")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(urgentNeed == "Wildlife encounter" ? Color.red.opacity(0.2) : Color.white)
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .transition(.slide)
                }
                
                Spacer()
                
                // Chat input field at the bottom
                HStack {
                    TextField("Ask for tips, directions, and more", text: .constant(""))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)
        }
        .animation(.easeInOut)
    }
}

