# Salut
The Salut protocol is a Swift 4 protocol for encrypted data transfer via Bonjour. It uses symmetric encryption and md5 hashing to transfer data.

# Installation

Salut requires `CryptoSwift`. View their [installation instructions](https://github.com/krzyzanowskim/CryptoSwift) first.

To install Salut, simply drop the source files from `src` into your XCode app.

# Usage

## Getting a peer ID

Getting a MCPeerID is easy. On iOS simply use:
```swift
let id = MCPeerID(displayName: UIDevice.current.name)
```
On macOS you have to use:
```swift
let id = MCPeerID(displayName: Host.current().name ?? "Mac")
```

## Getting a password

Your password needs to be 32 alphanumeric symbols long. To generate a 32 symbols long md5 hash just use:
```swift
let code = "myPasswordOfVariableLength".md5()
```
Note that the md5 extension is part of CryptoSwift.

## Setting up a Salut Server

Before you start, you have to run the server on the device you want to connect to.

```swift
let server = SalutServer(peerId: id), password: code)
server.prepare()
server.delegate = self
```

## Running the Salut Client

Similarly to the server, just initialize a client on your device, from which you want to send information, with:
```swift
let client = SalutClient(peerId: id, password: code)
client.prepare()
client.delegate = self
```

## Setting the password on running clients or servers

To reset your password on the fly, simply call:
```swift
// Server
server.setPassword(newCode)
// Client
client.setPassword(newCode)
```

## Establishing a connection

Have your server and your client running. On your client, call:
```swift
salut.sendSearchRequest()
```
If the password is correct and the server gets the message, he will respond to the client. The client then calls the delegate method:
```swift
func client(_ client: SalutClient, recievedDecryptableSearchResponse response: String) {
    // Handle successful connection, e.g. save password and start sending messages
}
```

## Sending data

When you established a connection or your password always is the same and therefore you do not have to check for password correctness first, call:

```swift
salut.sendData(dataString)
```

On your server, the data will be received and decrypted. Use the server delegate method 

```swift
func server(_ server: SalutServer, receivedDecryptedTransmission data: String) {
    // Handle data
}
```

# Contribution

Feel free to contribute to my project, just open a Pull Request! 

# License

```
MIT License

Copyright (c) 2018 Philipp Matthes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```


