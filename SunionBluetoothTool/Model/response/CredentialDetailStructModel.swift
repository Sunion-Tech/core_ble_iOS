//
//  CredentialDetailStructModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/31.
//

import Foundation

public class CredentialDetailStructModel: NSObject {

    
    private var response:[UInt8]
    
    init(response:[UInt8]) {
        self.response = response
    }
    

    
    public var status: UserCredentialModel.UserStatusEnum {
        self.getStatus()
    }
    
    public var type: CredentialStructModel.CredentialTypeEnum {
        self.getCredentialTypeEnum()
    }
    
    public var data: String? {
        self.getcredentialData()
    }
    
    
    private func getCredentialTypeEnum() -> CredentialStructModel.CredentialTypeEnum {
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
    
    private func getStatus() -> UserCredentialModel.UserStatusEnum {
        guard  let status = response[safe: 1]  else { return .unknownEnumValue }
        
        switch status {
        case 0x00:
            return .available
        case 0x01:
            return .occupiedEnabled
        case 0x03:
            return .occupiedDisabled
        default:
            return .unknownEnumValue
        }
    }
    
    private func getcredentialData() -> String? {
        guard  response[safe: 2] != nil  else { return nil }
        
        let data = self.response[2...self.response.count-1]
        
        if type == .pin {
            let filteredData = data.filter { $0 >= 0x30 && $0 <= 0x39 }
            
       
            return String(filteredData.map { Character(UnicodeScalar($0)) })
        }
        
        if type == .fingerprint || type == .face {
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return String(Int(intValue))
        }
        
        if type == .rfid {
            return Array(data).toHexString()
        }
        
        return ""
    }
    

}
