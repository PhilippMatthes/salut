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

protocol SalutClientDelegate {
    func client(_ client: SalutClient, sentSearchRequest package: Package)
    func client(_ client: SalutClient, receivedSearchResponse package: Package)
    func client(_ client: SalutClient, recievedDecryptableSearchResponse response: String)
    func client(_ client: SalutClient, sentData package: Package)
    func client(_ client: SalutClient, didChangeConnectedDevices connectedDevices: [String])
}

class SalutClient: Salut {
    
    var delegate: SalutClientDelegate?
    
    func sendSearchRequest() {
        guard let encryptedRequest = encryption.encrypt(Salut.searchRequestFingerPrint) else {return}
        let package = Package(contents: encryptedRequest, header: Header.searchRequest.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.client(self, sentSearchRequest: package)
    }
    
    func receivedSearchResponse(package: Package) {
        delegate?.client(self, receivedSearchResponse: package)
        guard
            let decrypted = encryption.decrypt(package.contents)
        else {return}
        if decrypted == Salut.searchResponseFingerPrint {
            delegate?.client(self, recievedDecryptableSearchResponse: decrypted)
        }
    }
    
    func sendData(_ data: String) {
        guard let encryptedData = encryption.encrypt(data) else {return}
        let package = Package(contents: encryptedData, header: Header.dataTransmission.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.client(self, sentData: package)
    }
    
    func prepare() {
        bonjour.delegate = self
    }
    
}

extension SalutClient: BonjourDelegate {
    func manager(_ manager: Bonjour, didChangeConnectedDevices connectedDevices: [String]) {
        delegate?.client(self, didChangeConnectedDevices: connectedDevices)
    }
    
    func manager(_ manager: Bonjour, transmittedPayload payload: String) {
        guard let package = Package(payload) else {return}
        switch package.header {
            case Header.searchResponse.rawValue:
                receivedSearchResponse(package: package)
            default:
                break
        }
    }
}
