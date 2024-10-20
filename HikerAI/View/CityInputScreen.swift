import SwiftUI
import MapKit

struct CityInputScreen: View {
    @StateObject var viewModel = HikeViewModel() // ViewModel handles business logic
    @StateObject private var locationManager = LocationManager() // Observing location updates
    @State private var city: String = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0

    @State private var showSuggestions = false
    @State private var isCitySelected = false // Flag to prevent further search after selection
    @FocusState private var isTextFieldFocused: Bool  // Managing TextField focus
    private let geocoder = CLGeocoder()  // Geocoder to convert city names to coordinates

    var body: some View {
        VStack {
            Spacer()

            Text("What city are you hiking in?")
                .font(.title)
                .bold()
                .foregroundColor(Color(hex: "2B5740"))
                .padding(.bottom, 20)

            // Styled TextField
            TextField("Enter city", text: $city)
                .padding(.vertical, 12) // Padding inside the TextField
                .padding(.horizontal, 15)
                .cornerRadius(8) // Rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1) // Border like in the image
                )
                .padding(.horizontal, 20) // Adjust padding outside the TextField
                .focused($isTextFieldFocused)  // Bind focus state to TextField
                .onChange(of: city) { newValue in
                    // Only trigger search suggestions if the user is typing and has not selected a city yet
                    if !newValue.isEmpty && !isCitySelected {
                        showSuggestions = true
                        viewModel.updateSearchQuery(newValue) // Update the search query in ViewModel in real-time
                    } else {
                        showSuggestions = false
                    }
                }

            if showSuggestions {
                List(viewModel.locationSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        // Stop further suggestions from being displayed
                        isCitySelected = true
                        city = suggestion.title // Set the selected city
                        showSuggestions = false // Hide suggestions after selection

                        // Delay removing focus to ensure smooth UI update
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTextFieldFocused = false // Remove focus from TextField
                        }

                        // Geocode the selected city
                        geocodeCity(city)
                    }) {
                        Text(suggestion.title)
                            .foregroundColor(.black)
                    }
                }
                .frame(height: 200)
                .listStyle(PlainListStyle()) // Style the List to look more compact
            }

            Button("Use my location") {
                isCitySelected = true
                showSuggestions = false
                locationManager.startUpdatingLocation()
                
            }
            .foregroundColor(.gray)
            .padding(.top, 20)
            

            Spacer()

            HStack {
                Spacer()

                // "Next" button similar to the screenshot
                NavigationLink(destination: ParkSelection(viewModel: viewModel, latitude: latitude, longitude: longitude)) {
                    HStack {
                        Text("next")
                            .foregroundColor(city.isEmpty ? .gray : Color(hex: "2B5740")) // Gray when disabled
                            .font(.system(size: 18))

                        Image(systemName: "arrow.right")
                            .foregroundColor(city.isEmpty ? .gray : Color(hex: "2B5740")) // Gray when disabled
                    }
                }
                .disabled(city.isEmpty) // Disable when the city field is empty
                .padding()
            }
            .padding([.trailing, .bottom], 20) // Align to bottom-right
        }
        .onChange(of: locationManager.userLocation) { newLocation in
            if let location = newLocation {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                viewModel.reverseGeocode(location: location) { locationName in
                    city = locationName // Update the city once reverse geocoded
                }
            }
        }
    }

    // Function to geocode the manually entered city or suggestion
    private func geocodeCity(_ city: String) {
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let location = placemark.location {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                print("Geocoded Location: \(self.latitude), \(self.longitude)")
            }
        }
    }
}

struct CityInput_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CityInputScreen()
        }
    }
}
