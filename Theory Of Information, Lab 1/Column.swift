//
//  Column.swift
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 20/09/2017.
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

class Column: NSViewController {
    
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
    
    var fileURL  = URL(fileURLWithPath: "/Users/azarovalex/Desktop/Rail Fence/plaintext.txt")
    
    @IBOutlet weak var keywordField: NSTextField!
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var ciphertextField: NSTextField!
    @IBOutlet weak var columnsField: NSTextField!
    
    var ciphertext = ""
    var plaintext  = ""
    var keyword    = ""
    var columns    = ""
    
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
    
    @IBAction func encodeBtnPressed(_ sender: Any) {
        plaintext = plaintextField.stringValue
        if plaintext == "" {
            dialogError(question: "Your ciphertext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        keyword = keywordField.stringValue
        keyword = keyword.components(separatedBy: CharacterSet.letters.inverted)
            .joined()
        keyword = keyword.uppercased()
        keywordField.stringValue = keyword
        keyword = String(cString: SaveSpecialSymbols(keyword))
        keywordField.stringValue = keyword
        if keyword == "" {
            dialogError(question: "Please, specify the keyword!", text: "Error: No keyword.")
            return
        }
        
        plaintext = String(cString: SaveSpecialSymbols(plaintext))
        
        ciphertext = String(cString: ColumnEncipher(plaintext, keyword))
        
        columns = String(cString: GetColumns())
        columnsField.stringValue = columns
        
        //ciphertext = String(cString: ReturnSpecialSymbols(ciphertext))
        ciphertextField.stringValue = ciphertext
    }
    
    @IBAction func decodeBtnPressed(_ sender: Any) {
        ciphertext = ciphertextField.stringValue
        guard ciphertext != "" else {
            dialogError(question: "Your ciphertext is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        
        keyword = keywordField.stringValue
        guard keyword != "" else {
            dialogError(question: "Your keyword is an empty string!", text: "Error: Nothing to encipher.")
            return
        }
        ciphertext = ciphertext.components(separatedBy: CharacterSet.letters.inverted).joined()
        plaintext = String(cString: ColumnDecipher(ciphertext, keyword))
        plaintextField.stringValue = plaintext
        ColumnEncipher(plaintext, keyword)
        columns = String(cString: GetColumns())
        columnsField.stringValue = columns
    }
}
