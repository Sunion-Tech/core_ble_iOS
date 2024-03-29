//
//  CredentialDetailStructRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation
public class CredentialDetailStructRequestModel {
    
    public var status: UserCredentialModel.UserStatusEnum
    
    public var type: CredentialStructModel.CredentialTypeEnum
    
    public var data: String
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(status: UserCredentialModel.UserStatusEnum, type: CredentialStructModel.CredentialTypeEnum, data: String) {
        self.status = status
        self.type = type
        self.data = data
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
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
