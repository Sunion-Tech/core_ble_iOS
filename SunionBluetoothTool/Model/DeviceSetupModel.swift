//
//  LockSetupModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//

import Foundation
import CryptoSwift
import SwiftUI

public class DeviceSetupModel {
    public var D5: DeviceSetupModelD5?
    public var A1: DeviceSetupModelA1?
    public init() {
        
    }
}

public class DeviceSetupModelD5 {
    public var resetBolt:Bool
    public var soundOn:Bool
    public var vacationModeOn:Bool
    public var autoLockOn:Bool
    public var autoLockTime:Int
    public var guidingCode:Bool
    public var laititude:Double
    public var longitude:Double

    public  init(resetBolt:Bool = false, soundOn:Bool, vacationModeOn:Bool, autoLockOn:Bool, autoLockTime:Int,guidingCode: Bool, laititude:Double, longitude:Double) {
        self.resetBolt = resetBolt
        self.soundOn = soundOn
        self.vacationModeOn = vacationModeOn
        self.autoLockOn = autoLockOn
        self.autoLockTime = autoLockTime
        self.guidingCode = guidingCode
        self.laititude = laititude
        self.longitude = longitude
    }
}

public class DeviceSetupModelA1 {

    public var laititude: Double
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
   

 

    public init(direction: LockDirectionOption,soundOn: CodeStatus, vacationModeOn: CodeStatus, autoLockOn: CodeStatus, autoLockTime:Int, guidingCode:  CodeStatus, virtualCode: CodeStatus, twoFA: CodeStatus, laititude:Double, longitude:Double, fastMode: CodeStatus, voiceValue: VoiceValue) {

        self.laititude = laititude
        self.longitude = longitude
        self.guidingCode = guidingCode
        self.virtualCode = virtualCode
        self.twoFA = twoFA
        self.vacationModeOn = vacationModeOn
        self.autoLockOn = autoLockOn
        self.autoLockTime = autoLockTime
        self.soundOn = soundOn
        self.fastMode = fastMode
        self.voiceValue =  voiceValue
        self.direction = direction
    }
}

public class DeviceSetupResultModel {
    public var D4: DeviceSetupResultModelD4?
    public var A0: DeviceSetupResultModelA0?
}



public class DeviceSetupResultModelD4 {

    private var response:[UInt8]
    public var lockDirection: LockDirectionOption {
        self.getDirection()
    }
    public var soundOn:Bool {
        self.getSound()
    }
    public var vacationModeOn:Bool {
        self.getVacationMode()
    }
    public var autoLockOn:Bool {
        self.getAutoLock()
    }
    public var autoLockTime:Int? {
        self.getAutoLockTime()
    }
    
    public var guidingCode: Bool {
        return self.getguidingCode()
    }

    public var laititude:Double? {
        self.getLaititude()
    }

    public var longitude:Double? {
        self.getLongitude()
    }

    init(_ response:[UInt8]) {
        self.response = response
    }

