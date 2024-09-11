//
//  EndpointResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/9/11.
//

import Foundation


public class EndpointResponseModel {
    private var response:[UInt8]


    public var type: EndpointTargetEnum {
        self.gettype()
    }
    public var data: String? {
        self.getData()
    }
    
    init(_ response:[UInt8]) {
        self.response = response
    }

    private func gettype()-> EndpointTargetEnum {
        guard let index = response[safe: 0] else { return .error }
        switch index {
        case 0x00:
            return .api
        case 0x01:
            return .path
        case 0x02:
            return .mqtt
        case 0x03:
            return .hash
        default:
            return .error
            
        }
    }
    
    private func getData() -> String? {
        guard self.response[safe: 1] != nil else { return nil }
        
        let data = Array(self.response[1...self.response.count - 1])
        
        
        if let stringValue = String(data: Data(data), encoding: .utf8) {
            return stringValue
        } else {
            return data.toHexString()
        }

    }


}
