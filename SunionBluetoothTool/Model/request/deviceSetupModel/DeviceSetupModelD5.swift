//
//  DeviceSetupModelD5.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class DeviceSetupModelD5 {
    public var resetBolt:Bool
    public var soundOn:Bool
    public var vacationModeOn:Bool
    public var autoLockOn:Bool
    public var autoLockTime:Int
    public var guidingCode:Bool
    public var latitude:Double
    public var longitude:Double
    
    var command:[UInt8] {
        self.getCommand()
    }

    public  init(resetBolt:Bool = false, soundOn:Bool, vacationModeOn:Bool, autoLockOn:Bool, autoLockTime:Int,guidingCode: Bool, latitude:Double, longitude:Double) {
        self.resetBolt = resetBolt
        self.soundOn = soundOn
        self.vacationModeOn = vacationModeOn
        self.autoLockOn = autoLockOn
        self.autoLockTime = autoLockTime
        self.guidingCode = guidingCode
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func getCommand()-> [UInt8] {
        let resetBolt:UInt8 = resetBolt ? 0xA2 : 0xA3
        let soundSetting:UInt8 = soundOn ? 0x01 : 0x00
        let vacationSetting:UInt8 = vacationModeOn ? 0x01 : 0x00
        let autoLockSetting:UInt8 = autoLockOn ? 0x01 : 0x00
        let autoLockTime = UInt8(autoLockTime)
        let leadCode: UInt8 = guidingCode ? 0x01 : 0x00
        var byteArray:[UInt8] = [resetBolt, soundSetting, vacationSetting, autoLockSetting, autoLockTime, leadCode]
        let latitude1 = latitude.toInt32
        let latitude2 = latitude.decimalPartToInt32
        let longitude1 = longitude.toInt32
        let longitude2 = longitude.decimalPartToInt32
        withUnsafeBytes(of: latitude1) { bytes in
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                byteArray.append(uint8)
            }
        }

        withUnsafeBytes(of: latitude2) { bytes in
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                byteArray.append(uint8)
            }
        }

        withUnsafeBytes(of: longitude1) { bytes in
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                byteArray.append(uint8)
            }
        }

        withUnsafeBytes(of: longitude2) { bytes in
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                byteArray.append(uint8)
            }
        }
   
        
        
        
        return byteArray
    }
    
}
