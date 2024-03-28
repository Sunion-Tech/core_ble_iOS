//
//  AccessArrayModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/7.
//

import Foundation

public class AccessArrayResponseModel {
    
    public var type: AccessTypeOption {
        self.getAccessModel()
    }
    public var finish: Bool? {
        self.getFinish()
    }
    public var hasDataAIndex: [Int] = []
    
    private var datalen: Int? {
        self.getDatalen()
    }
    
    
    
    private var response: [UInt8]
    
    init(data: [UInt8]) {
        self.response = data
        
        
        if data.count - 1 >= 2 {
            
            let stringData = Array(data[3...datalen!])
            
            // 遍历Data中的每个字节
            for (byteIndex, byte) in stringData.enumerated() {
                // 遍历字节的每一位
                for bitIndex in 0..<8 {
                    // 检查特定位是否被设置（即是否为1）
                    if (byte & (1 << bitIndex)) != 0 {
                        // 计算并记录全局位置
                        let position = byteIndex * 8 + bitIndex
                        hasDataAIndex.append(position)
                    }
                }
            }
            
        }
        
    }
    
    private func getDatalen() -> Int {
        guard let index4 = response[safe: 0] else { return 0 }
        return index4.toInt
    }
    
    private  func getAccessModel()  -> AccessTypeOption {
        guard let index4 = response[safe: 1] else { return .error }
        switch index4 {
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
    
    private func getFinish() -> Bool? {
        guard let index4 = response[safe: 2] else { return nil }
        switch index4 {
        case 0x00:
            return false
        case 0x01:
            return true
        default:
            return nil
            
        }
    }
    
    
    
}
