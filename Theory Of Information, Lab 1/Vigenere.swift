//
//  Vigenere.swift
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 01/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

import Cocoa

class Vigenere : NSViewController {
    var path: String = ""
    
    func browseFile(sender: AnyObject) -> String {
        
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
    
    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    var fileURL  = URL(fileURLWithPath: "/Users/azarovalex/Desktop/Rail Fence/plaintext.txt")
    
    var ciphertext = ""
    var plaintext  = ""
    var keyword    = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadText(_ sender: NSButton) {
        fileURL = URL(fileURLWithPath: browseFile(sender: self))
        
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
        
        fileURL = URL(fileURLWithPath: browseFile(sender: self))
        
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
    
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var ciphertextField: NSTextField!
    @IBOutlet weak var keywordField: NSTextField!
    @IBOutlet weak var vigenereField: NSTextField!
    
    
    @IBAction func encodeBtnPressed(_ sender: Any) {
        plaintext = plaintextField.stringValue
        if plaintext == "" {
            dialogError(question: "Your plaintext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        keyword = keywordField.stringValue
        keywordField.stringValue = keyword
        if keyword == "" {
            dialogError(question: "Please, specify the keyword!", text: "Error: No keyword.")
            return
        }
        
        let vigenere = VigenereAlgorithm(alphabet: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ", key: keyword)
        ciphertext = vigenere.encrypt(plainText: plaintext)
        
        ciphertextField.stringValue = ciphertext
    }
    
    @IBAction func decodeBtnPressed(_ sender: Any) {
        ciphertext = ciphertextField.stringValue
        if ciphertext == "" {
            dialogError(question: "Your ciphertext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        keyword = keywordField.stringValue
        keywordField.stringValue = keyword
        if keyword == "" {
            dialogError(question: "Please, specify the keyword!", text: "Error: No keyword.")
            return
        }
        
        let vigenere = VigenereAlgorithm(alphabet: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ", key: keyword)
        plaintext = vigenere.decrypt(encryptedText: ciphertext)
        
        plaintextField.stringValue = plaintext
    }
}









