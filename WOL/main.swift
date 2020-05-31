//
//  main.swift
//  WOL
//
//  Created by Cristian Iorga on 31/05/2020.
//  Copyright © 2020 Zenio. All rights reserved.
//

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
