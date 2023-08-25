//
//  PinCodeModelResult.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import Foundation


public class PinCodeModelResult {

    private var response:[UInt8]

    public var isEnable:Bool {
        self.getIsEnable()
    }
    public var PinCode:[UInt8]? {
        self.getPinCode()
    }

    public  var PinCodeLength: UInt8? {
        self.getPinCodeLength()
    }
    public var name:String? {
        return self.getName()
    }

    public var schedule: PinCodeScheduleResult? {
        guard let PinCodeLength = self.PinCodeLength else { return nil }
        return PinCodeScheduleResult(response: self.response, PinCodeLength: Int(PinCodeLength))
    }
    
    public var index: Int = 0

    init(response:[UInt8]) {
        self.response = response
    }

    private func getIsEnable()-> Bool {
        guard let index0 = self.response[safe: 0] else { return false }
        return index0 == 0x01
    }

    private func getPinCodeLength()-> UInt8? {
        guard let index1 = self.response[safe: 1] else { return nil }
        return index1
    }

    private func getPinCode()-> [UInt8]? {
        guard let PinCodeLength = self.PinCodeLength else { return nil }
        guard PinCodeLength > 0 else { return nil }
        let indexPinCodeLast = 2 + PinCodeLength.toInt - 1
        let PinCode = Array(self.response[2...indexPinCodeLast])
        return PinCode
    }

    private func getName()-> String? {
        guard let PinCodeLength = self.PinCodeLength else { return nil }
        let nameIndex = 14 + PinCodeLength.toInt
        guard nameIndex <= self.response.count - 1 else { return nil }
        let data = self.response[nameIndex...self.response.count - 1]
        return String(data: Data(data), encoding: .utf8)
    }
}
public class PinCodeScheduleResult {

    var response:[UInt8]
    public var PinCodeLength:Int

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

   public var scheduleOption:ScheduleOption {
        self.getScheduleType()
    }

    init(response:[UInt8], PinCodeLength:Int) {
        self.response = response
        self.PinCodeLength = PinCodeLength
    }

    private func getScheduleType()-> ScheduleOption {
        let scheduleIndex = 2 + PinCodeLength
        guard let indexOfSchedule = self.response[safe: scheduleIndex] else { return .error }
        guard let scheduleString = String(data: Data([indexOfSchedule]), encoding: .utf8) else { return .error }
        switch scheduleString.uppercased() {
        case "A":
            return .all
        case "N":
            return .none
        case "O":
            return .once
        case "W":
            guard let week = self.response[safe: 3 + PinCodeLength] else { return .error }
            guard let timeA = self.response[safe: 4 + PinCodeLength] else { return .error }
            guard let timeB = self.response[safe: 5 + PinCodeLength] else { return .error }
            let bits = week.bits.map{Int($0)}
            let startHour = (timeA.toInt / 4).toString
            let startMinute = ((timeA % 4).toInt * 15).toString
            let endHour = (timeB.toInt / 4).toString
            let endMinute = ((timeB % 4).toInt * 15).toString
            return .weekly(bits, startHour + ":" + startMinute, endHour + ":" + endMinute)
        case "S":
            guard let startTime1 = self.response[safe: 6 + PinCodeLength]?.toInt else { return .error }
            guard let startTime2 = self.response[safe: 7 + PinCodeLength]?.toInt else { return .error }
            guard let startTime3 = self.response[safe: 8 + PinCodeLength]?.toInt else { return .error }
            guard let startTime4 = self.response[safe: 9 + PinCodeLength]?.toInt else { return .error }

            let startTimestamp = [startTime4 << 24, startTime3 << 16, startTime2 << 8, startTime1].reduce(0, +)

            guard let endTime1 = self.response[safe: 10 + PinCodeLength]?.toInt else { return .error }
            guard let endTime2 = self.response[safe: 11 + PinCodeLength]?.toInt else { return .error }
            guard let endTime3 = self.response[safe: 12 + PinCodeLength]?.toInt else { return .error }
            guard let endTime4 = self.response[safe: 13 + PinCodeLength]?.toInt else { return .error }

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


