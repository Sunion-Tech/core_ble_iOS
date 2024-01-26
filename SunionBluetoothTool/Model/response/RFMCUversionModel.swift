//
//  versionModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/26.
//

import Foundation
public class RFMCUversionModel {
    

    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var type: RFMCURequestModel.versionType? {
        self.getRFMCUType()
    }
    
    public var version: String? {
        self.getVersion()
    }
    
    private func getRFMCUType()-> RFMCURequestModel.versionType? {
        guard let index1 = response[safe: 0] else { return nil }
        switch index1 {
        case 0x01:
            return .RF
        case 0x00:
            return .MCU
        default:
            return nil
        }
    }
    
    private func getVersion() -> String? {
        guard let firstByte = response[safe: 1],
                let secondByte = response[safe: 2],
            firstByte != 0xFF, secondByte != 0xFF else {
              return nil
          }
          
          let data = Data([firstByte, secondByte])
          return String(data: data, encoding: .utf8)
    }

}
