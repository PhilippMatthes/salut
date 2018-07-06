//
//  RSA.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import CryptoSwift

class Encryption {
    var key: Array<UInt8>
    let iv: Array<UInt8>
    
    init(key: String) {
        self.key = Array(key.utf8)
        self.iv = Array("00000000".utf8)
    }
    
    func setKey(_ key: String) {
        self.key = Array(key.utf8)
    }
    
    func encrypt(_ input: String) -> EncryptionData? {
        print(key)
        let encrypted: Array<UInt8>
        do {
            encrypted = try ChaCha20(key: key, iv: iv).encrypt(Array(input.utf8))
        } catch {
            print("Encryption Error: \(error)")
            return nil
        }
        return EncryptionData(encrypted)
    }
    
    
    func decrypt(_ input: EncryptionData) -> String? {
        print(key)
        let decrypted: Array<UInt8>
        do {
            decrypted = try ChaCha20(key: key, iv: iv).decrypt(input.raw)
        } catch {
            print("Decryption Error: \(error)")
            return nil
        }
        let characters = decrypted.map { Character(UnicodeScalar($0)) }
        let result = String(Array(characters))
        return result
    }
    
}
