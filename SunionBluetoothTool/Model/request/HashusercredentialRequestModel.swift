//
//  HashusercredentialRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class HashusercredentialRequestModel {
    
    public enum HashTargetEnum: UInt8 {
        case user = 0x01
        case credential = 0x00
        case error = 0xFF
        
    }
    
    
    
    public var target: HashTargetEnum
    
    
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(target: HashTargetEnum) {
        self.target = target
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.target.rawValue)
        
        return byteArray
    }
    
}
