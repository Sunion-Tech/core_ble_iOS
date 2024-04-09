//
//  Ex+Credential.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/27.
//

import Foundation

extension BluetoothService {
    
    func V3getCredientialArray() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        let command =  CommandService.shared.createAction(with: .N94, key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3searchCredential(model: SearchCredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        let command =  CommandService.shared.createAction(with: .N95(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3credentialAction(model: CredentialRequestModel) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        let command =  CommandService.shared.createAction(with: .N96(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3delCredential(position: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        let model = IndexUserCredentialRequestModel(index: position)
        let command =  CommandService.shared.createAction(with: .N98(model), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
}
