//
//  SocketClient.swift
//  socket_client_demo
//
//  Created by Han on 2025/2/4.
//

import Foundation
import Network

class SocketClient: ObservableObject {
    var connection: NWConnection?
    @Published var logs: [String] = []

    func connect(to ip: String, port: UInt16) {
        connection = NWConnection(host: NWEndpoint.Host(ip), port: NWEndpoint.Port(rawValue: port)!, using: .tcp)
        connection?.stateUpdateHandler = { state in
            DispatchQueue.main.async {
                switch state {
                case .ready:
                    self.appendLog("✅ 連線至 Server (\(ip):\(port))")
                    self.receive()
                case .failed(let error):
                    self.appendLog("❌ 連線失敗: \(error)")
                default:
                    break
                }
            }
        }
        connection?.start(queue: .global())
    }

    func send(message: String) {
        let data = message.data(using: .utf8) ?? Data()
        connection?.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.appendLog("❌ 發送失敗: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    self.appendLog("📤 已發送: \(message)")
                }
            }
        })
    }

    func receive() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, _, error in
            if let data = data, !data.isEmpty {
                let response = String(decoding: data, as: UTF8.self)
                DispatchQueue.main.async {
                    self.appendLog("📩 Server 回應: \(response)")
                }
            }
            if error == nil {  // 確保沒有錯誤，繼續監聽
                self.receive()
            }
        }
    }

    private func appendLog(_ log: String) {
        logs.append(log)
    }
}

