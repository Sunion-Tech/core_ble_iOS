//
//  CredentialStructModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/29.
//

import Foundation



public class CredentialStructModel: NSObject {

    public enum CredentialTypeEnum: UInt8 {
        case programmingPIN = 0x00
        case pin = 0x01
        case rfid = 0x02
        case fingerprint = 0x03
        case fingerVein = 0x04
        case face = 0x05
        case unknownEnumValue = 0x06
    }
    
    private var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
    }
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public var type: CredentialTypeEnum {
        self.getCredentialTypeEnum()
    }
    
    public var index: Int? {
        self.getIndex()
    }
    

    private func getCredentialTypeEnum() -> CredentialTypeEnum {
        guard  let status = response[safe: 0]  else { return .unknownEnumValue }
        
        switch status {
        case 0x00:
            return .programmingPIN
        case 0x01:
            return .pin
        case 0x02:
            return .rfid
        case 0x03:
            return .fingerprint
        case 0x04:
            return .fingerVein
        case 0x05:
            return .face
        default:
            return .unknownEnumValue
        }
    }
    
    private func getIndex() -> Int? {
        guard let firstByte = response[safe: 1],
                let secondByte = response[safe: 2] else {
              return nil
          }
        
        let data = Data([firstByte, secondByte])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        return Int(intValue)
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        byteArray.append(self.type.rawValue)
 
        
        // index
        if let index = self.index {
            let index1 = Int32(index)
            withUnsafeBytes(of: index1) { bytes in
           
                for byte in bytes {
                    let stringHex = String(format: "%02x", byte)
                    let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                  
                    byteArray.append(uint8)
                }
            }
            // index has 4 byte command just need 2 byte
            // remove last two byte
            byteArray.removeLast(2)
            
        }
  
        
        return byteArray
    }
    
}
