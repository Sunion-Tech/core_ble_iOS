//
//  CredentialStructModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/29.
//

import Foundation

public class CredentialStructModel: NSObject {
    public enum CredentialTypeEnum: String {
        case programmingPIN
        case pin
        case rfid
        case fingerprint
        case fingerVein
        case face
        case unknownEnumValue
    }
    
    private var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
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
    
}
