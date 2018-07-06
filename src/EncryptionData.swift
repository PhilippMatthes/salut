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