    private func getDirection() -> LockDirectionOption {
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

    private func getSound() -> Bool {
        guard let index1 = response[safe: 1] else { return false }
        return index1 == 0x01
    }

    private func getVacationMode() -> Bool {
        guard let index2 = response[safe: 2] else { return false }
        return index2 == 0x01
    }

    private func getAutoLock() -> Bool {
        guard let index3 = response[safe: 3] else { return false }
        return index3 == 0x01
    }

    private func getAutoLockTime() -> Int? {
        guard let index4 = response[safe: 4] else { return nil }
        return Int(index4)
    }
    
    private func getguidingCode() -> Bool {
        guard let index5 = response[safe: 5] else { return false }
        return index5 == 0x01
    }

    private func getLaititude() -> Double? {
        guard let index5 = response[safe: 6] else { return nil }
        guard let index6 = response[safe: 7] else { return nil }
        guard let index7 = response[safe: 8] else { return nil }
        guard let index8 = response[safe: 9] else { return nil }
        let data = Data([index5, index6, index7, index8])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        guard let index9 = response[safe: 10] else { return nil }
        guard let index10 = response[safe: 11] else { return nil }
        guard let index11 = response[safe: 12] else { return nil }
        guard let index12 = response[safe: 13] else { return nil }

        let data2 = Data([index9, index10, index11, index12])
        let digit = UInt32(littleEndian: data2.withUnsafeBytes { $0.load(as: UInt32.self) })
        let digitValue = Int32(bitPattern: UInt32(digit))
        print("Laititude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("Laititude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("Laititude intvalue \(intValue), value is \(doubleValue)")
        return Double(intValue) + doubleValue
    }

    private func getLongitude() -> Double? {
        guard let index5 = response[safe: 14] else { return nil }
        guard let index6 = response[safe: 15] else { return nil }
        guard let index7 = response[safe: 16] else { return nil }
        guard let index8 = response[safe: 17] else { return nil }
        let data = Data([index5, index6, index7, index8])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))


        guard let index9 = response[safe: 18] else { return nil }
        guard let index10 = response[safe: 19] else { return nil }
        guard let index11 = response[safe: 20] else { return nil }
        guard let index12 = response[safe: 21] else { return nil }

        let data2 = Data([index9, index10, index11, index12])
        let digit = UInt32(littleEndian: data2.withUnsafeBytes { $0.load(as: UInt32.self) })
        let digitValue = Int32(bitPattern: UInt32(digit))
        print("Logitude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("Logitude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("Logitude intvalue \(intValue), value is \(doubleValue)")
        return Double(intValue) + doubleValue
    }
}

public class DeviceSetupResultModelA0 {
    
    private var response:[UInt8]
    
    init(_ response:[UInt8]) {
        self.response = response
  
    }
    
    public var laititude: Double? {
        self.getLaititude()
    }

    public var longitude: Double? {
        self.getLongitude()
    }
    
    public var direction: LockDirectionOption {
        self.getDirection()
    }
    
    public var guidingCode: CodeStatus {
        self.getguidingCode()
    }
    
    public var virtualCode: CodeStatus {
        self.getvirtualCode()
    }
    
    public var twoFA: CodeStatus {
        self.get2FA()
    }
    
    public var vacationMode: CodeStatus {
        self.getVacationMode()
    }
    
    public var isAutoLock: CodeStatus {
        self.getAutoLock()
    }
    
    public var autoLockTime: Int? {
        self.getAutoLockTime()
    }
    
    public var autoLockMinLimit: Int? {
        self.getAtuoLockMinTimeLimit()
    }
    
    public var autoLockMaxLimit: Int? {
        self.getAtuoLockMaxTimeLimit()
    }
    
    public var sound: CodeStatus {
        self.getSound()
    }
    
    public var voiceType: VoiceType {
        self.getVoidType()
    }
    
    public var voiceValue: VoiceValue {
        self.getVoidValue()
    }
    
    public var fastMode: CodeStatus {
        self.getFastMode()
    }
    
    private func getLaititude() -> Double? {
        guard let index5 = response[safe: 0] else { return nil }
        guard let index6 = response[safe: 1] else { return nil }
        guard let index7 = response[safe: 2] else { return nil }
        guard let index8 = response[safe: 3] else { return nil }
        let data = Data([index5, index6, index7, index8])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        guard let index9 = response[safe: 4] else { return nil }
        guard let index10 = response[safe: 5] else { return nil }
        guard let index11 = response[safe: 6] else { return nil }
        guard let index12 = response[safe: 7] else { return nil }

        let data2 = Data([index9, index10, index11, index12])
        let digit = UInt32(littleEndian: data2.withUnsafeBytes { $0.load(as: UInt32.self) })
        let digitValue = Int32(bitPattern: UInt32(digit))
        print("Laititude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("Laititude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("Laititude intvalue \(intValue), value is \(doubleValue)")
        return Double(intValue) + doubleValue
    }

    private func getLongitude() -> Double? {
        guard let index5 = response[safe: 8] else { return nil }
        guard let index6 = response[safe: 9] else { return nil }
        guard let index7 = response[safe: 10] else { return nil }
        guard let index8 = response[safe: 11] else { return nil }
        let data = Data([index5, index6, index7, index8])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))


