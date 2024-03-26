//
//  Ex+Utility.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    public func V3getVersion(type: RFMCURequestModel.versionType) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3utility(nil)
        let type: RFMCURequestModel = RFMCURequestModel(type: type)
        
        let command =  CommandService.shared.createAction(with: .C2(type), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3factoryReset(adminCode: [Int]) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3utility(nil)
        let command =  CommandService.shared.createAction(with: .CE(adminCode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3plugFactoryReset() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3utility(nil)
        let command =  CommandService.shared.createAction(with: .CF, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3isMatter() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .isMatter(nil)
        
        let command =  CommandService.shared.createAction(with:  .N87, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
