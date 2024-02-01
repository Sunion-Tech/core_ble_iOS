//
//  CredentialRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class CredentialRequestModel {
    
    public var format: CredentialModel.FormatEnum
    
    public var credientialIndex: Int
    
    public var userIndex: Int
    
    public var status: UserCredentialModel.UserStatusEnum
    
    public var type: CredentialStructModel.CredentialTypeEnum
    
    public var credentialData: String
    
    public var credentialDetailStruct: [CredentialDetailStructRequestModel]?
    
    public var isCreate: Bool?
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(format: CredentialModel.FormatEnum, credientialIndex: Int, userIndex: Int, status: UserCredentialModel.UserStatusEnum, type: CredentialStructModel.CredentialTypeEnum, credentialData: String, credentialDetailStruct: [CredentialDetailStructRequestModel]? = nil, isCreate: Bool? = nil) {
        self.format = format
        self.credientialIndex = credientialIndex
        self.userIndex = userIndex
        self.status = status
        self.type = type
        self.credentialData = credentialData
        self.credentialDetailStruct = credentialDetailStruct
        self.isCreate = isCreate
    }
    
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        if let isCreate = isCreate {
            
            isCreate ? byteArray.append(0x00) : byteArray.append(0x01)
        }
        
        
        // credientialIndex
        let index1 = Int32(credientialIndex)
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
        
        byteArray.append(self.status.rawValue)
        
        byteArray.append(self.type.rawValue)
        

        
        let index2 = Int32(userIndex)
        withUnsafeBytes(of: index2) { bytes in
       
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
              
                byteArray.append(uint8)
            }
        }
        // index has 4 byte command just need 2 byte
        // remove last two byte
        byteArray.removeLast(2)
        
        self.credentialData.data(using: .utf8)?.bytes.forEach{ byteArray.append($0)}
  
        
        return byteArray
    }
}
