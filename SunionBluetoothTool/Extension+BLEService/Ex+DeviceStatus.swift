//
//  Ex+DeviceStatus.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3deviceStatus() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .N82, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3lockorUnLock(mode: CommandService.DeviceMode) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        let command =  CommandService.shared.createAction(with: .N83(.lockstate, mode, nil), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

}
