# Demo project of using Starscream via Carthage
Open the Xcode project and you’ll be able to build it. Even though the `common-crypto-spm` and
`zlib-spm` Carthage checkouts have been removed.

No configurations in Xcode have been made other than drag the built Starscream framework from
`Carthage/Build/iOS/` into Xcode. So it’s linked and embedded.

The branch `with-zlib-cc-spm` contents is the result of a fresh `carthage update` run.

## Steps to reproduce this repo
1. Create a new Xcode project.
2. Create a `Cartfile` containing:
   ```
   github "daltoniam/Starscream"
   ```
3. Run `carthage update --platform iOS`
4. Drag the `Starscream.framework` bundle from `Carthage/Build/iOS/` into the “Embedded Binaries”
   box in the project config.
5. Import Starscream in `ViewController.swift`
6. Add some code to the `ViewController` class that uses Starscream. For example:
   ```swift
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
   ```
