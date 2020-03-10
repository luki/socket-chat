//
//  ViewController.swift
//  client
//
//  Created by Lukas Süsskind on 3/10/20.
//  Copyright © 2020 Lukas Müller. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    typealias Message = (sender: String, content: String)
    let name: String = "hionoxy"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
    let manager = SocketManager(
        socketURL: URL(string: "http://127.0.0.1:3000")!,
        config: [.log(true), .compress])
    
    var socketClient: SocketIOClient!
    var messages = [Message]() {
        didSet {
            print("Updated messages on device")
        }
    }
    
    override func viewDidLoad() {
        self.textField.delegate = self
        
        textLabel.text = String()
        
        super.viewDidLoad()
        socketClient = manager.defaultSocket
        
        socketClient.on("connected", callback: { data, emitter in
            print("Connected!!")
        })
        
        socketClient.on("message", callback: { data, emitter in
            print("Message received")
        })
        
        socketClient.connect()
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        socketClient.emit("message", ["message": textField.text!, "sender": name])
        return true
    }
}

