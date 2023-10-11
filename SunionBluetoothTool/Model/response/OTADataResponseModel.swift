//
//  OTADataResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/10/11.
//

import Foundation



public class OTADataResponseModel {
    private var response:[UInt8]


    public var Offset: Int {
        self.getoffSet()
    }
    public var data: [UInt8]? {
        self.getOTAData()
    }
    
    init(_ response:[UInt8]) {
        self.response = response
    }

    private func getoffSet()-> Int {
        guard let index = response[safe: 0] else { return 0 }
        guard let index1 = response[safe: 1] else { return 0 }
        guard let index2 = response[safe: 2] else { return 0 }
        guard let index3 = response[safe: 3] else { return 0 }
        let data = Data([index, index1, index2, index3])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))
        return Int(intValue)
    }
    
    private func getOTAData() -> [UInt8]? {
        guard self.response[safe: 4] != nil else { return nil }
        
        let data = Array(self.response[5...self.response.count - 1])
        
        return data
        
    }


}
