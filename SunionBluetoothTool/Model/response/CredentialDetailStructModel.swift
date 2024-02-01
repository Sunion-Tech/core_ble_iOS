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
    
    var command:[UInt8] {
        self.getCommand()
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
        guard  response[safe: 3] != nil  else { return nil }
        
        let data = self.response[3...9]
        
        return String(data: Data(data), encoding: .utf8)
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.type.rawValue)
        
        byteArray.append(self.status.rawValue)
        
        self.data?.data(using: .utf8)?.bytes.forEach{ byteArray.append($0)}
          
        return byteArray
    }
}
