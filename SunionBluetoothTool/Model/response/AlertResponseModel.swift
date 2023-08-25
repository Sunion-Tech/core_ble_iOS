//
//  AlertResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/3/13.
//

import Foundation


public class AlertResponseModel {
    private var response:[UInt8]


    public var type: CommandService.alertType? {
        self.getType()
    }
    
    init(_ response:[UInt8]) {
        self.response = response
    }

    private func getType()-> CommandService.alertType? {
        guard let index0 = self.response[safe: 0] else { return nil }
        switch index0 {
        case 0x00:
            return .errorAccess
        case 0x01:
            return .correctButErrortime
        case 0x02:
            return .correctButVacationMode
        case 0x03:
            return .activelyPressClearKey
        case 0x14:
            return .moreError
        case 0x28:
            return .broken
        default:
            return nil
        }
      
    }


}
