import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [Message(text: "What can I help you with?", isUserMessage: false)]
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // Send user message and call the backend with context
    func sendMessage(parkName: String, packedItems: String) {
        if !inputText.isEmpty {
            let userMessage = Message(text: inputText, isUserMessage: true)
            messages.append(userMessage)
            let question = inputText
            inputText = ""
            
            // Call backend to get a response
            queryBackend(for: question, parkName: parkName, packedItems: packedItems)
        }
    }
    
    // Backend query function
    private func queryBackend(for question: String, parkName: String, packedItems: String) {
        isLoading = true
        
        guard let url = URL(string: "https://579a-199-115-241-218.ngrok-free.app/api/ask") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON body with the question and user context
        let jsonBody: [String: Any] = [
            "question": question,
            "user_context": "Hiking at \(parkName). Packed items: \(packedItems)"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Failed to serialize JSON")
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: BackendResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                // Append the response from the backend to the messages list
                let botMessage = Message(id: UUID(), text: response.answer, isUserMessage: false)
                self.messages.append(botMessage)
            })
            .store(in: &cancellables)
    }
}


// Struct to match the backend response
struct BackendResponse: Decodable {
    let answer: String
}

// Message model
//struct Message: Identifiable, Equatable {
//    let id: UUID
//    let text: String
//    let isUserMessage: Bool
//}
