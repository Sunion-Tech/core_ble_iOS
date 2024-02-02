//
//  N81ResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/2.
//

import Foundation


public class N81ResponseModel {
    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var isSuccess: Bool {
        self.getisSuccess()
    }
    
    public var version: String? {
        self.getversion()
    }
    
    private func getisSuccess()-> Bool {
        guard let index1 = response[safe: 0] else { return false }
        return index1 == 0x00 ? false : true
    }
    
    private func getversion() -> String? {
        guard self.response[safe: 1] != nil else { return nil }
        
        let data = Array(self.response[1...self.response.count - 1])
        
        return String(data: Data(data), encoding: .utf8)
        
    }
}
