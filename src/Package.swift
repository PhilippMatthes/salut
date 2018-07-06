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

class Package {
    let contents: EncryptionData
    let header: String
    
    init(contents: EncryptionData, header: String) {
        self.contents = contents
        self.header = header
    }
    
    func encodeBase64() -> String {
        let data = NSMutableData()
        NSKeyedArchiver.setClassName("EncryptionData", for: EncryptionData.self)
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(contents, forKey: "contents")
        archiver.encode(header, forKey: "header")
        archiver.finishEncoding()
        return (data as Data).base64EncodedString()
    }
    
    convenience init?(_ base64Encoded: String) {
        guard let data = Data.init(base64Encoded: base64Encoded) else {return nil}
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        defer {
            unarchiver.finishDecoding()
        }
        NSKeyedUnarchiver.setClass(EncryptionData.self, forClassName: "EncryptionData")
        guard
            let contents = unarchiver.decodeObject(forKey: "contents") as? EncryptionData,
            let header = unarchiver.decodeObject(forKey: "header") as? String
            else { return nil }
        self.init(contents: contents, header: header)
    }
    
    public var description: String { return "<Package Header: \(header), Contents: \(contents.description)>" }
}
