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
        
        byteArray.append(self.type.rawValue)
        
        byteArray.append(self.status.rawValue)
        
        self.data.data(using: .utf8)?.bytes.forEach{ byteArray.append($0)}
          
        return byteArray
    }
}
