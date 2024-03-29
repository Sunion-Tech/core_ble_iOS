//
//  CredentialModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/31.
//


import Foundation
public class CredentialModel {
    
    public enum FormatEnum: UInt8 {
        case user = 0x01
        case credential = 0x00
        
        public var description: String {
               switch self {
               case .user:
                   return "User"
               case .credential:
                   return "Credential"
              
               }
           }

    }

    
    private var response:[UInt8]
    

    
   
    init(response:[UInt8]) {
        self.response = response

    }
     
    public var format: FormatEnum? {
        self.getFormat()
    }
    
    public var credientialIndex: Int? {
        self.cIndex()
    }
    
    public var userIndex: Int? {
        self.uIndex()
    }
    
    public var status: UserCredentialModel.UserStatusEnum {
        self.getStatus()
    }
    
    public var type: CredentialStructModel.CredentialTypeEnum {
        self.getCredentialTypeEnum()
    }
    
    public var credentialData: String? {
        self.getcredentialData()
    }
    
    public var credentialDetailStruct: [CredentialDetailStructModel]? {
        self.getcredentialDetailStruct()
    }
    
    public var isCreate: Bool?

    
    private func getFormat() -> FormatEnum? {
        guard let val = response[safe: 0] else { return nil}
        return val == 0x00 ? .credential : .user
    }
    
    private func cIndex() -> Int? {
        guard  let firstByte = response[safe: 1],
               let secondByte = response[safe: 2] else {
            return nil
        }
        
        
        let data = Data([firstByte, secondByte])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        return Int(intValue)
        
        
        
        
    }
    
    private func uIndex() -> Int? {
        
        guard let val = response[safe: 0] else { return nil}
        
        if val == 0x01 {
            guard  let firstByte = response[safe: 1],
                   let secondByte = response[safe: 2] else {
                return nil
            }
            
            
            let data = Data([firstByte, secondByte])
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return Int(intValue)
            
        } else {
            guard let five = response[safe: 3],
                  let sex = response[safe: 4] else {
                return nil
            }
            
            let data = Data([five, sex])
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return Int(intValue)
        }
        
    
    }

    private func getStatus() -> UserCredentialModel.UserStatusEnum {
        guard  let status = response[safe: 5]  else { return .unknownEnumValue }
        
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


    private func getCredentialTypeEnum() -> CredentialStructModel.CredentialTypeEnum {
        guard  let status = response[safe: 6]  else { return .unknownEnumValue }
        
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
    
    private func getcredentialData() -> String? {
        guard  response[safe: 7] != nil  else { return nil }
        
        let data = self.response[7...self.response.count-1]
    
        
        if type == .pin {
            let filteredData = data.filter { $0 >= 0x30 && $0 <= 0x39 }
            
       
            return String(filteredData.map { Character(UnicodeScalar($0)) })
        }
        
        if type == .fingerprint || type == .face {
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return String(Int(intValue))
        }
        
        if type == .rfid {
            return Array(data).toHexString()
        }
        
        return ""
  
    }
    
    private func getcredentialDetailStruct() -> [CredentialDetailStructModel]? {
        guard  response[safe: 3] != nil  else { return nil }
        var models: [CredentialDetailStructModel] = []
        
        let length = response.count
         let sizeOfUnit = 9  // 每个单位的字节大小
         var index = 3  // 从索引3开始
        
        while index + sizeOfUnit <= length {
            // 获取从index开始的10个字节
            let unitData = Array(response[index..<(index + sizeOfUnit)])
            // 假设你有一个方法来从一个字节数组创建一个CredentialDetailStructModel
            print("CredentialDetailStructModel: \(Array(response[index..<(index + sizeOfUnit)]).toHexString())")
            models.append(CredentialDetailStructModel(response: unitData))
            
            
            // 更新索引，移动到下一个单位
            index += sizeOfUnit
        }
        
        return models
        
    }
    
 
}
