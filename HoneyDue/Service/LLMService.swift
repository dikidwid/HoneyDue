import Foundation
import Combine
import UIKit

enum FakeAPIKey: String {
    case GPT4o = "app-nZejRKIvCLCPLae2pxNTUESN"
    case expenseScanner = "app-czUwKirJvIP44SsjT0wxRTfk"
}

class LLMService: ObservableObject {
    var llmIdentifier: String
    var useStreaming: Bool
    var isConversation: Bool
    
    init(identifier: String, useStreaming: Bool, isConversation: Bool) {
        self.llmIdentifier = identifier
        self.useStreaming = useStreaming
        self.isConversation = isConversation
    }
    
    @Published var response: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var conversationId = ""
    
    func sendMessage(query: String, uiImage: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        response = ""
        
        if let image = uiImage {
            uploadImage(image: image) { result in
                switch result {
                case .success(let fileId):
                    self.sendChatMessage(query: query, fileId: fileId, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            sendChatMessage(query: query, fileId: nil, completion: completion)
        }
    }
    
    private func sendChatMessage(query: String, fileId: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.dify.ai/v1/chat-messages") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(llmIdentifier)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var files: [[String: Any]] = []
        if let fileId = fileId {
            files.append([
                "type": "image",
                "transfer_method": "local_file",
                "upload_file_id": fileId
            ])
        }
        
        let body: [String: Any] = [
            "inputs": [:],
            "query": query,
            "response_mode": "blocking",
            "conversation_id": conversationId,
            "user": "abc-123",
            "files": files
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let blockingResponse = try JSONDecoder().decode(LLMBlockingResponse.self, from: data)
                self.handleBlockingResponse(blockingResponse)
                completion(.success(self.response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.dify.ai/v1/files/upload") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(llmIdentifier)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let maxSize = 1 * 1024 * 1024 // 1 MB
        let resizedImage = resizeImage(image: image, maxSize: maxSize) ?? image
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8) else { return }
        
        var body = Data()
        
        // Append file data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append user data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"user\"\r\n\r\n".data(using: .utf8)!)
        body.append("abc-123\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let fileId = json["id"] as? String {
                    completion(.success(fileId))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func resizeImage(image: UIImage, maxSize: Int) -> UIImage? {
        var resizedImage = image
        let compression: CGFloat = 0.8
        guard var imageData = resizedImage.jpegData(compressionQuality: compression) else { return nil }
        
        while imageData.count > maxSize {
            let newSize = CGSize(width: resizedImage.size.width * 0.95, height: resizedImage.size.height * 0.95)
            UIGraphicsBeginImageContext(newSize)
            resizedImage.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
            UIGraphicsEndImageContext()
            
            if let newImageData = resizedImage.jpegData(compressionQuality: compression) {
                imageData = newImageData
            }
        }
        
        return resizedImage
    }
    
    private func handleBlockingResponse(_ blockingResponse: LLMBlockingResponse) {
        if blockingResponse.event == "message" {
            response += blockingResponse.answer ?? ""
        }
        if conversationId.isEmpty && isConversation {
            conversationId = blockingResponse.conversation_id ?? ""
        }
    }
    
    func resetConversation() {
        conversationId = ""
    }
}

// Define the blocking response model
struct LLMBlockingResponse: Decodable {
    let event: String
    let message_id: String?
    let conversation_id: String?
    let answer: String?
    let created_at: Int?
}
