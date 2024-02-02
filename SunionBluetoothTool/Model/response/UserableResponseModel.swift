//
//  UserableResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/2.
//

import Foundation


public class UserableResponseModel {
    
    private var response:[UInt8]
    
   
    init(response:[UInt8]) {
        self.response = response
    }
    
    public var isMatter: Bool {
        self.getisMatter()
    }
    
    public var weekdayCount: Int? {
        self.getweekdayCount()
    }
    
    public var yeardayCount: Int? {
        self.getyeardayCount()
    }
    
    public var codeCount: Int? {
        self.getcodeCount()
    }
    
    public var cardCount: Int? {
        self.getcardCount()
    }
    
    public var fpCount: Int? {
        self.getfpCount()
    }
    
    public var faceCount: Int? {
        self.getfaceCount()
    }
    
    private func getisMatter()-> Bool {
        guard let index1 = response[safe: 0] else { return false }
        return index1 == 0x00 ? false : true
    }
    
    private func getweekdayCount() -> Int? {
        guard let index1 = response[safe: 1] else { return nil }
        return index1.toInt
    }
    
    private func getyeardayCount() -> Int? {
        guard let index1 = response[safe: 2] else { return nil }
        return index1.toInt
    }
    
    private func getcodeCount() -> Int? {
        guard let index1 = response[safe: 3] else { return nil }
        return index1.toInt
    }
    
    private func getcardCount() -> Int? {
        guard let index1 = response[safe: 4] else { return nil }
        return index1.toInt
    }
    
    private func getfpCount() -> Int? {
        guard let index1 = response[safe: 5] else { return nil }
        return index1.toInt
    }
    
    private func getfaceCount() -> Int? {
        guard let index1 = response[safe: 6] else { return nil }
        return index1.toInt
    }

}
