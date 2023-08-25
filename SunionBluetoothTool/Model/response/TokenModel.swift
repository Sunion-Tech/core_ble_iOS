//
//  TokenModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation

public class TokenModel {

    public enum TokenType: String {
        case permanent
        case oneTime
        case invalid
    }

    public enum OwnerTokenType: String {
        case owner
        case notOwner
        case error
    }

    private var response:[UInt8]

    public var isEnable:Bool {
        return self.checkIsEnable()
    }

    public var tokenMode:TokenType {
        return self.getTokenMode()
    }

    public var isOwnerToken:OwnerTokenType {
        return self.checkIsOwnerToken()
    }

    public var tokenPermission: CommandService.TokenPermission {
        self.getTokenPermisson()
    }

    public var token:[UInt8]? {
        return self.getToken()
    }

    public var name:String? {
        self.getName()
    }
    

    public var indexOfToken:Int?


    init(response:[UInt8]) {
        self.response = response
    }

    private func checkIsEnable()-> Bool {
        guard response.count > 0 else { return false }
        guard let index0 = response[safe: 0] else { return false }
        return index0 == 0x01
    }

    private func getTokenMode()-> TokenType {
        guard response.count > 0 else { return .invalid }
        guard let index1 = response[safe: 1] else { return .invalid }
        switch index1 {
        case 0x01:
            return .permanent
        case 0x00:
            return .oneTime
        default:
            return .invalid
        }
    }

    private func checkIsOwnerToken()-> OwnerTokenType {
        guard response.count > 0 else { return .error }
        guard let index2 = response[safe: 2] else { return .error }

        switch index2 {
        case 0x00:
            return .notOwner
        case 0x01:
            return .owner
        default:
            return .error
        }
    }

    private func getTokenPermisson()-> CommandService.TokenPermission {
        guard response.count > 0 else { return .error }
        guard let index3 = response[safe: 3] else { return .error }
        guard let string = String(data: Data([index3]), encoding: .utf8)?.lowercased() else { return .error }
        switch string {
        case "o","m":
            return .owner
        case "a":
            return .manager
        case "l":
            return .user
        case "n":
            return .none
        default:
            return .error
        }
    }

    private func getToken()-> [UInt8]? {
        guard response.count > 0 else { return nil }
        guard response[safe: 4] != nil && response[safe: 11] != nil else { return nil }
        return Array(response[4...11])
    }

    private func getName()->String? {

        guard response[safe: 12] != nil else { return nil }
        guard response[safe: response.count - 1] != nil else { return nil }
        guard response.count - 1 >= 12 else { return nil }

        let data = self.response[12...self.response.count - 1]
        return String(data: Data(data), encoding: .utf8)
    }

}


