//
//  Salut.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

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
