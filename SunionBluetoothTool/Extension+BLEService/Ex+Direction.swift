//
//  Ex+Direction.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {

    
    func V3checkDoorDirection() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command =  CommandService.shared.createAction(with: .CC, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
