//
//  EditAdminCodeModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//




import Foundation

class EditAdminCodeModel {

    private var oldCode:[Int]
    private var newCode:[Int]

    init (oldCode:[Int], newCode:[Int]) {
        self.oldCode = oldCode
        self.newCode = newCode
    }

    var command:[UInt8] {
        self.getCommand()
    }

    var commandLength:UInt8 {
        self.getCommandLength()
    }

    private func getCommand()-> [UInt8] {
        let oldCodeLength = UInt8(oldCode.count)
        let newCodeLength = UInt8(newCode.count)
        let commandLength = UInt8(1 + oldCodeLength + 1 + newCodeLength)
        var byteArray = [0xC8, commandLength, oldCodeLength]
        oldCode.forEach{byteArray.append(UInt8($0))}
        byteArray.append(newCodeLength)
        newCode.forEach{byteArray.append(UInt8($0))}
        return byteArray
    }

    private func getCommandLength() -> UInt8 {
        let oldCodeLength = UInt8(oldCode.count)
        let newCodeLength = UInt8(newCode.count)
        return UInt8(1 + oldCodeLength + 1 + newCodeLength)
    }
}


