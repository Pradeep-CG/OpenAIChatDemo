//
//  ContentView.swift
//  OpenAIDemo
//
//  Created by Pradeep Kumar Sagar on 15/12/25.
//

import SwiftUI



struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
            VStack {
                ScrollView {
                    ForEach(viewModel.messages, id: \.self) {
                        Text($0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                }

                HStack {
                    TextField("Ask something...", text: $viewModel.userInput)
                        .textFieldStyle(.roundedBorder)

                    Button("Send") {
                        Task {
                            await viewModel.send()
                        }
                    }
                }
                .padding()
            }
        }
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
}

struct Message: Codable {
    let role: String
    let content: String
}
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}
#Preview {
    ContentView()
}
