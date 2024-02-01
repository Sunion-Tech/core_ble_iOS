//
//  YearDayscheduleStructRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class YearDayscheduleStructRequestModel {
    
    public var status: WeekDayscheduleStructModel.ScheduleStatusEnum
    
    
    
    public var start: Date
    
    
    public var end: Date
    
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(status: WeekDayscheduleStructModel.ScheduleStatusEnum, start: Date, end: Date) {
        self.status = status
        self.start = start
        self.end = end
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.status.rawValue)
        
        
        let timeATimestamp = start.timeIntervalSince1970.toInt64
        if timeATimestamp >= 0 && timeATimestamp <= Int64(4294967295) {
            print("Int64 value is in range for unsingned UInt32")
            
            withUnsafeBytes(of: timeATimestamp) { bytes in
                for byte in bytes {
                    let stringHex = String(format: "%02X", byte)
                    let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                    byteArray.append(uint8)
                }
            }
            
            byteArray.removeLast()
            byteArray.removeLast()
            byteArray.removeLast()
            byteArray.removeLast()
            
            
            
        } else {
            print("Int64 value is out of range for UInt32")
            byteArray.append(0xFF)
            byteArray.append(0xFF)
            byteArray.append(0xFF)
            byteArray.append(0xFF)
        }
        
      
        let timeBTimestamp = end.timeIntervalSince1970.toInt64
        
        if timeBTimestamp >= 0 && timeBTimestamp <= Int64(4294967295) {
            print("Int64 value is in range for unsingned UInt32")
            
            withUnsafeBytes(of: timeBTimestamp) { bytes in
                for byte in bytes {
                    let stringHex = String(format: "%02X", byte)
                    let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                    byteArray.append(uint8)
                }
            }
            
            byteArray.removeLast()
            byteArray.removeLast()
            byteArray.removeLast()
            byteArray.removeLast()
            
            
            
        } else {
            byteArray.append(0xFF)
            byteArray.append(0xFF)
            byteArray.append(0xFF)
            byteArray.append(0xFF)
        }
        
        
        
        return byteArray
    }
}
