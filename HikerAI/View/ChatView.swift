import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    // Add these variables to hold the park name and packed items
    var parkName: String
    var packedItems: String
    
    var body: some View {
        ZStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if message.isUserMessage {
                                        Spacer()  // Align user messages to the right
                                    }
                                    MessageRow(message: message)
                                        .padding(.horizontal, 10)
                                    if !message.isUserMessage {
                                        Spacer()  // Align system/response messages to the left
                                    }
                                }
                                .padding(.top, 5)
                            }
                            if viewModel.isLoading {
                                LoadingIndicator()
                            }
                        }
                        .onChange(of: viewModel.messages) { _ in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))

                // Input field and send button at the bottom
                HStack {
                    TextField("Ask for tips, directions, and more", text: $viewModel.inputText)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .disabled(viewModel.isLoading)

                    Button(action: {
                        // Pass the park name and packed items to the sendMessage function
                        viewModel.sendMessage(parkName: parkName, packedItems: packedItems)
                    }) {
                        Text("Send")
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                    .padding(.leading, 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }

            // Floating SOS Button
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        // Handle SOS action here
//                    }) {
//                        Text("SOS!")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(width: 80, height: 50)
//                            .background(Color.red)
//                            .cornerRadius(25)
//                    }
//                    .padding()
//                    .padding(.bottom, 50)
//                }
//            }
        }
        .navigationBarTitle("Chat", displayMode: .inline)
    }
}

struct MessageRow: View {
    var message: Message

    var body: some View {
        Text(message.text)
            .padding()
            .background(message.isUserMessage ? Color(hex: "2B5740") : Color(.systemGray5))
            .foregroundColor(message.isUserMessage ? .white : .black)
            .cornerRadius(10)
            .frame(maxWidth: 250, alignment: message.isUserMessage ? .trailing : .leading)
    }
}

// Helper View for Loading Indicator
struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .padding(.top)
    }
}


// Message model for representing chat messages
struct Message: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var isUserMessage: Bool
}


// Sample ViewModel to handle chat functionality
//class ChatViewModel: ObservableObject {
//    @Published var messages: [Message] = [Message(text: "What can I help you with?", isUserMessage: false)]
//    @Published var inputText: String = ""
//    @Published var isLoading: Bool = false
//
//    func sendMessage() {
//        if !inputText.isEmpty {
//            let userMessage = Message(text: inputText, isUserMessage: true)
//            messages.append(userMessage)
//            inputText = ""
//
//            // Simulate bot response
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.messages.append(Message(text: "Here's a tip about bears...", isUserMessage: false))
//                self.isLoading = false
//            }
//        }
//    }
//}

// Utility function for hex colors
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8 * 17), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}
