//
//  SearchAccess.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/7.
//

import Foundation
public class SearchAccessRequestModel {


    public enum AccessTypeMode: UInt8 {
        case AccessCode = 0x00
        case AccessCard = 0x01
        case Fingerprint = 0x02
        case Face = 0x03
    }

    public var accessType: AccessTypeMode

    public var index:Int
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(type: AccessTypeMode, index: Int) {
        self.accessType = type
        self.index = index
        
    }

    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = [accessType.rawValue]
        let time = Int32(index)
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

     
        return byteArray
    }
}
