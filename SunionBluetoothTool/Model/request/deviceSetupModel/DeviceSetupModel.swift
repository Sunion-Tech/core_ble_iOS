//
//  LockSetupModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//

import Foundation
import CryptoSwift
import SwiftUI

public class DeviceSetupModel {
    public var D5: DeviceSetupModelD5?
    public var A1: DeviceSetupModelA1?
    
    public init(D5: DeviceSetupModelD5? = nil, A1: DeviceSetupModelA1? = nil) {
        self.D5 = D5
        self.A1 = A1
    }
}





