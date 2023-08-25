//
//  AccessResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/8.
//

import Foundation


public class AccessResponseModel {
    
    public var type : AccessTypeOption {
        self.getType()
    }
    public var index: Int? {
        self.getIndex()
    }
    public var isSuccess: Bool {
        self.getIsSuccess()
    }
    private var response:[UInt8]
    
    public init(_ response:[UInt8]) {
        self.response = response
    }
    
    private func getType() -> AccessTypeOption {
        guard let index0 = self.response[safe: 0] else { return .error }
        switch index0 {
        case 0x00:
            return .AccessCode
        case 0x01:
            return .AccessCard
        case 0x02:
            return .Fingerprint
        case 0x03:
            return .Face
        default:
            return .error
        }
    }
    
    private func getIndex() -> Int? {
        guard let index1 = self.response[safe: 1] else { return nil }
        guard let index2 = self.response[safe: 2] else { return nil }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        
        // 65535 = [0xFF, 0xFF, 0x00, 0x00] = not support
        return Int(intValue) >= 65535 ? nil : Int(intValue)
    }
    
    private func getIsSuccess()-> Bool {
        guard let index0 = self.response[safe: 3] else { return false }
        return index0 == 0x01
    }
    
    
}
