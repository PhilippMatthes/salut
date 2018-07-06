//
//  SalutServer.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

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

