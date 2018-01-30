//
//  ViewController.swift
//  StarscreamViaCarthage
//
//  Created by Aron Cedercrantz on 1/30/18.
//  Copyright © 2018 Aron Cedercrantz. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    var socket: WebSocket?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        socket = WebSocket(url: URL(string: "wss://echo.websocket.org")!)
        socket?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        socket?.connect()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect: \(socket)")
        socket.write(string: "Hello!") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.socket?.disconnect()
            }
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect: \(socket) with error: \(String(describing: error))")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage: \(socket) text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData: \(socket) data: \(data.base64EncodedString())")
    }
}

