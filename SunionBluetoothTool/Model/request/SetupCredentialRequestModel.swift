//
//  SetupCredentialRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class SetupCredentialRequestModel {
    public var accessType: CredentialStructModel.CredentialTypeEnum
    
    public var state: setupAccessOption

    public var index: Int
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(type:  CredentialStructModel.CredentialTypeEnum, index: Int, state: setupAccessOption) {
        self.accessType = type
        self.index = index
        self.state = state
        
    }

    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = [accessType.rawValue, state.rawValue]
        let time = Int32(index)
        withUnsafeBytes(of: time) { bytes in
       
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
              
                byteArray.append(uint8)
            }
        }
        // time has 4 byte command just need 2 byte
        // remove last two byte
        byteArray.removeLast(2)

     
        return byteArray
    }
}
