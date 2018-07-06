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
import MultipeerConnectivity


class Salut {
    
    static let searchRequestFingerPrint = "What are you trying to tell me? That I can dodge bullets?"
    static let searchResponseFingerPrint = "No, Neo. I'm trying to tell you that when you're ready, you won't have to."
    
    enum Header: String {
        case searchRequest = "SearchRequest"
        case searchResponse = "SearchResponse"
        case dataTransmission = "DataTransmission"
    }
    
    let encryption: Encryption
    let bonjour: Bonjour
    var password: String
    
    init(peerId: MCPeerID, password: String) {
        encryption = Encryption(key: password)
        bonjour = Bonjour(peerId: peerId)
        self.password = password
    }
    
    func setPassword(_ password: String) {
        self.password = password
        encryption.setKey(password)
    }
    
    func postpare() {
        bonjour.postpare()
    }
    
}
