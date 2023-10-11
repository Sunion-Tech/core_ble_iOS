//
//  OTADataRequsetModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/10/11.
//

import Foundation

public class OTADataRequestModel {



    public var Offset: Int
    public var data: [UInt8]
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(offset: Int, data: [UInt8]) {
        self.Offset = offset
        self.data = data
    }

    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        let time = Int32(Offset)
        withUnsafeBytes(of: time) { bytes in
       
            for byte in bytes {
                let stringHex = String(format: "%02x", byte)
                let uint8 = UInt8(stringHex, radix: 16) ?? 0x00
              
                byteArray.append(uint8)
            }
        }
        
        data.forEach { el in
            byteArray.append(el)
        }
        return byteArray
    }
}
