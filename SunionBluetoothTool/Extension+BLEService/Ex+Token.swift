//
//  Ex+Token.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

extension BluetoothService {
    
    func V3getTokenArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Token(nil)
        let command =  CommandService.shared.createAction(with: .E4, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    

    func V3getToken(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Token(nil)
        let command =  CommandService.shared.createAction(with: .E5(position), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }

    func V3createToken(model: AddTokenModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Token(nil)
        let command =  CommandService.shared.createAction(with: .E6(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3editToken(model: EditTokenModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .v3Token(nil)
        let command =  CommandService.shared.createAction(with: .E7(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
