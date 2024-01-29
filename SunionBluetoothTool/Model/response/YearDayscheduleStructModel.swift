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
    
    
    
    public var start: Int? {
        self.getStart()
    }
    
    
    public var end: Int? {
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
    
    
    private func getStart() -> Int? {
        guard  let time = response[safe: 1]  else { return nil }
        
        return time.toInt
    }
    
    
    
    private func getEnd() -> Int? {
        guard  let time = response[safe: 2]  else { return nil }
        
        return time.toInt
    }
}
