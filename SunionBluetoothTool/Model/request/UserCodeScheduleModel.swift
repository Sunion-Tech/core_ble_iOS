//
//  PinCodeScheduleModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation

public class PinCodeScheduleModel {

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

    public var availableOption:AvailableOption

    public init(availableOption:AvailableOption) {
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


