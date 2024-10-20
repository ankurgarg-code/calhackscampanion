//import Foundation
////import Tokenizers
//
//class Tokenizer {
//    private let tokenizer: TokenizersTokenizer
//
//    init() {
//        // Load the tokenizer model files
//        guard let tokenizerPath = Bundle.main.path(forResource: "tokenizer", ofType: "json") else {
//            fatalError("Tokenizer file not found")
//        }
//        do {
//            tokenizer = try TokenizersTokenizer.fromFile(tokenizerPath)
//        } catch {
//            fatalError("Failed to load tokenizer: \(error.localizedDescription)")
//        }
//    }
//
//    func encode(text: String) -> [Int]? {
//        do {
//            let encoding = try tokenizer.encode(text: text)
//            return encoding.ids
//        } catch {
//            print("Tokenization error: \(error.localizedDescription)")
//            return nil
//        }
//    }
//
//    func decode(tokens: [Int]) -> String {
//        do {
//            let decoded = try tokenizer.decode(ids: tokens)
//            return decoded
//        } catch {
//            print("Decoding error: \(error.localizedDescription)")
//            return ""
//        }
//    }
//}
