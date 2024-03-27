//
//  Ex+Log.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3getLogCount() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .E0, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    // data
    func V3getLog(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .E1(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
}
