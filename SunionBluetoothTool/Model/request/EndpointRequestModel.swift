//
//  EndpointRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/9/11.
//

import Foundation

public enum EndpointTargetEnum: UInt8 {
    case api = 0x00
    case path = 0x01
    case mqtt = 0x02
    case hash = 0x03
    case error = 0x04
    
}


public class EndpointRequestModel {
    


    
    public var type: EndpointTargetEnum
    public var data: [UInt8]
    
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(type: EndpointTargetEnum, data: [UInt8]) {
        self.type = type
        self.data = data
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.type.rawValue)
        
        data.forEach { el in
            byteArray.append(el)
        }
        
        return byteArray
    }
    
}
