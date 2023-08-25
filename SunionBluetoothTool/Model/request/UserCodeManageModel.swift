//
//  PinCodeManageModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation

public class PinCodeManageModel {

    public enum PinCodeManageOption: String {
        case add
        case edit
    }

    public var index:Int
    public var isEnable:Bool
   
    public var PinCode:[Int]
    public var name:String
    public var schedule:PinCodeScheduleModel
    var command: [UInt8] {
        self.getCommand()
    }

    public var PinCodeManageOption:PinCodeManageOption


    var commandLength: UInt8 {
        self.getCommandLength()
    }

    public init(index:Int, isEnable:Bool, PinCode:[Int], name:String, schedule:PinCodeScheduleModel, PinCodeManageOption:PinCodeManageOption) {
        self.index = index
        self.isEnable = isEnable
        self.PinCode = PinCode
        self.name = name
        self.schedule = schedule
        self.PinCodeManageOption = PinCodeManageOption
    }

    private func getCommandLength()-> UInt8 {
        let fixLength = 3 + 12
        let nameLength = self.name.data(using: .utf8)?.count ?? 0
        let PinCodeLength = self.PinCode.count
        let totalLength = fixLength + nameLength + PinCodeLength
        return UInt8(totalLength)
    }

    private func getCommand()-> [UInt8] {
        let index = UInt8(self.index)
        let isEnable:UInt8 = self.isEnable ? 0x01 : 0x00
        let PinCodeLength = UInt8(PinCode.count)
        var command = [self.PinCodeManageOption == .add ? 0xEC : 0xED, self.getCommandLength(), index , isEnable, PinCodeLength]
        self.PinCode.forEach{ command.append(UInt8($0))}
        self.schedule.command.forEach{ command.append($0)}
        self.name.data(using: .utf8)?.bytes.forEach{ command.append($0)}
        return command
    }
}


