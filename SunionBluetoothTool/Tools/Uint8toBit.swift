//
//  Uint8toBit.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/7.
//

import Foundation




enum Bit: UInt8, CustomStringConvertible {
    case zero, one

    var description: String {
        switch self {
        case .one:
            return "1"
        case .zero:
            return "0"
        }
    }
}
