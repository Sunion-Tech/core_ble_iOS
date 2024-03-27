//
//  DeviceSetupResultModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//

import Foundation
public class DeviceSetupResultModel {
    public var D4: DeviceSetupResultModelD4?
    public var A0: DeviceSetupResultModelA0?
    public var N80: DeviceSetupResultModelN80?
    
    // 提供一个public的初始化器
     public init(D4: DeviceSetupResultModelD4? = nil, A0: DeviceSetupResultModelA0? = nil, N80: DeviceSetupResultModelN80? = nil) {
         self.D4 = D4
         self.A0 = A0
         self.N80 = N80
     }
}
