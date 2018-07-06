//
//  SalutClient.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

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