        guard let index9 = response[safe: 12] else { return nil }
        guard let index10 = response[safe: 13] else { return nil }
        guard let index11 = response[safe: 14] else { return nil }
        guard let index12 = response[safe: 15] else { return nil }

        let data2 = Data([index9, index10, index11, index12])
        let digit = UInt32(littleEndian: data2.withUnsafeBytes { $0.load(as: UInt32.self) })
        let digitValue = Int32(bitPattern: UInt32(digit))
        print("Logitude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("Logitude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("Logitude intvalue \(intValue), value is \(doubleValue)")
        return Double(intValue) + doubleValue
    }
    
    private func getDirection() -> LockDirectionOption {
        guard let index0 = response[safe: 16] else { return .error }
        switch index0 {
        case 0xA0:
            return .right
        case 0xA1:
            return .left
        case 0xA2:
            return .unknown
        case 0xA3:
            return .ignore
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getguidingCode() -> CodeStatus {
        guard let index5 = response[safe: 17] else { return .error }
        switch index5 {
        case 0x01:
            return .open
        case 0x00:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
     
    }
    
    private func getvirtualCode() -> CodeStatus {
        guard let index5 = response[safe: 18] else { return .error }
        switch index5 {
        case 0x01:
            return .open
        case 0x00:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
     
    }
    
    private func get2FA() -> CodeStatus {
        guard let index5 = response[safe: 19] else { return .error }
        switch index5 {
        case 0x01:
            return .open
        case 0x00:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
     
    }
    
    private func getVacationMode() -> CodeStatus {
        guard let index5 = response[safe: 20] else { return .error }
        switch index5 {
        case 0x01:
            return .open
        case 0x00:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }

    private func getAutoLock() -> CodeStatus {
        guard let index5 = response[safe: 21] else { return .error }
        switch index5 {
        case 0x01:
            return .open
        case 0x00:
            return .close
        case 0xFF:
            return .unsupport
        default:
            return .error
        }
    }
    
    private func getAutoLockTime() -> Int? {
        guard let index5 = response[safe: 22] else { return nil }
        guard let index6 = response[safe: 23] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getAtuoLockMinTimeLimit()-> Int? {
        guard let index5 = response[safe: 24] else { return nil }
        guard let index6 = response[safe: 25] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getAtuoLockMaxTimeLimit()-> Int? {
        guard let index5 = response[safe: 26] else { return nil }
        guard let index6 = response[safe: 27] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getSound() -> CodeStatus {
        guard let index5 = response[safe: 28] else { return .error }
        switch index5 {
        case 0x01:
            return .open

        case 0x00:
            return .close
            
        case 0xFF:
            return .unsupport

        default:
            return .error
        }
        
    }
    

    
    private func getVoidType() -> VoiceType {
        guard let index5 = response[safe: 29] else { return .error }
        switch index5 {
        case 0x01:
            return .onoff
        case 0x02:
            return .level
        case 0x03:
            return .percentage
        default:
            return .error
        }
        
    }
    
    private func getVoidValue() -> VoiceValue {
        
    
        
        guard let index5 = response[safe: 30] else { return .error }
        let type = getVoidType()
        
        switch type {
        case .onoff:
            // 100:開啟, 0:關閉
            switch index5 {
            case 0x00:
                return .close
            default:
                return .open
            }
        case .level:
            // 100:大聲, 50:小聲, 0:關閉
            switch index5 {
            case 0x00:
                return .close
            case 0x64:
                return .loudly
            default:
                return .whisper
            }
        case .percentage:
            // 100 ~ 0
            var val = 0
          
            let hexString = "\(index5)" // 16 進制的 "10"
            if let intValue = Int(hexString, radix: 16) {
                print(intValue) // Prints "16"，這是 10 進制的表示方式
                val = intValue
            } else {
                print("Failed to convert string to Int")
                val = 0
            }
            print("percentage: \(val)")
            return .value(val)
        default:
            return .error
        }
        
    }
    
    private func getFastMode() -> CodeStatus {
        guard let index5 = response[safe: 31] else { return .error }
        switch index5 {
        case 0x01:
            return .open

        case 0x00:
            return .close
            
        case 0xFF:
            return .unsupport

        default:
            return .error
        }
        
    }
    
    
    
}


