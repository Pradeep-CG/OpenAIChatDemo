//
//  ChatViewModel.swift
//  OpenAIDemo
//
//  Created by Pradeep Kumar Sagar on 15/12/25.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject {

    @Published var userInput = ""
    @Published var messages: [String] = []
    @Published var isLoading = false

    private let service: OpenAIService

    init() {
        let key = Bundle.main.object(
            forInfoDictionaryKey: "OPENAI_API_KEY"
        ) as? String ?? ""
        self.service = OpenAIService(apiKey: key)
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
