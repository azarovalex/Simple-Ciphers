//
//  ViewController.swift
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 15/09/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

import Cocoa

var path: String = ""

func browseFile() -> String {
    
    let dialog = NSOpenPanel();
    
    dialog.title                   = "Choose a .txt file";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseDirectories    = true;
    dialog.canCreateDirectories    = true;
    dialog.allowsMultipleSelection = false;
    dialog.allowedFileTypes        = ["txt"];
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file
        
        if (result != nil) {
            path = result!.path
            return path
        }
    } else {
        // User clicked on "Cancel"
        return ""
    }
    
    return ""
}

class ViewController: NSViewController {
    
    var fileURL = URL(fileURLWithPath: "/")
    
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var railfenceField: NSTextField!
    @IBOutlet weak var ciphertextField: NSTextField!
    @IBOutlet weak var keysizeLabel: NSTextField!
    @IBOutlet weak var keyField: NSTextField!
    @IBOutlet weak var symbolsCheckbox: NSButton!
    
    
    var ciphertext = ""
    var plaintext = ""
    var railfence = ""
    
    var sizeofkey = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolsCheckbox.state = .off
    }
    
    // FINISHED
    @IBAction func loadText(_ sender: NSButton) {
        fileURL = URL(fileURLWithPath: browseFile())
        
        switch sender.tag {
        case 1:
            do {
                plaintextField.stringValue  = try String(contentsOf: fileURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(fileURL)", text: "Error: " + error.localizedDescription)
            }
        case 2:
            do {
                ciphertextField.stringValue = try String(contentsOf: fileURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(fileURL)", text: "Error: " + error.localizedDescription)
            }
        default:
            break
        }
        
        
    }
    @IBAction func storeText(_ sender: NSButton) {
        fileURL = URL(fileURLWithPath: browseFile())
        
        switch sender.tag {
        case 1:
            do {
                try plaintextField.stringValue.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                dialogError(question: "Failed writing to URL \(fileURL)", text: "Error: " + error.localizedDescription)
            }
        case 2:
            do {
                try ciphertextField.stringValue.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                dialogError(question: "Failed writing to URL \(fileURL)", text: "Error: " + error.localizedDescription)
            }
        default:
            break
        }
    }
    
    // FINISHED
    @IBAction func encodeBtnPressed(_ sender: Any) {
        plaintext = plaintextField.stringValue
        guard plaintext != "" else {
            dialogError(question: "Your plaintext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        // Get sizeofkey
        var keyStr = keyField.stringValue
        keyStr = keyStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        keyField.stringValue = keyStr
        if (keyStr == "") {
            dialogError(question: "Key field is empty!", text: "Error: Can not encipher without a key.")
            return
        }
        sizeofkey = Int(keyStr)!
        if (sizeofkey == 0) {
            dialogError(question: "Not a valid key!", text: "Error: Can not encipher with zero hight.")
            return
        }
        
        
        // Save special characters
//        if symbolsCheckbox.state == .on {
            plaintext = String(cString: SaveSpecialSymbols(plaintext))
//        } else {
//            plaintext = plaintext.components(separatedBy: CharacterSet.letters.inverted).joined()
//            plaintextField.stringValue = plaintext
//        }
        
        // Draw the rail fence
        railfence = String(cString: MakeRailFence(plaintext, Int32(plaintext.count), Int32(sizeofkey)))
        railfenceField.stringValue = railfence
        
        // Load special characters and display ciphertext
        ciphertext = String(cString: Encipher(railfence, Int32(plaintext.count)))
        if symbolsCheckbox.state == .on {
            // ciphertext = String(cString: ReturnSpecialSymbols(ciphertext))
        }
        ciphertextField.stringValue = ciphertext
    }
    
    @IBAction func decodeBtnPressed(_ sender: Any) {
        ciphertext = ciphertextField.stringValue
        guard ciphertext != "" else {
            dialogError(question: "Your ciphertext is an empy string!", text: "Error: Nothing to encipher.")
            return
        }
        
        // Get sizeofkey
        var keyStr = keyField.stringValue
        keyStr = keyStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        keyField.stringValue = keyStr
        if (keyStr == "") {
            dialogError(question: "Key field is empty!", text: "Error: Can not decipher without a key.")
            return
        }
        sizeofkey = Int(keyStr)!
        if (sizeofkey == 0) {
            dialogError(question: "Not a valid key!", text: "Error: Can not decipher with zero hight.")
            return
        }
        
        if symbolsCheckbox.state == .on {
            ciphertext = String(cString: SaveSpecialSymbols(ciphertext))
        } else {
            ciphertext = ciphertext.components(separatedBy: CharacterSet.letters.inverted).joined()
            ciphertextField.stringValue = ciphertext
        }
        
        plaintext = String(cString: Decipher(ciphertext, Int32(sizeofkey)));
        if symbolsCheckbox.state == .on {
            plaintext = String(cString: ReturnSpecialSymbols(plaintext))
        }
        plaintextField.stringValue = plaintext
        railfence = String(cString: MakeRailFence(plaintext, Int32(plaintext.count), Int32(sizeofkey)))
        railfenceField.stringValue = railfence
    }
}


