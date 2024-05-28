//
//  WeekDayscheduleStructRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation
public class WeekDayscheduleStructRequestModel {
    
    public var status: WeekDayscheduleStructModel.ScheduleStatusEnum
    
    public var daymask: [Int]
    
    public var startHour: String
    
    public var startMinute: String
    
    public var endHour: String
    
    public var endMinute: String
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(status: WeekDayscheduleStructModel.ScheduleStatusEnum, daymask: [Int], startHour: String, startMinute: String, endHour: String, endMinute: String) {
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
        
        byteArray.append(getDaymask())
        
        if let startHourIndex = startHour.toInt {
            byteArray.append(UInt8((startHourIndex)))
        }
       
      
        if let startMinuteIndex = startMinute.toInt {
            byteArray.append(UInt8((startMinuteIndex)))
        }
      
       
        if let endHourIndex = endHour.toInt {
            byteArray.append(UInt8((endHourIndex)))
        }
       
      
        if let endMinuteIndex = endMinute.toInt {
            byteArray.append(UInt8((endMinuteIndex)))
        }
        
      

        return byteArray
    }
    
    private func getDaymask()-> UInt8 {
        //write order sun ... sat

        //array = [sun mon tue wed thur fri sat]
        //sun mon tue wed thur fri sat
        let bit =
        daymask[6].toString +
        daymask[5].toString +
        daymask[4].toString +
        daymask[3].toString +
        daymask[2].toString +
        daymask[1].toString +
        daymask[0].toString
        
        return UInt8(bit, radix: 2) ?? 0x00
    }
}
