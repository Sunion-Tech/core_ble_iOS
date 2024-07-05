//
//  DeviceStatusModelD6.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/2.
//

import Foundation

public class DeviceStatusModelD6 {


    private var response:[UInt8]
    
    public var lockDirection: LockDirectionOption {
        return self.getDirection()
    }
    public var soundOn:Bool {
        return self.getSound()
    }
    public var vacationModeOn:Bool {
        return self.getVacationMode()
    }
    public var autoLockOn:Bool {
        return self.getAutoLock()
    }
    public var autoLockTime:Int? {
        return self.getAutoLockTime()
    }
    public var guidingCode: Bool {
        return self.getguidingCode()
    }
    public var isLocked:LockOption {
        return self.getIsLocked()
    }
    public var battery:Int? {
        return self.getBattery()
    }
    public var batteryWarning:BatteryWarningOption {
        return self.getBatteryStatus()
    }
    public var timestamp:Double? {
        self.getTimestamp()
    }

    init(_ response:[UInt8]) {
        self.response = response
    }

    private func getDirection()-> LockDirectionOption {
        guard let index0 = response[safe: 0] else { return .error }
        switch index0 {
        case 0xA0:
            return .right
        case 0xA1:
            return .left
        case 0xA2:
            return .unknown
        default:
            return .error
        }
    }

    private func getSound()-> Bool {
        guard let index1 = response[safe: 1] else { return false }
        return index1 == 0x01
    }

    private func getVacationMode()-> Bool {
        guard let index2 = response[safe: 2] else { return false }
        return index2 == 0x01
    }

    private func getAutoLock()-> Bool {
        guard let index3 = response[safe: 3] else { return false }
        return index3 == 0x01
    }

    private func getAutoLockTime()-> Int? {
        guard let index4 = response[safe: 4] else { return nil }
        let value:Int = {
            switch Int(index4) {
            case 1...90:
                return Int(index4)
            default:
                return 1
            }

        }()
        return value
    }
    private func getguidingCode() -> Bool {
        guard let index5 = response[safe: 5] else { return false }
        return index5 == 0x01
    }
    


    private func getIsLocked()-> LockOption {
        guard let index6 = response[safe: 6] else { return .error }
        switch index6 {
        case 0x00:
            return .unlocked
        case 0x01:
            return .locked
        default:
            return .error
        }
    }

    private func getBattery()-> Int? {
        guard let index7 = response[safe: 7] else { return nil }
        return Int(index7)
    }

    private func getBatteryStatus()-> BatteryWarningOption {
        guard let index8 = response[safe: 8] else { return .error }
        switch index8 {
        case 0x00:
            return .normal
        case 0x01:
            return .low
        case 0x02:
            return .emergancy
        default:
            return .error
        }
    }

    private func getTimestamp()-> Double? {
        guard let index9 = response[safe: 9] else { return nil }
        guard let index10 = response[safe: 10] else { return nil }
        guard let index11 = response[safe: 11] else { return nil }
        guard let index12 = response[safe: 12] else { return nil }
        let data = Data([index9, index10, index11, index12])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.pointee })
        return Double(uint32)
    }
}
