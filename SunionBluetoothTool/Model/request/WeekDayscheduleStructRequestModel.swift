//
//  WeekDayscheduleStructRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation
public class WeekDayscheduleStructRequestModel {
    
    public var status: WeekDayscheduleStructModel.ScheduleStatusEnum
    
    public var daymask: WeekDayscheduleStructModel.DaysMaskMap
    
    public var startHour: String
    
    public var startMinute: String
    
    public var endHour: String
    
    public var endMinute: String
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(status: WeekDayscheduleStructModel.ScheduleStatusEnum, daymask: WeekDayscheduleStructModel.DaysMaskMap, startHour: String, startMinute: String, endHour: String, endMinute: String) {
        self.status = status
        self.daymask = daymask
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.status.rawValue)
        
        byteArray.append(daymask.rawValue)
        
        let startHourIndex = startHour.toInt ?? 100
        byteArray.append(UInt8((startHourIndex * 4)))
      
        let startMinuteIndex = startMinute.toInt ?? 100
        byteArray.append(UInt8((startMinuteIndex / 15)))
       
        let endHourIndex = endHour.toInt ?? 100
        byteArray.append(UInt8((endHourIndex * 4)))
      
        let endMinuteIndex = endMinute.toInt ?? 100
        byteArray.append(UInt8((endMinuteIndex / 15)))
      

        return byteArray
    }
}
