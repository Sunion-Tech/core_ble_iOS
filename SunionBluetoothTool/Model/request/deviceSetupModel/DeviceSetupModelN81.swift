//
//  DeviceSetupModelN80.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class DeviceSetupModelN81 {
    
    public var latitude: Double
    public var longitude: Double
    public var guidingCode: CodeStatus
    public var virtualCode: CodeStatus
    public var twoFA: CodeStatus
    public var vacationModeOn: CodeStatus
    public var autoLockOn: CodeStatus
    public var autoLockTime: Int
    public var soundOn: CodeStatus
    public var fastMode: CodeStatus
    public var voiceValue: VoiceValue
    public var direction: LockDirectionOption
    public var sabbathMode: CodeStatus
    public var language: LanguageStatus
 
   

    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(latitude: Double, longitude: Double, guidingCode: CodeStatus, virtualCode: CodeStatus, twoFA: CodeStatus, vacationModeOn: CodeStatus, autoLockOn: CodeStatus, autoLockTime: Int, soundOn: CodeStatus, fastMode: CodeStatus, voiceValue: VoiceValue, direction: LockDirectionOption, sabbathMode: CodeStatus, language: LanguageStatus) {
        self.latitude = latitude
        self.longitude = longitude
        self.guidingCode = guidingCode
        self.virtualCode = virtualCode
        self.twoFA = twoFA
        self.vacationModeOn = vacationModeOn
        self.autoLockOn = autoLockOn
        self.autoLockTime = autoLockTime
        self.soundOn = soundOn
        self.fastMode = fastMode
        self.voiceValue = voiceValue
        self.direction = direction
        self.sabbathMode = sabbathMode
        self.language = language
       
    }


    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
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
     //   let direction: UInt8 =  setupModel.direction == .unknown ? 0xA2 : setupModel.direction == .ignore ? 0xA3 : 0xFF
        var direction: UInt8 = 0xFF
        switch self.direction {
        case .right:
            direction = 0xA0
        case .left:
            direction = 0xA1
        case .unknown:
            direction = 0xA2
        case .ignore:
            direction = 0xA3
        default:
            break
            
        }
        
        byteArray.append(direction)
        let guidingCode: UInt8 = guidingCode == .open ? 0x01 : guidingCode == .close ? 0x00 : 0xFF
        byteArray.append(guidingCode)
        let virtualCode: UInt8 = virtualCode == .open ? 0x01 : virtualCode == .close ? 0x00 : 0xFF
        byteArray.append(virtualCode)
        let twoFA: UInt8 = twoFA == .open ? 0x01 : twoFA == .close ? 0x00 : 0xFF
        byteArray.append(twoFA)
        let vacationModeOn: UInt8 = vacationModeOn == .open ? 0x01 : vacationModeOn == .close ? 0x00 : 0xFF
        byteArray.append(vacationModeOn)
        let autoLockOn: UInt8 = autoLockOn == .open ? 0x01 : autoLockOn == .close ? 0x00 : 0xFF
        byteArray.append(autoLockOn)
    
        
        
        let time = Int32(autoLockTime)
   
        withUnsafeBytes(of: time) { bytes in
       
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
              
                byteArray.append(uint8)
            }
        }
        // time has 4 byte command just need 2 byte
        // remove last two byte
        byteArray.removeLast(2)
        
        let soundOn: UInt8 = soundOn == .open ? 0x01 : soundOn == .close ? 0x00 : 0xFF
        byteArray.append(soundOn)
        
        var voice: [UInt8] = [0xFF, 0xFF]
        switch self.voiceValue {
        case .close:
            voice = [0x01, 0x00]
        case .open:
            voice = [0x01, 0x64]
        case .loudly:
            voice = [0x02, 0x64]
        case .whisper:
            voice = [0x02, 0x32]
        case .value(let value):
            var element: UInt8 = 0x00
            let hexString = String(value, radix: 16)
            element =  UInt8(hexString) ?? 0x00

            print("progress Value: \(value)")
            print("progress uint8: \(element)")
            voice = [0x03, UInt8(value)]
            
        default:
            voice = [0xFF, 0xFF]
        }
        byteArray = byteArray + voice
        
        let fastMode: UInt8 = fastMode == .open ? 0x01 : fastMode == .close ? 0x00 : 0xFF
        byteArray.append(fastMode)
        
        let sabbath: UInt8 = sabbathMode == .open ? 0x01 : sabbathMode == .close ? 0x00 : 0xFF
        byteArray.append(sabbath)
        
        let lan: UInt8 = language == .en ? 0x00 : 0xFF
        byteArray.append(lan)

        return byteArray
    }
    
    func languagesToHexString(languages: [LanguageStatus]) -> UInt8 {
        var byte: UInt8 = 0
        for language in languages {
            switch language {
            case .en:
                byte |= 1 << 0  // Set bit 0
            default:
                break
            }
        }
    
        return byte
    }


}
