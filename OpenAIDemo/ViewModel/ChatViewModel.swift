//
//  ChatViewModel.swift
//  OpenAIDemo
//
//  Created by Pradeep Kumar Sagar on 15/12/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {

    @Published var userInput = ""
    @Published var messages: [String] = []
    @Published var isLoading = false
   let db = Firestore.firestore()
    
    private var service: OpenAIService = OpenAIService(apiKey: "")

    init() {

//        let key = Bundle.main.object(
//            forInfoDictionaryKey: "OPENAI_API_KEY"
//        ) as? String ?? ""
        
        self.fetchOpenAIKey { keyValue in
            print("keyValue = \(keyValue)")
            
            self.service = OpenAIService(apiKey: keyValue)
        }
    }
    func fetchOpenAIKey(complition:@escaping (String) -> Void){
        
        db.collection("token").document("openAI").getDocument { documentSnapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let documentSnapshot = documentSnapshot {
                print("Current data: \(documentSnapshot.data() ?? [:])")
                
                if let data = documentSnapshot.data() {
                   let key = data["authKey"] as? String ?? ""
                    print(key)
                    complition(key)
                }
            }
        }
    }
    func send() async {
        guard !userInput.isEmpty else { return }

        let prompt = userInput
        messages.append("You: \(prompt)")
        userInput = ""
        isLoading = true

        do {
            let response = try await service.sendMessage(prompt)
            print(">>> %@\n", response)
            messages.append("AI: \(response)")
        } catch {
            messages.append("Error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
