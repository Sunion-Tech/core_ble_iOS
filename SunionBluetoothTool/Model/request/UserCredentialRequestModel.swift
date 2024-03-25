//
//  UserCredentialRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class UserCredentialRequestModel {
    
    public var isCreate: Bool
    
    public var index: Int
    
    public var name: String
    
    public var uid: Int
    
    public var status: UserCredentialModel.UserStatusEnum
    
    public var type: UserCredentialModel.UserTypeEnum
    
    public var credentialRule: UserCredentialModel.CredentialRuleEnum
    
    public var credentialStruct: [CredentialStructRequestModel]
    
    public var weekDayscheduleStruct: [WeekDayscheduleStructRequestModel]
    
    public var yearDayscheduleStruct: [YearDayscheduleStructRequestModel]
    
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(isCreate: Bool, index: Int, name: String, uid: Int, status: UserCredentialModel.UserStatusEnum, type: UserCredentialModel.UserTypeEnum, credentialRule: UserCredentialModel.CredentialRuleEnum, credentialStruct: [CredentialStructRequestModel], weekDayscheduleStruct: [WeekDayscheduleStructRequestModel], yearDayscheduleStruct: [YearDayscheduleStructRequestModel]) {
        self.isCreate = isCreate
        self.index = index
        self.name = name
        self.uid = uid
        self.status = status
        self.type = type
        self.credentialRule = credentialRule
        self.credentialStruct = credentialStruct
        self.weekDayscheduleStruct = weekDayscheduleStruct
        self.yearDayscheduleStruct = yearDayscheduleStruct
    }
    
    private func getCommand()-> [UInt8] {
        
        var byteArray:[UInt8] = []
        
        isCreate ? byteArray.append(0x00) : byteArray.append(0x01)
        
        // index
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
        
        // name
        
           name.data(using: .utf8)?.bytes.forEach{ byteArray.append($0)}
           
           let nameLength = Int32(name.data(using: .utf8)?.count ?? 0)
           
           // (固定長度, 若不足請補 0x00) 10 byte
           if nameLength < 10 {
               let bytesToAdd = 10 - nameLength
               for _ in 0..<bytesToAdd {
                   byteArray.append(0x00)
               }
           }
        
        print("before: \(byteArray.count)")
        // uid
        withUnsafeBytes(of: uid) { bytes in
            for byte in bytes {
                let stringHex = String(format: "%02X", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                byteArray.append(uint8)
            }
        }
        
        print("after: \(byteArray.count)")
        
        // uid has 8 byte command just need 4 byte
        // remove last two byte
        byteArray.removeLast(4)

      
        
        print("after removeLast: \(byteArray.count)")
        
        
        byteArray.append(self.status.rawValue)
      
        byteArray.append(self.type.rawValue)
        
        byteArray.append(self.credentialRule.rawValue)
        
        
        print("before credentialStruct: \(byteArray.count)")
        
        credentialStruct.forEach { value in
            byteArray = byteArray + value.command
            
        }
        
        print("after credentialStruct: \(byteArray.count)")
        
        
        print("before weekDayscheduleStruct: \(byteArray.count)")
        
        weekDayscheduleStruct.forEach { value in
            byteArray = byteArray + value.command
            
        }
        
        print("after weekDayscheduleStruct: \(byteArray.count)")
        
        
        print("before yearDayscheduleStruct: \(byteArray.count)")
        yearDayscheduleStruct.forEach { value in
            byteArray = byteArray + value.command
            
        }
        
        print("after yearDayscheduleStruct: \(byteArray.count)")

        return byteArray
    }
}
