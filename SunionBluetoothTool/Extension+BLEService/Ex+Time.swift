//
//  Ex+Time.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation


extension BluetoothService {
    
    func V3setDeviceTime() {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        let command = CommandService.shared.createAction(with: .D3(Date()), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
    
    func V3setTimeZone(timezone: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        action = .none
        guard let timeZone = TimeZone(identifier: timezone),
              let abbreviation = timeZone.secondsFromGMT().toString.data(using: .utf8) else { return }
        let command = CommandService.shared.createAction(with: .D9(Int32(timeZone.secondsFromGMT()), abbreviation), key: aes2key!)
        peripheral.writeValue(command!, for: characteristic, type: .withoutResponse)
    }
}
