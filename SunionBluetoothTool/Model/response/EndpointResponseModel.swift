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
    public var data: [UInt8]? {
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
            return .mqtt
        default:
            return .error
            
        }
    }
    
    private func getData() -> [UInt8]? {
        guard let data = self.response[safe: 1] else { return nil }
        
        let dataValue = Array(self.response[1...self.response.count - 1])
        
        return dataValue
        
    }


}
