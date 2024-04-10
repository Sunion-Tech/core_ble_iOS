//
//  Ex+Plug.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


extension BluetoothService {
    
    func V3PlugStatus() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .B0, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3PlugtogglePowerState(mode: CommandService.plugMode) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .B1(mode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    
}
