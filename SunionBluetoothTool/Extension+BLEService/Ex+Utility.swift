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
        action = .v3
        let type: RFMCURequestModel = RFMCURequestModel(type: type)
        
        let command =  CommandService.shared.createAction(with: .C2(type), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3factoryReset(adminCode: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let code = adminCode.compactMap{Int(String($0))}
        let command =  CommandService.shared.createAction(with: .CE(code), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3plugFactoryReset() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .CF, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3isMatter() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with:  .N87, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
