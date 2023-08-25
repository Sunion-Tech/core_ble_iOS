//
//  SupportLockTypes.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/7.
//

import Foundation


public class SupportDeviceTypesResponseModel {
    private var response: [UInt8]

    public var AccessCode: Int? {
        self.getAccessCode()
    }
    
    public var AccessCard: Int? {
        self.getAccessCard()
    }
    
    public var Fingerprint: Int? {
        self.getFingerprint()
    }
    
    public var Face: Int? {
        self.getFace()
    }
    
    


    init(response:[UInt8]) {
        self.response = response
    }



    private func getAccessCode()-> Int? {
        guard let index5 = response[safe: 0] else { return nil }
        guard let index6 = response[safe: 1] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getAccessCard()-> Int? {
        guard let index5 = response[safe: 2] else { return nil }
        guard let index6 = response[safe: 3] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getFingerprint()-> Int? {
        guard let index5 = response[safe: 4] else { return nil }
        guard let index6 = response[safe: 5] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getFace()-> Int? {
        guard let index5 = response[safe: 6] else { return nil }
        guard let index6 = response[safe: 7] else { return nil }
        let data = Data([index5, index6, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }


}
