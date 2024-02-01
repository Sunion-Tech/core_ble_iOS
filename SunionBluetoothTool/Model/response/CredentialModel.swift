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

    }

    
    private var response:[UInt8]
    
    var command:[UInt8] {
        self.getCommand()
    }
    
   
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
        
        if val == 0x00 {
            guard  let firstByte = response[safe: 1],
                   let secondByte = response[safe: 2] else {
                return nil
            }
            
            
            let data = Data([firstByte, secondByte])
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return Int(intValue)
            
        } else {
            guard let five = response[safe: 5],
                  let sex = response[safe: 6] else {
                return nil
            }
            
            let data = Data([five, sex])
            let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
            let intValue = Int32(bitPattern: UInt32(uint32))
            return Int(intValue)
        }
        
    
    }

    private func getStatus() -> UserCredentialModel.UserStatusEnum {
        guard  let status = response[safe: 3]  else { return .unknownEnumValue }
        
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
        guard  let status = response[safe: 4]  else { return .unknownEnumValue }
        
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
        
        return String(data: Data(data), encoding: .utf8)
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
     
            models.append(CredentialDetailStructModel(response: unitData))
            
            
            // 更新索引，移动到下一个单位
            index += sizeOfUnit
        }
        
        return models
        
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        if let isCreate = isCreate {
            
            isCreate ? byteArray.append(0x00) : byteArray.append(0x01)
        }
        
        
        // credientialIndex
        if let index = self.credientialIndex {
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
        
        byteArray.append(self.status.rawValue)
        
        byteArray.append(self.type.rawValue)
        

        
        
        if let index = self.userIndex {
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
        
        self.credentialData?.data(using: .utf8)?.bytes.forEach{ byteArray.append($0)}
  
        
        return byteArray
    }
}
