//
//  ClientView.swift
//  socket_client_demo
//
//  Created by Han on 2025/2/4.
//

import SwiftUI

struct ClientView: View {
    @StateObject private var client = SocketClient()
    @State private var ip: String = "127.0.0.1"
    @State private var port: String = "1001"
    @State private var message: String = ""

    var body: some View {
        VStack {
            Text("Socket Client")
                .font(.largeTitle)
                .padding()

            HStack {
                TextField("輸入 IP", text: $ip)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                TextField("輸入 Port", text: $port)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)

                Button("連接") {
                    if let portNumber = UInt16(port) {
                        client.connect(to: ip, port: portNumber)
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            HStack {
                TextField("輸入訊息...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("發送") {
                    client.send(message: message)
                    message = ""
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(client.logs, id: \.self) { log in
                        Text(log)
                            .padding(.vertical, 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ClientView()
}
