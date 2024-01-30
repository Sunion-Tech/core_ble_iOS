//
//  WeekDayscheduleStructModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/29.
//


import Foundation

public class WeekDayscheduleStructModel: NSObject {
    public enum ScheduleStatusEnum: String {
        case available
        case occupiedEnabled
        case occupiedDisabled
        case unknownEnumValue
    }
    
    public enum DaysMaskMap: String {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    private var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
    }
    
    public var status: ScheduleStatusEnum {
        self.getScheduleStatusEnum()
    }
    
    public var daymask: DaysMaskMap? {
        self.getDayMaskMap()
    }
    
    public var startHour: String? {
        self.getStartHour()
    }
    
    public var startMinute: String? {
        self.getStartMinute()
    }
    
    public var endHour: String? {
        self.getEndHour()
    }
    
    public var endMinute: String? {
        self.getEndMinute()
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
    
    private func getDayMaskMap() -> DaysMaskMap? {
        guard  let day = response[safe: 1]  else { return nil }
        switch day {
        case 0x01:
            return .sunday
        case 0x02:
            return .monday
        case 0x04:
            return .tuesday
        case 0x08:
            return .wednesday
        case 0x10:
            return .thursday
        case 0x20:
            return .friday
        case 0x40:
            return .saturday
        default:
            return nil
        }
        
    }
    

    
    private func getStartHour() -> String? {
        guard  let time = response[safe: 2]  else { return nil }
        let startHour = (time.toInt / 4).toString
        return startHour
    }
    
    private func getStartMinute() -> String? {
        guard  let time = response[safe: 3]  else { return nil }
        let startMinute = ((time % 4).toInt * 15).toString
        return startMinute
    }
    
    private func getEndHour() -> String? {
        guard  let time = response[safe: 4]  else { return nil }
        let endHour = (time.toInt / 4).toString
        return endHour
    }
    
    private func getEndMinute() -> String? {
        guard  let time = response[safe: 5]  else { return nil }
        let endMinute = ((time % 4).toInt * 15).toString
        return endMinute
    }

    
}
