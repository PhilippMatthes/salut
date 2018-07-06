//
//  EncryptionData.swift
//  macconnect
//
//  Created by Philipp Matthes on 03.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

class EncryptionData: NSObject, NSCoding {
    
    let raw: [UInt8]
    
    init(_ raw: [UInt8]) {
        self.raw = raw
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(raw, forKey: "raw")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let raw = aDecoder.decodeObject(forKey: "raw") as? [UInt8] else {return nil}
        self.init(raw)
    }
    
    func decode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(raw, forKey: "raw")
        archiver.finishEncoding()
        return (data as Data)
    }
    
    func decodeToBase64() -> String {
        return decode().base64EncodedString()
    }
    
    func decodeToUTF8() -> String? {
        return String(data: decode(), encoding: String.Encoding.utf8)
    }
    
    override public var description: String { return "<EncryptionData raw=\(raw), base64=\(decodeToBase64())>" }
}
