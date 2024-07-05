//
//  DeviceSetupResultModelA0.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class DeviceSetupResultModelA0 {
    
    private var response:[UInt8]
    
    init(_ response:[UInt8]) {
        self.response = response
  
    }
    
    public var latitude: Double? {
        self.getLatitude()
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
    
    private func getLatitude() -> Double? {
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
        print("latitude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("latitude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("latitude intvalue \(intValue), value is \(doubleValue)")
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
        print("getSound")
        print(index5)
        print("getSound")
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
            print("==percentage==")
            print(index5)
            print("========")
            return .value(Int(index5))
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
