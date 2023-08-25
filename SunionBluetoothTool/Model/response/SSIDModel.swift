//
//  SSIDModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import Foundation

public class SSIDModel {

    public enum PasswordLevel {
        case required
        case none
        case completed
        case unknown
    }

    var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
    }

    public var passwordLevel: PasswordLevel {
        guard let index0 = self.response[safe: 0] else { return .unknown }
        guard let cmdString = String(bytes: Data([index0]), encoding: .utf8) else { return .unknown }
        guard cmdString == "L" else { return .unknown }
        guard let index1 = self.response[safe: 1] else { return .unknown }
        guard let string = String(bytes: Data([index1]), encoding: .utf8) else { return .unknown }
        switch string {
        case "Y":
            return .required
        case "N":
            return .none
        case "E":
            return .completed
        default:
            return .unknown
        }
    }

    public var name:String? {
        guard self.response[safe: 2] != nil else { return nil }
        let nameData = self.response[2...self.response.count - 1]
        return String(data: Data(nameData), encoding: .utf8)
    }
}


