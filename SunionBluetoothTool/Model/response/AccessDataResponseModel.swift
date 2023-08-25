//
//  AccessModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/8.
//

import Foundation



public class AccessDataResponseModel {

    private var response:[UInt8]

    public var isEnable:Bool {
        self.getIsEnable()
    }

    
    public  var type: AccessTypeOption {
        self.getAccessType()
    }
    
    public var index: Int? {
        self.getIndex()
    }
    
    public var nameLength: UInt8? {
        self.getNameLength()
    }
    
    public var name:String? {
        self.getName()
    }

    public var codeCard: [UInt8]? {
        self.getCodeCard()
    }



    public var schedule: UserCodeScheduleResult? {
        guard self.response[safe: 4] != nil else { return nil }
        return UserCodeScheduleResult(response: self.response)
    }

    public init(response:[UInt8]) {
        self.response = response
    }

    private func getIsEnable()-> Bool {
        guard let index0 = self.response[safe: 3] else { return false }
        return index0 == 0x01
    }

    private func getAccessType() -> AccessTypeOption {
        guard let index0 = self.response[safe: 0] else { return .error }
        switch index0 {
        case 0x00:
            return .AccessCode
        case 0x01:
            return .AccessCard
        case 0x02:
            return .Fingerprint
        case 0x03:
            return .Face
        default:
            return .error
        }
    }
    
    private func getIndex() -> Int? {
        guard let index1 = self.response[safe: 1] else { return nil }
        guard let index2 = self.response[safe: 2] else { return nil }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }

    
    private func getNameLength() -> UInt8? {
        guard let index1 = self.response[safe: 16] else { return nil }
        return index1
    }
    
    private func getName()-> String? {
        guard let nameLength = self.nameLength else { return nil }
        let nameIndex = 17 + nameLength.toInt
        guard nameIndex <= self.response.count else { return nil }
        
        let data = self.response[17...nameIndex-1]
        
        return String(data: Data(data), encoding: .utf8)
    }

    private func getCodeCard() -> [UInt8]? {
        guard let nameLength = self.nameLength else { return nil }
        let nameIndex = 17 + nameLength.toInt
        guard nameIndex <= self.response.count else { return nil }
    
        let data = Array(self.response[nameIndex...self.response.count - 1])
        return data
    }



}
public class UserCodeScheduleResult {

    var response:[UInt8]
   

    public enum ScheduleOption {
        case all
        case none
        case once
        case weekly([Int], String, String)
        case validTime(Date, Date)
        case error

        public var scheduleName:String {
            switch self {
            case .all:
                return "Permanent"
            case .once:
                return "Single Entry"
            case .weekly:
                return "Scheduled Entry"
            case .validTime:
                return "Valid Time Range"
            default:
                return "---"
            }
        }
    }

    public  var scheduleOption: ScheduleOption {
        self.getScheduleType()
    }

    public init(response:[UInt8]) {
        self.response = response
 
    }

    private func getScheduleType()-> ScheduleOption {
        guard let indexOfSchedule = self.response[safe: 4] else { return .error }
        guard let scheduleString = String(data: Data([indexOfSchedule]), encoding: .utf8) else { return .error }
        switch scheduleString.uppercased() {
        case "A":
            return .all
        case "N":
            return .none
        case "O":
            return .once
        case "W":
            guard let week = self.response[safe: 5] else { return .error }
            guard let timeA = self.response[safe: 6] else { return .error }
            guard let timeB = self.response[safe: 7] else { return .error }
            let bits = week.bits.map{Int($0)}
            let startHour = (timeA.toInt / 4).toString
            let startMinute = ((timeA % 4).toInt * 15).toString
            let endHour = (timeB.toInt / 4).toString
            let endMinute = ((timeB % 4).toInt * 15).toString
            return .weekly(bits, startHour + ":" + startMinute, endHour + ":" + endMinute)
        case "S":
            guard let startTime1 = self.response[safe: 8]?.toInt else { return .error }
            guard let startTime2 = self.response[safe: 9]?.toInt else { return .error }
            guard let startTime3 = self.response[safe: 10]?.toInt else { return .error }
            guard let startTime4 = self.response[safe: 11]?.toInt else { return .error }

            let startTimestamp = [startTime4 << 24, startTime3 << 16, startTime2 << 8, startTime1].reduce(0, +)

            guard let endTime1 = self.response[safe: 12]?.toInt else { return .error }
            guard let endTime2 = self.response[safe: 13]?.toInt else { return .error }
            guard let endTime3 = self.response[safe: 14]?.toInt else { return .error }
            guard let endTime4 = self.response[safe: 15]?.toInt else { return .error }

            let endTimestamp = [endTime4 << 24, endTime3 << 16, endTime2 << 8, endTime1].reduce(0, +)

            print("start time \(startTimestamp)")
            print("end time \(endTimestamp)")
            return .validTime(Date(timeIntervalSince1970: Double(startTimestamp)), Date(timeIntervalSince1970: Double(endTimestamp)))
        default:
            return .error
        }
    }
    
    func getwifiScheduleType(data: apiResDeivceAccessCodeListAccessCode )-> ScheduleOption {
        guard let str = data.Attributes?.Rule?.first?.type else {
            return .error
        }

        switch str {
        case "A":
            return .all
        case "N":
            return .none
        case "O":
            return .once
        case "W":
            guard let week = data.Attributes?.Rule?.first?.Conditions?.Scheduled?.WeekDay else { return .error }
            guard let timeA = data.Attributes?.Rule?.first?.Conditions?.Scheduled?.StartTime else { return .error }
            guard let timeB = data.Attributes?.Rule?.first?.Conditions?.Scheduled?.EndTime else { return .error }
            let bit = week.compactMap{Int(String($0))}
            let startHour = (timeA / 4).toString
            let startMinute = ((timeA % 4) * 15).toString
            let endHour = (timeB / 4).toString
            let endMinute = ((timeB % 4) * 15).toString
            return .weekly(bit, startHour + ":" + startMinute, endHour + ":" + endMinute)
        case "S":
            guard let startTime = data.Attributes?.Rule?.first?.Conditions?.ValidTimeRange?.StartTimeStamp else { return .error }
    
            guard let endTime = data.Attributes?.Rule?.first?.Conditions?.ValidTimeRange?.EndTimeStamp else { return .error }
    
            print("start time \(startTime)")
            print("end time \(endTime)")
            return .validTime(Date(timeIntervalSince1970: Double(startTime)), Date(timeIntervalSince1970: Double(endTime)))
        default:
            return .error
        }
    }
    
}
