//
//  Obfuscator.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import Foundation

class Obfuscator {

  static let `default` = Obfuscator(withSalt: [NSObject.self, NSString.self, NSNumber.self])

  private var salt: String

  init(withSalt salt: [Any]) {
    self.salt = salt.description
  }

  func bytesFromString(string: String) -> [UInt8] {
    let decriptedByteArray = [UInt8](string.utf8)
    let cipher = [UInt8](self.salt.utf8)
    let length = cipher.count

    var encryptedByteArray = [UInt8]()
    for byte in decriptedByteArray.enumerated() {
      encryptedByteArray.append(byte.element ^ cipher[byte.offset % length])
    }
    return encryptedByteArray
  }

  func stringFromBytes(encryptedByteArray: [UInt8]) -> String? {
    let cipher = [UInt8](self.salt.utf8)
    let length = cipher.count

    var decryptedByteArray = [UInt8]()
    for byte in encryptedByteArray.enumerated() {
      decryptedByteArray.append(byte.element ^ cipher[byte.offset % length])
    }

    return String(bytes: decryptedByteArray, encoding: String.Encoding.utf8)
  }
}
