//
//  CredentialDetailStructRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation
public class CredentialDetailStructRequestModel {
    
    public var credientialIndex: Int
    
    public var status: UserCredentialModel.UserStatusEnum
    
    public var type: CredentialStructModel.CredentialTypeEnum
    
    public var data: String
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(credientialIndex: Int,status: UserCredentialModel.UserStatusEnum, type: CredentialStructModel.CredentialTypeEnum, data: String) {
        self.credientialIndex = credientialIndex
        self.status = status
        self.type = type
        self.data = data
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        
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

        
        if let data = self.data.data(using: .utf8) {
            let bytes = [UInt8](data)
            byteArray.append(contentsOf: bytes)
            
            // 如果bytes的长度不足8位，补足0x00直到长度为8
            if bytes.count < 8 {
                let padding = [UInt8](repeating: 0x00, count: 8 - bytes.count)
                byteArray.append(contentsOf: padding)
            }
        }
          
        return byteArray
    }
}
