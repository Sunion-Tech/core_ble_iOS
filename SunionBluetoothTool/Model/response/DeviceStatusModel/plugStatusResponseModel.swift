//
//  plugStatusResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/11/13.
//

import Foundation


public class plugStatusResponseModel {
    private var response:[UInt8]
    
    
    public var mainVersion: Int? {
        self.getMainVersion()
    }
    
    public var subVersion: Int? {
        self.getsubVersion()
    }
    
    
    public var isWifiSetting: Bool {
        self.isWifiSet()
    }
    
    public var isWifiConnecting: Bool {
        self.isWifiConnect()
    }
    
    public var isOn: Bool {
        self.isPlugOn()
    }


    init(_ response:[UInt8]) {
        self.response = response
    }
    
    private func getMainVersion()  -> Int? {
        guard let index0 = self.response[safe: 0] else { return nil }
        return index0.toInt
    }
    
    private func getsubVersion()  -> Int? {
        guard let index0 = self.response[safe: 1] else { return nil }
        return index0.toInt
    }
    


    private func isWifiSet()-> Bool {
        guard let index0 = self.response[safe: 2] else { return false }
        return index0 == 0x01
    }
    
    private func isWifiConnect() -> Bool {
        guard let index0 = self.response[safe: 3] else { return false }
        return index0 == 0x01
    }

    private func isPlugOn() -> Bool {
        guard let index0 = self.response[safe: 4] else { return false }
        return index0 == 0x01
    }


}
