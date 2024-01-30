//
//  UserCredential.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/29.
//

import Foundation



public class UserCredentialModel {
    
    public enum UserStatusEnum: String {
        case available // 可用
        case occupiedEnabled // 已使用 目前啟用
        case occupiedDisabled // 已使用 目前停用
        case unknownEnumValue
    }
    
    public enum UserTypeEnum: String {
        case unrestrictedUser
        case yearDayScheduleUser
        case weekDayScheduleUser
        case programmingUser
        case nonAccessUser
        case forcedUser
        case disposableUser
        case expiringUser
        case scheduleRestrictedUser
        case remoteOnlyUser
        case unknownEnumValue
    }
    
    public enum CredentialRuleEnum: String {
        case single
        case dual
        case tri
        case unknownEnumValue
    }
    

    

    private var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
    }
    
    public var index: Int? {
        self.getUserIndex()
    }
    
    public var name: String? {
        self.getName()
    }
    
    public var uid: String? {
        self.getUid()
    }
    
    public var status: UserStatusEnum {
        self.getStatus()
    }
    
    public var type: UserTypeEnum {
        self.getType()
    }
    
    public var credentialRule: CredentialRuleEnum {
        self.getcredentialRule()
    }
    
    public var credentialStruct: [CredentialStructModel]? {
        self.getCredentialStruct()
    }
    
    public var weekDayscheduleStruct: [WeekDayscheduleStructModel]? {
        self.getWeekDayscheduleStructModel()
    }
    
    public var yearDayscheduleStruct: [YearDayscheduleStructModel]? {
        self.getYearDayscheduleStruct()
    }

    private func getUserIndex() -> Int? {
        guard let firstByte = response[safe: 0],
                let secondByte = response[safe: 1] else {
              return nil
          }
        
        let data = Data([firstByte, secondByte])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        return Int(intValue)
        
    }
    
    private func getName() -> String? {

        guard response[safe: 2] != nil else { return nil }
        guard response[safe: 11] != nil else { return nil }

        let data = self.response[2...11]
        return String(data: Data(data), encoding: .utf8)
    }
    
    private func getUid() -> String? {
        guard response[safe: 12] != nil else { return nil }
        guard response[safe: 15] != nil else { return nil }
        
        let data = self.response[12...15]
        return String(data: Data(data), encoding: .utf8)
    }

    private func getStatus() -> UserStatusEnum {
        guard  let status = response[safe: 16]  else { return .unknownEnumValue }
        
        switch status {
        case 0x00:
            return .available
        case 0x01:
            return .occupiedEnabled
        case 0x02:
            return .occupiedDisabled
        default:
            return .unknownEnumValue
        }
    }
    
    private func getType() -> UserTypeEnum {
        guard  let type = response[safe: 17]  else { return .unknownEnumValue }
        
        switch type {
        case 0x00:
            return .unrestrictedUser
        case 0x01:
            return .yearDayScheduleUser
        case 0x02:
            return .weekDayScheduleUser
        case 0x03:
            return .programmingUser
        case 0x04:
            return .nonAccessUser
        case 0x05:
            return .forcedUser
        case 0x06:
            return .disposableUser
        case 0x07:
            return .expiringUser
        case 0x08:
            return .scheduleRestrictedUser
        case 0x09:
            return .remoteOnlyUser
        default:
            return .unknownEnumValue
        }
    }
    
    private func getcredentialRule() -> CredentialRuleEnum {
        guard  let credential = response[safe: 18]  else { return .unknownEnumValue }
        
        switch credential {
        case 0x00:
            return .single
        case 0x01:
            return .dual
        case 0x02:
            return .tri
        default:
            return .unknownEnumValue
        }
    }

    private func getCredentialStruct() -> [CredentialStructModel]? {
        guard let n1 = response[safe: 19],
        n1 != 0 else { return nil }
        
        var structs: [[UInt8]] = []
        // 确保response有足够的元素来取出n1组数据
        for i in 0..<n1.toInt {
            let start = 22 + i * 3
            let end = start + 2 // 取三个元素
            
            // 检查是否可以从response安全地取出这些元素
            guard let _ = response[safe: end] else { return nil }
            let group = Array(response[start...end])
            structs.append(group)
        }
        
        var models: [CredentialStructModel] = []
        
        structs.forEach { value in
            let data = CredentialStructModel(response: value)
            models.append(data)
        }

        return models
    }
    
    private func getWeekDayscheduleStructModel() -> [WeekDayscheduleStructModel]? {
        guard let n1 = response[safe: 19], n1 != 0,
              let n2 = response[safe: 20], n2 != 0 else { return nil }
        
        var structs: [[UInt8]] = []
        // 确保response有足够的元素来取出n1组数据
        for i in 0..<n2.toInt {
            let start = 22 + (n1.toInt * 3) + i * 6
            let end = start + 5 // 取六个元素
            
            // 检查是否可以从response安全地取出这些元素
            guard let _ = response[safe: end] else { return nil }
            let group = Array(response[start...end])
            structs.append(group)
        }
        
        var models: [WeekDayscheduleStructModel] = []
        
        structs.forEach { value in
            let data = WeekDayscheduleStructModel(response: value)
            models.append(data)
        }

        return models
        
      
    }
    
    private func getYearDayscheduleStruct() -> [YearDayscheduleStructModel]? {
        guard let n1 = response[safe: 19], n1 != 0,
              let n2 = response[safe: 20], n2 != 0,
              let n3 = response[safe: 21], n3 != 0 else { return nil }
        
        var structs: [[UInt8]] = []
        // 确保response有足够的元素来取出n1组数据
        for i in 0..<n3.toInt {
            let start = 22 + (n1.toInt * 3) + (n2.toInt * 6) + i * 5
            let end = start + 8 // 取九个元素
            
            // 检查是否可以从response安全地取出这些元素
            guard let _ = response[safe: end] else { return nil }
            let group = Array(response[start...end])
            structs.append(group)
        }
        
        var models: [YearDayscheduleStructModel] = []
        
        structs.forEach { value in
            let data = YearDayscheduleStructModel(response: value)
            models.append(data)
        }

        return models
        
      
    }

}
