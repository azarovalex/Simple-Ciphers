//
//  ViewController.swift
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 15/09/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

import Cocoa

func dialogError(question: String, text: String) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

class ViewController: NSViewController {
    
    let plaintextURL = URL(fileURLWithPath: "/Users/azarovalex/Desktop/Rail Fence/plaintext.txt")
    let ciphertextURL = URL(fileURLWithPath: "/Users/azarovalex/Desktop/Rail Fence/ciphertext.txt")
    
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var railfenceField: NSTextField!
    @IBOutlet weak var ciphertextField: NSTextField!
    @IBOutlet weak var keysizeLabel: NSTextField!
    
    
    var ciphertext = ""
    var plaintext = ""
    var railfence = ""
    
    var sizeofkey = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func sliderChanged(_ sender: NSSlider) {
        sizeofkey = sender.integerValue
        keysizeLabel.stringValue = "Key: \(sizeofkey)"
    }
    @IBAction func loadText(_ sender: NSButton) {
        switch sender.tag {
        case 1:
            do {
                plaintextField.stringValue  = try String(contentsOf: plaintextURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(plaintextURL)", text: "Error: " + error.localizedDescription)
            }
        case 2:
            do {
                ciphertextField.stringValue = try String(contentsOf: ciphertextURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(ciphertextURL)", text: "Error: " + error.localizedDescription)
            }
        default:
            break
        }
        
        
    }
    @IBAction func storeText(_ sender: NSButton) {
        switch sender.tag {
        case 1:
            do {
                try plaintextField.stringValue.write(to: plaintextURL, atomically: true, encoding: .utf8)
            } catch {
                dialogError(question: "Failed writing to URL \(plaintextURL)", text: "Error: " + error.localizedDescription)
            }
        case 2:
            do {
                try ciphertextField.stringValue.write(to: ciphertextURL, atomically: true, encoding: .utf8)
            } catch {
                dialogError(question: "Failed writing to URL \(ciphertextURL)", text: "Error: " + error.localizedDescription)
            }
        default:
            break
        }
    }
    
    @IBAction func encodeBtnPressed(_ sender: Any) {
        // Remain only letters in the plaintext
        plaintext = plaintextField.stringValue
        
        // Are there at least one symbol in the plaintext?
        guard plaintext != "" else {
            dialogError(question: "Your plaintext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        // TODO: Save whitespaces positions
        
        plaintext = String(cString: SaveSpecialSymbols(plaintext))
        
        // Draw the rail fence
        railfence = String(cString: MakeRailFence(plaintext, Int32(plaintext.count), Int32(sizeofkey)))
        railfenceField.stringValue = railfence
        
        ciphertext = String(cString: Encipher(railfence, Int32(plaintext.count)))
        ciphertext = String(cString: ReturnSpecialSymbols(ciphertext))
        ciphertextField.stringValue = ciphertext
    }
    
    @IBAction func decodeBtnPressed(_ sender: Any) {
        ciphertext = ciphertextField.stringValue
        guard ciphertext != "" else {
            dialogError(question: "Your ciphertext is an empy string!", text: "Error: Nothing to encipher.")
            return
        }
        
        let ptr = SaveSpecialSymbols(ciphertext)
        ciphertext = String(cString: ptr!)
        free(UnsafeMutableRawPointer.init(mutating: ptr))
        
        plaintext = String(cString: Decipher(ciphertext, Int32(sizeofkey)));
        plaintext = String(cString: ReturnSpecialSymbols(plaintext))
        plaintextField.stringValue = plaintext
        
    }
}

