//
//  Ex+AdminCode.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3setAdminCode(Code: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let adminCode = Code.compactMap{Int(String($0))}
        let command = CommandService.shared.createAction(with: .C7(adminCode), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3editAdminCode(oldCode: String, newCode: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let oldDigits = oldCode.compactMap{Int(String($0))}
        let newDigits = newCode.compactMap{Int(String($0))}
        let model = EditAdminCodeModel(oldCode: oldDigits, newCode: newDigits)
        let command = CommandService.shared.createAction(with: .C8(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3hasAdminCode() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3
        let command = CommandService.shared.createAction(with: .EF, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
