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

    
}
