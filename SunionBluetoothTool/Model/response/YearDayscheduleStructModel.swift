//
//  YearDayscheduleStructModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/29.
//


import Foundation

public class YearDayscheduleStructModel: NSObject {
    public enum ScheduleStatusEnum: String {
        case available
        case occupiedEnabled
        case occupiedDisabled
        case unknownEnumValue
    }
    
    
    
    private var response:[UInt8]
    
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var status: ScheduleStatusEnum {
        self.getScheduleStatusEnum()
    }
    
    
    
    public var start: Date? {
        self.getStart()
    }
    
    
    public var end: Date? {
        self.getEnd()
    }
    
    
    
    private func getScheduleStatusEnum() -> ScheduleStatusEnum {
        guard  let status = response[safe: 0]  else { return .unknownEnumValue }
        
        switch status {
        case 0x00:
            return .available
        case 0x01:
            return .occupiedEnabled
        case 0x02:
            return .occupiedDisabled
        case 0x03:
            return .unknownEnumValue
        default:
            return .unknownEnumValue
        }
    }
    
    
    private func getStart() -> Date? {
      
        guard let startTime1 = self.response[safe: 1]?.toInt else { return nil }
        guard let startTime2 = self.response[safe: 2]?.toInt else { return nil }
        guard let startTime3 = self.response[safe: 3]?.toInt else { return nil }
        guard let startTime4 = self.response[safe: 4]?.toInt else { return nil }
        
        let startTimestamp = [startTime4 << 24, startTime3 << 16, startTime2 << 8, startTime1].reduce(0, +)
        return Date(timeIntervalSince1970: Double(startTimestamp))
    }
    
    
    
    private func getEnd() -> Date? {
    
        
        guard let endTime1 = self.response[safe: 5]?.toInt else { return nil }
        guard let endTime2 = self.response[safe: 6]?.toInt else { return nil }
        guard let endTime3 = self.response[safe: 7]?.toInt else { return nil }
        guard let endTime4 = self.response[safe: 8]?.toInt else { return nil }
        
        let endTimestamp = [endTime4 << 24, endTime3 << 16, endTime2 << 8, endTime1].reduce(0, +)
        
        return Date(timeIntervalSince1970: Double(endTimestamp))
    }
}
