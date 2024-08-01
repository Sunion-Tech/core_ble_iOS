//
//  timezoneResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/8/1.
//

import Foundation

public class timeZoneResponseModel {
    private var response:[UInt8]


    public var Offset: Int {
        self.getoffSet()
    }
    public var data: String? {
        self.getData()
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
    
    private func getData() -> String? {
        guard self.response[safe: 4] != nil else { return nil }
        
        let data = Array(self.response[4...self.response.count - 1])
        
        return String(data: Data(data), encoding: .utf8)
        
    }


}
