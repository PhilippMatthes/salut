//    MIT License
//
//    Copyright (c) 2018 Philipp Matthes
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.



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
