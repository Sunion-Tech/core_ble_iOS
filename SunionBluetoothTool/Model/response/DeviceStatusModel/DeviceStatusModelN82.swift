//
//  DeviceStatusModelN82.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/2.
//

import Foundation


public class DeviceStatusModelN82 {
    
    private var response:[UInt8]
    
    init(_ response:[UInt8]) {
        self.response = response
  
    }
    
    public var mainVersion: String? {
        self.getmainVersion()
    }
    
    public var subVersion: String? {
        self.getsubVersion()
    }
    

    public var lockDirection: LockDirectionOption {
        return self.getDirection()
    }
    
    public var vacationModeOn: CodeStatus {
        return self.getVacationMode()
    }
    
    public var deadBolt: DeadboltStatus {
        return self.getDeadbolt()
    }
    
    public var doorState: DoorStateStatus {
        return self.getDoorState()
    }
    
    public var lockState: LockStateSatus {
        return self.getLockState()
    }
    
    public var securityBolt: SecruityboltStatus {
        return self.getSecuritybolt()
    }
    
    public var battery:Int? {
        return self.getBattery()
    }
    public var batteryWarning:BatteryWarningOption {
        return self.getBatteryStatus()
    }
    
    private func getmainVersion() -> String? {
        guard let index0 = response[safe: 0] else { return nil }
        
        let data = Array(self.response[0...0])
        
        return String(data: Data(data), encoding: .utf8)
    }
    
    private func getsubVersion() -> String? {
        guard let index0 = response[safe: 1] else { return nil }
        
        let data = Array(self.response[1...1])
        
        return String(data: Data(data), encoding: .utf8)
    }
    
    private func getDirection()-> LockDirectionOption {
        guard let index0 = response[safe: 2] else { return .error }
        switch index0 {
        case 0xA0:
            return .right
        case 0xA1:
            return .left
        case 0xA2:
            return .unknown
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getVacationMode() -> CodeStatus {
        guard let index1 = response[safe: 3] else { return .error }
        switch index1 {
        case 0x00:
            return .close
        case 0x01:
            return .open
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getDeadbolt() -> DeadboltStatus {
        guard let index1 = response[safe: 4] else { return .error }
        switch index1 {
        case 0x00:
            return .retract
        case 0x01:
            return .protrude
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getDoorState() -> DoorStateStatus {
        guard let index1 = response[safe: 5] else { return .error }
        switch index1 {
        case 0x00:
            return .unclose
        case 0x01:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getLockState() -> LockStateSatus {
        guard let index1 = response[safe: 6] else { return .error }
        switch index1 {
        case 0x00:
            return .unlockedLinked
        case 0x01:
            return .lockedUnlinked
        case 0xFF:
            return .unknow
        default:
            return .error
        }
    }
    
    private func getSecuritybolt() -> SecruityboltStatus {
        guard let index1 = response[safe: 7] else { return .error }
        switch index1 {
        case 0x00:
            return .unprotrude
        case 0x01:
            return .protrude
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getBattery()-> Int? {
        guard let index7 = response[safe: 8] else { return nil }
        return Int(index7)
    }

    private func getBatteryStatus()-> BatteryWarningOption {
        guard let index8 = response[safe: 9] else { return .error }
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
}
