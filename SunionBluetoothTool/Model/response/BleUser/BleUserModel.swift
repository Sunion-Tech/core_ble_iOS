//
//  BleUserModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/5/6.
//


import Foundation

public class BleUserModel {

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
    
    public var idenity: String? {
        self.getidentity()
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

    private func getName()-> String? {

        // Name length (max 20)
        guard let length = response[safe: 12]  else { return nil }
        print("Name length: \(length.toInt)")
        if length.toInt > 20 { return nil }
        
        let namelastIndex = 14+length.toInt-1
        
        print(" end: \(namelastIndex)")
        
        guard  response[safe: 14] != nil && response[safe: namelastIndex] != nil else { return nil}

    
        let data = self.response[14...namelastIndex]
        return String(data: Data(data), encoding: .utf8)
    }
    
    private func getidentity() -> String? {
        
        // Name length (max 20)
        guard let nlength = response[safe: 12]  else { return nil }
        if nlength.toInt > 20 { return nil }
        
        // User Idenity length (max 60)
        guard let length = response[safe: 13]  else { return nil }
        if length.toInt > 60 { return nil }
        
        let idStartIndex = 14+nlength.toInt - 1
        let idEndIndex = idStartIndex+length.toInt - 1
        
        guard  response[safe: idStartIndex] != nil && response[safe: idEndIndex] != nil else { return nil}
        let data = self.response[idStartIndex...idEndIndex]
        
        print("id start: \(idStartIndex), end: \(idEndIndex)")
        
        return String(data: Data(data), encoding: .utf8)
    }
    

}



