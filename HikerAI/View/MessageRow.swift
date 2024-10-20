//import SwiftUI
//
//struct MessageRow: View {
//    let message: Message
//    
//    var body: some View {
//        HStack {
//            if message.isUserMessage {
//                Spacer()
//                Text(message.text)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 300, alignment: .trailing)
//            } else {
//                Text(message.text)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 300, alignment: .leading)
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//    }
//}
