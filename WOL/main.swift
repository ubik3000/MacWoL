//
//  main.swift
//  WOL
//
//  Created by Cristian Iorga on 31/05/2020.
//  Copyright © 2020 Zenio. All rights reserved.
//

//TODO: Change port number for UDP packet (default and as argument)


import Foundation
import Network


//Newer(??) alternative to CommandLine: https://swift.org/blog/argument-parser/
//The Swift standard library contains a struct CommandLine which has a collection of Strings called arguments. So you could switch on arguments like this:
//
for argument in CommandLine.arguments {
    switch argument {
    case "arg1":
        print("first argument")

    case "arg2":
        print("second argument")

    default:
        print("an argument")
    }
}

//TODO: Add class for embedding connection
var connection: NWConnection?

func send() {
    connection?.send(content: "Test message".data(using: String.Encoding.utf8), completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
        print(NWError!)
    })))
}

func receive() {
    connection?.receiveMessage { (data, context, isComplete, error) in
        print("Got it")
        print(data!)
    }
}

func someFunc() {

    connection = NWConnection(host: "255.255.255.255", port: 9093, using: .udp)

    connection?.stateUpdateHandler = { (newState) in
        switch (newState) {
        case .ready:
            print("ready")
            send()
            receive()
        case .setup:
            print("setup")
        case .cancelled:
            print("cancelled")
        case .preparing:
            print("Preparing")
        default:
            print("waiting or failed")

        }
    }
    connection?.start(queue: .global())

}

//class ViewController: UIViewController {
//
//    var connection: NWConnection?
//    var hostUDP: NWEndpoint.Host = "iperf.volia.net"
//    var portUDP: NWEndpoint.Port = 5201
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Hack to wait until everything is set up
//        var x = 0
//        while(x<1000000000) {
//            x+=1
//        }
//        connectToUDP(hostUDP,portUDP)
//    }
//
//    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
//        // Transmited message:
//        let messageToUDP = "Test message"
//
//        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
//
//        self.connection?.stateUpdateHandler = { (newState) in
//            print("This is stateUpdateHandler:")
//            switch (newState) {
//                case .ready:
//                    print("State: Ready\n")
//                    self.sendUDP(messageToUDP)
//                    self.receiveUDP()
//                case .setup:
//                    print("State: Setup\n")
//                case .cancelled:
//                    print("State: Cancelled\n")
//                case .preparing:
//                    print("State: Preparing\n")
//                default:
//                    print("ERROR! State not defined!\n")
//            }
//        }
//
//        self.connection?.start(queue: .global())
//    }
//
//    func sendUDP(_ content: Data) {
//        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
//            if (NWError == nil) {
//                print("Data was sent to UDP")
//            } else {
//                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
//            }
//        })))
//    }
//
//    func sendUDP(_ content: String) {
//        let contentToSendUDP = content.data(using: String.Encoding.utf8)
//        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
//            if (NWError == nil) {
//                print("Data was sent to UDP")
//            } else {
//                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
//            }
//        })))
//    }
//
//    func receiveUDP() {
//        self.connection?.receiveMessage { (data, context, isComplete, error) in
//            if (isComplete) {
//                print("Receive is complete")
//                if (data != nil) {
//                    let backToString = String(decoding: data!, as: UTF8.self)
//                    print("Received message: \(backToString)")
//                } else {
//                    print("Data == nil")
//                }
//            }
//        }
//    }
//}
