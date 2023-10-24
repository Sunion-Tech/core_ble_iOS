//
//  OTAStatusRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/10/11.
//


import Foundation

public enum otaTarget: String {
    case wireless
    case mcu
}

public enum otaState: String {
    case start
    case finish
    case cancel
}

public class OTAStatusRequestModel {



    public var target: otaTarget?
    public var state: otaState?
    public var fileSize: Int?
    public var IV: String?
    public var Signature: String?

    var command:[UInt8] {
        self.getCommand()
    }

    public init(target:otaTarget, state:otaState, fileSize: Int?, IV: String?, Signature: String?) {
        self.target = target
        self.state = state
        self.fileSize = fileSize
        self.IV = IV
        self.Signature = Signature
    }

    private func getCommand()-> [UInt8] {
    
        
        var byteArray:[UInt8] = []
        let target: UInt8 = self.target == .wireless ? 0x01 : 0x00
        let state: UInt8 = self.state == .cancel ? 0x00 : self.state == .finish ? 0x01 : 0x02
        byteArray.append(target)
        byteArray.append(state)
        
    
        // file size
        if let fileSize = fileSize,
           self.state == .start || self.state == .finish {
            let size = Int32(fileSize)
            
        
            
            withUnsafeBytes(of: size) { bytes in
                
                for byte in bytes {
                    let stringHex = String(format: "%02x", byte)
                    let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
                    
                    byteArray.append(uint8)
                }
            }
        }
        
      
        
        if let IV = IV,
            let data = hexStringToUInt8Array(hexString: IV),
           self.state == .finish {
            data.forEach({ el in
                byteArray.append(el)
            })
        }
 
        
        if let Signature = Signature,
            let data = hexStringToUInt8Array(hexString: Signature),
           self.state == .finish {
            data.forEach({ el in
                byteArray.append(el)
            })
        }
        
 
        return byteArray
    }
    
    
    func hexStringToUInt8Array(hexString: String) -> [UInt8]? {
        let cleanHexString = hexString.replacingOccurrences(of: " ", with: "") // 移除可能的空格
        var hex = cleanHexString
        if hex.count % 2 != 0 {
            hex = "0" + hex // 如果字串的長度是奇數，添加一個 0
        }
        
        var byteArray = [UInt8]()
        
        var startIndex = hex.startIndex
        while startIndex < hex.endIndex {
            let endIndex = hex.index(startIndex, offsetBy: 2)
            if let byte = UInt8(hex[startIndex..<endIndex], radix: 16) {
                byteArray.append(byte)
            } else {
                return nil // 當解析失敗時返回 nil
            }
            startIndex = endIndex
        }
        
        return byteArray
    }

}
