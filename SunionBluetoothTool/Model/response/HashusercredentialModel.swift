//
//  HashusercredentialModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation

public class HashusercredentialModel {
    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var target: HashusercredentialRequestModel.HashTargetEnum {
        self.getTarget()
    }
    
    public var data: [UInt8]? {
        self.getData()
    }
    
    private func getTarget()-> HashusercredentialRequestModel.HashTargetEnum {
        guard let index1 = response[safe: 0] else { return .error }
        switch index1 {
        case 0x01:
            return .user
        case 0x00:
            return .credential
        default:
            return .error
        }
    }
    
    private func getData() -> [UInt8]? {
        guard self.response[safe: 1] != nil else { return nil }
        
        let data = Array(self.response[1...self.response.count - 1])
        
        return data
        
    }
}
