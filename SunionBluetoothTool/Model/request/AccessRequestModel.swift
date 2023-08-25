//
//  AccessRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/8.
//

import Foundation



public class AccessRequestModel {
    
    public enum accesseOption: String {
        case add
        case edit
        
    }
    
    private var index: Int
    private var isEnable: Bool
    private var type: AccessTypeOption
    
    private var name: String?
    private var codecard: [Int]?
    private var schedule: scheduleModel
    var command: [UInt8] {
        self.getCommand()
    }
    
    public var accessOption: accesseOption
    
    
    var commandLength: UInt8 {
        self.getCommandLength()
    }
    
    public init(type: AccessTypeOption, index: Int, isEnable: Bool, codecard: [Int]? = nil, name: String? = nil, schedule: scheduleModel, accessOption: accesseOption) {
        self.type = type
        self.index = index
        self.isEnable = isEnable
        self.codecard = codecard
        self.name = name
        self.schedule = schedule
        self.accessOption = accessOption
    }
    
    private func getCommandLength()-> UInt8 {
        let fixLength = 17 // 16 default + 1 name data
        let nameLength = self.name?.data(using: .utf8)?.count ?? 0
        let codeCardLength = self.codecard?.count ?? 0
        
        let totalLength = fixLength + nameLength + (self.type == .Fingerprint ? 0 : codeCardLength)
        return UInt8(totalLength)
    }
    
    private func getCommand()-> [UInt8] {
        
        // command
        var firstCommand: [UInt8] = []
        switch accessOption {
        case .add:
            firstCommand = [0xA7, self.getCommandLength()]
        case .edit:
            firstCommand = [0xA8, self.getCommandLength()]
            
        }
        
        // type
        var typecommand: UInt8 = 0x00
        switch type {
        case .AccessCode:
            typecommand =  0x00
        case .AccessCard:
            typecommand = 0x01
        case .Fingerprint:
            typecommand = 0x02
        case .Face:
            typecommand = 0x03
        case .error:
            break
        }
        
        
        // index
        var index: [UInt8] = []
        
        let time = Int32(self.index)
        withUnsafeBytes(of: time) { bytes in
            
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                
                index.append(uint8)
            }
        }
        // time has 4 byte command just need 2 byte
        // remove last two byte
        index.removeLast(2)
        
        // enalbe
        let isEnable: UInt8 = self.isEnable ? 0x01 : 0x00
        
        
        var command = firstCommand + [typecommand] + index + [isEnable]
        
        // schedule
        self.schedule.command.forEach{ command.append($0)}
        
        // name len
        var nameLen: [UInt8] = []
        let nameLength = Int32(self.name?.data(using: .utf8)?.count ?? 0)
        withUnsafeBytes(of: nameLength) { bytes in
            
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                
                nameLen.append(uint8)
            }
        }
        // time has 4 byte command just need 2 byte
        // remove last two byte
        command.append(nameLen.first!)
        
        
        // name
        self.name?.data(using: .utf8)?.bytes.forEach{ command.append($0)}
        
        // cordcard
        if self.type != .Fingerprint {
            self.codecard?.forEach{ command.append(UInt8($0))}
        }
        
        return command
    }
}



public class scheduleModel {
    
    var command: [UInt8] {
        self.getCommand()
    }
    
    public enum AvailableOption {
        case all
        case none
        case once
        case weekly(UInt8, UInt8, UInt8)
        case validTime(Date, Date)
    }
    
    var availableOption:AvailableOption
    
    public init(availableOption: AvailableOption) {
        self.availableOption = availableOption
    }
    
    private func getCommand()-> [UInt8] {
        switch self.availableOption {
        case .all:
            let data = "A".data(using: .utf8)?.bytes ?? []
            return self.fillRandomBytes(data)
        case .none:
            let data = "N".data(using: .utf8)?.bytes ?? []
            return self.fillRandomBytes(data)
        case .once:
            let data = "O".data(using: .utf8)?.bytes ?? []
            return self.fillRandomBytes(data)
        case .weekly(let week, let timeA, let timeB):
            var data = "W".data(using: .utf8)?.bytes ?? []
            data.append(week)
            data.append(timeA)
            data.append(timeB)
            return self.fillRandomBytes(data, 8)
        case .validTime(let timeA, let timeB):
            let timeATimestamp = timeA.timeIntervalSince1970.toInt64
            let timeBTimestamp = timeB.timeIntervalSince1970.toInt64
            
            
            print("write start \(timeATimestamp)")
            print("write end \(timeBTimestamp)")
            
            var data = "S".data(using: .utf8)?.bytes ?? []
            data.append(0x00)
            data.append(0x00)
            data.append(0x00)
            
      
            
            
            if timeATimestamp >= 0 && timeATimestamp <= Int64(4294967295) {
                print("Int64 value is in range for unsingned UInt32")
                
                withUnsafeBytes(of: timeATimestamp) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02X", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        data.append(uint8)
                    }
                }
                
                data.removeLast()
                data.removeLast()
                data.removeLast()
                data.removeLast()
                
                
                
            } else {
                print("Int64 value is out of range for UInt32")
                data.append(0xFF)
                data.append(0xFF)
                data.append(0xFF)
                data.append(0xFF)
            }
            

            
            
            if timeBTimestamp >= 0 && timeBTimestamp <= Int64(4294967295) {
                print("Int64 value is in range for unsingned UInt32")
                
                withUnsafeBytes(of: timeBTimestamp) { bytes in
                    for byte in bytes {
                        let stringHex = String(format: "%02X", byte)
                        let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                        data.append(uint8)
                    }
                }
                
                data.removeLast()
                data.removeLast()
                data.removeLast()
                data.removeLast()
                
                
                
            } else {
                data.append(0xFF)
                data.append(0xFF)
                data.append(0xFF)
                data.append(0xFF)
            }

            return data
        }
    }
    
    func fillRandomBytes(_ data:[UInt8], _ fillCount:Int = 11)-> [UInt8] {
        var byteArray = data
        
        for _ in 0...fillCount - 1  {
            byteArray.append(UInt8.random(in: 0x00...0xff))
        }
        
        return byteArray
    }
}
