//
//  resCredentailSupportUsersModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/25.
//


import Foundation


public class resUserSupportedCountModel {
    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var matter: Int {
        self.getMatter()
    }
    
    public var code: Int {
        self.getCode()
    }
    
    public var card: Int {
        self.getCard()
    }
    public var fp: Int {
        self.getfp()
    }
    public var face: Int {
        self.getface()
    }
    

    private func getMatter() -> Int {
        guard let index1 = self.response[safe: 0] else { return 0 }
        guard let index2 = self.response[safe: 1] else { return 0 }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? 0 : Int(intValue)
    }
    
    private func getCode() -> Int {
        guard let index1 = self.response[safe: 2] else { return 0 }
        guard let index2 = self.response[safe: 3] else { return 0 }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? 0 : Int(intValue)
    }
    
    private func getCard() -> Int {
        guard let index1 = self.response[safe: 4] else { return 0 }
        guard let index2 = self.response[safe: 5] else { return 0 }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? 0 : Int(intValue)
    }
    
    private func getfp() -> Int {
        guard let index1 = self.response[safe: 6] else { return 0 }
        guard let index2 = self.response[safe: 7] else { return 0 }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? 0 : Int(intValue)
    }
    
    private func getface() -> Int {
        guard let index1 = self.response[safe: 8] else { return 0 }
        guard let index2 = self.response[safe: 9] else { return 0 }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? 0 : Int(intValue)
    }
    
}
