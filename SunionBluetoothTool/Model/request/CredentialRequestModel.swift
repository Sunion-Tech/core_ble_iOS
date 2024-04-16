//
//  CredentialRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class CredentialRequestModel {
    
    
    public var credientialIndex: Int
    
    public var userIndex: Int
    
    public var credentialData: CredentialDetailStructRequestModel
    
    public var isCreate: Bool
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(credientialIndex: Int, userIndex: Int, credentialData: CredentialDetailStructRequestModel, isCreate: Bool) {
        self.credientialIndex = credientialIndex
        self.userIndex = userIndex
    
        self.credentialData = credentialData
        self.isCreate = isCreate
    }
    
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        

            
        isCreate ? byteArray.append(0x00) : byteArray.append(0x01)
        
        
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
        
        credentialData.command.forEach { el in
            byteArray.append(el)
        }
    
        return byteArray
    }
}
