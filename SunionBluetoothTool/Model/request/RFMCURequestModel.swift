//
//  RFMCURequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/26.
//

import Foundation

public class RFMCURequestModel {

    public enum versionType: String {
        case RF
        case MCU
    }


    public var type: versionType
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(type: versionType) {
       
        self.type = type
    }

    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = [0xC2, 0x01]
        if type == .MCU {
            byteArray.append(0x00)
        } else {
            byteArray.append(0x01)
        }
        return byteArray
    }
}
