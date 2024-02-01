//
//  SearchCredentialModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//


import Foundation

public class SearchCredentialRequestModel {




    public var index: Int?
    
    public var format: CredentialModel.FormatEnum
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(format: CredentialModel.FormatEnum, index: Int) {
        self.format = format
        self.index = index
    }

    private func getCommand()-> [UInt8] {
        
        var byteArray:[UInt8] = []
        
        switch format {
        case .user:
            byteArray.append(0x01)
        case .credential:
            byteArray.append(0x00)
        }
        
        
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
