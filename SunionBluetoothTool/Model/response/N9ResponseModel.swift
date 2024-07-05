//
//  N9ResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/1/30.
//


import Foundation
public class N9ResponseModel {
    

    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var index: Int? {
        self.getIndex()
    }
    
    public var isSuccess: Bool? {
        self.getIsSuccess()
    }
    
    private func getIndex() -> Int? {
        guard let firstByte = response[safe: 0],
                let secondByte = response[safe: 1] else {
              return nil
          }
        
        let data = Data([firstByte, secondByte])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        return Int(intValue)
    }

    
    private func getIsSuccess() -> Bool? {

        guard let isSuccess = response[safe: 2] else { return nil}
          
     
        return isSuccess == 0x01 ? true : false
    }

}
