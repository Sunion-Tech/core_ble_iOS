//
//  EditBleUserModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/5/6.
//


import Foundation

public class EditBleUserModel {

    public enum TokenPermission: String {
        case all
        case limit
    }

    public var tokenName: String
    public var tokenPermission: TokenPermission
    public var tokenIndex: Int
    public var idenity: String
    
    var command:[UInt8] {
        self.getCommand()
    }

    public init(tokenName:String, tokenPermission:TokenPermission, tokenIndex:Int, idenity: String) {
        self.tokenName = tokenName
        self.tokenPermission = tokenPermission
        self.tokenIndex = tokenIndex
        self.idenity = idenity
    }

    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = [UInt8(self.tokenIndex)]
        // permission
        let tokenString:String = self.tokenPermission == .all ? "A" : "L"
        let tokenValue = tokenString.data(using: .utf8)?.bytes ?? []
        tokenValue.forEach{byteArray.append($0)}
        
        // name length
    
        let nLength = tokenName.count
        byteArray.append(UInt8(nLength))
   
        // id length
        
       
        let iLength = idenity.count
        byteArray.append(UInt8(iLength))
      
        
        
        // nvalue
        let nameValue = tokenName.data(using: .utf8)?.bytes ?? []
        nameValue.forEach{byteArray.append($0)}
        
        // ivalue
        let iValue = idenity.data(using: .utf8)?.bytes ?? []
        iValue.forEach{byteArray.append($0)}
        
        return byteArray
    }
}


