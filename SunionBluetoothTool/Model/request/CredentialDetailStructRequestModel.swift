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
         
            if self.type == .pin {
                byteArray.append(contentsOf: bytes)
            } else if self.type == .rfid {
                byteArray += hexStringToBytes(self.data)!
            } else {
                withUnsafeBytes(of: Int32(self.data)) { bytes in
               
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

            
    
            // 如果bytes的长度不足8位，补足0x00直到长度为8
            if bytes.count < 8 {
                let padding = [UInt8](repeating: 0x00, count: 8 - bytes.count)
                byteArray.append(contentsOf: padding)
            }
            
      
        }


        return byteArray
    }
    
    private func hexStringToBytes(_ hexString: String) -> [UInt8]? {
        var bytes = [UInt8]()
        let characters = Array(hexString)

        // Ensure the string has an even number of characters
        if characters.count % 2 != 0 {
            return nil
        }

        // Convert each character pair to a byte
        for i in stride(from: 0, to: characters.count, by: 2) {
            let pair = String(characters[i..<i+2])
            guard let byte = UInt8(pair, radix: 16) else {
                return nil  // Invalid input as it contains non-hex characters
            }
            bytes.append(byte)
        }

        return bytes
    }

}
