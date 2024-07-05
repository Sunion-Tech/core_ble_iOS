//
//  DeviceSetupResultModelD4.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation


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

    public var latitude:Double? {
        self.getLatitude()
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

    private func getLatitude() -> Double? {
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
        print("latitude digitValue \(digitValue)")
        let withLeadingZero = String(format: "%09D", digitValue)
        print("latitude withLeadingZero \(withLeadingZero)")
        let doubleValue = (Double(withLeadingZero) ?? 0.0) / 1000000000
        print("latitude intvalue \(intValue), value is \(doubleValue)")
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
