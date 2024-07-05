//
//  UseCase.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class useCase  {
    
    weak var tool: SunionBluetoothTool?
    
    init(tool: SunionBluetoothTool) {
        self.tool = tool
    }

    public lazy var deviceStatus: DeviceStatus = {
        return DeviceStatus(tool: self)
    }()
    
    public lazy var time: Time = {
        return Time(tool: self)
    }()
    
    public lazy var adminCode: AdminCode = {
        return AdminCode(tool: self)
    }()
    
    public lazy var name: Name = {
        return Name(tool: self)
    }()
    
    public lazy var direction: Direction = {
        return Direction(tool: self)
    }()

    public lazy var config: Config = {
        return Config(tool: self)
    }()
    
    public lazy var utility: Utility = {
        return Utility(tool: self)
    }()
    
    public lazy var bleUser: BleUser = {
        return BleUser(tool: self)
    }()
    
    public lazy var log: Log = {
        return Log(tool: self)
    }()
    
    public lazy var wifi: Wifi = {
        return Wifi(tool: self)
    }()
    
    public lazy var plug: Plug = {
        return Plug(tool: self)
    }()
    
    public lazy var ota: OTA = {
        return OTA(tool: self)
    }()
    
    public lazy var user: User = {
        return User(tool: self)
    }()
    
    public lazy var credential: Credential = {
        return Credential(tool: self)
    }()
    
}
