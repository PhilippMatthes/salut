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

protocol SalutServerDelegate {
    func server(_ server: SalutServer, receivedSearchRequest package: Package)
    func server(_ server: SalutServer, sentSearchResponse package: Package)
    func server(_ server: SalutServer, receivedDataTransmission package: Package)
    func server(_ server: SalutServer, receivedDecryptedTransmission data: String)
}

class SalutServer: Salut {
    
    var delegate: SalutServerDelegate?
    
    func prepare() {
        bonjour.delegate = self
    }
    
    func receivedSearchRequest(package: Package) {
        delegate?.server(self, receivedSearchRequest: package)
        guard
            let decrypted = encryption.decrypt(package.contents)
        else {return}
        if decrypted == Salut.searchRequestFingerPrint {
            sendSearchResponse()
        }
    }
    
    func sendSearchResponse() {
        guard let encryptedResponse = encryption.encrypt(Salut.searchResponseFingerPrint) else {return}
        let package = Package(contents: encryptedResponse, header: Header.searchResponse.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.server(self, sentSearchResponse: package)
    }
    
    func receivedDataTransmission(package: Package) {
        delegate?.server(self, receivedDataTransmission: package)
        guard
            let decrypted = encryption.decrypt(package.contents)
        else {return}
        delegate?.server(self, receivedDecryptedTransmission: decrypted)
    }
    
}

extension SalutServer: BonjourDelegate {
    func manager(_ manager: Bonjour, didChangeConnectedDevices connectedDevices: [String]) {
        // Nothing
    }
    
    func manager(_ manager: Bonjour, transmittedPayload payload: String) {
        guard let package = Package(payload) else {return}
        switch package.header {
            case Header.searchRequest.rawValue:
                receivedSearchRequest(package: package)
            case Header.dataTransmission.rawValue:
                receivedDataTransmission(package: package)
            default:
                break
        }
    }
}

