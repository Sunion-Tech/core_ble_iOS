//
//  EditTokenModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import Foundation

public class EditTokenModel {

    public enum TokenPermission: String {
        case all
        case limit
    }

    public var tokenName:String
    public var tokenPermission:TokenPermission
    public var tokenIndex:Int
    var command:[UInt8] {
        self.getCommand()
    }

    public init(tokenName:String, tokenPermission:TokenPermission, tokenIndex:Int) {
        self.tokenName = tokenName
        self.tokenPermission = tokenPermission
        self.tokenIndex = tokenIndex
    }

    private func getCommand()-> [UInt8] {
        let tokenString:String = self.tokenPermission == .all ? "A" : "L"
        let tokenValue = tokenString.data(using: .utf8)?.bytes ?? []
        let nameValue = tokenName.data(using: .utf8)?.bytes ?? []
        var byteArray:[UInt8] = [UInt8(self.tokenIndex)]
        tokenValue.forEach{byteArray.append($0)}
        nameValue.forEach{byteArray.append($0)}
        return byteArray
    }
}


