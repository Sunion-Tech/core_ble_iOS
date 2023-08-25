//
//  AESModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//




import CryptoSwift
import Foundation

class AESModel {

    static let shared = AESModel()

    func encrypt(key:[UInt8], _ bytes:[UInt8])-> [UInt8]? {

        do {
            let aes = try AES(key: key, blockMode: ECB(), padding: .noPadding)
            let encrypted = try aes.encrypt(bytes)
            return encrypted

        } catch let error {
            print("aes encrypt error \(error)")
            return nil
        }
    }

    func decrypt(key: [UInt8], _ data: Data) -> [UInt8]? {
//        print("aes model key \(key.bytesToHex()) ")
        let bytesArray = Array(data)
        do {
            let aes = try AES(key: key, blockMode: ECB(), padding: .noPadding)
            let decode = try aes.decrypt(bytesArray)
            return decode
        } catch let error {
            print("aes decrypt error \(error)")
            return nil
        }
    }

    func decodeBase64String(_ base64String:String, barcodeKey: String)-> String? {
        guard let decodeData = base64String.fromBase64?.bytes else { return nil }
        do {
            guard let key = barcodeKey.data(using: .utf8)?.bytes else { return nil }
            let aes = try AES(key: key, blockMode: ECB())
            let ciphertext = try aes.decrypt(decodeData)
            let string = String(data: Data(ciphertext), encoding: .utf8)
            return string
        } catch let error {
            print("decode base64 error \(error)")
            return nil

        }
    }

    func encodeBase64String(_ string:String, barcodeKey: String)-> String? {
        guard let encodeData = string.data(using: .utf8)?.bytes else { return nil }
        do {
            guard let key = barcodeKey.data(using: .utf8)?.bytes else { return nil }
            let aes = try AES(key: key, blockMode: ECB())
            let ciphertext = try aes.encrypt(encodeData)
            return ciphertext.toBase64()
        } catch let error {
            print("encode base64 error \(error)")
            return nil

        }
    }
}

