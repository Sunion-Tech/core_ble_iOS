//
//  AddTokenResult.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//



import Foundation

public class AddTokenResult {
    private var response:[UInt8]
    public var isSuccess:Bool {
        self.getIsSuccess()
    }
    public var index:Int? {
        self.getIndex()
    }
    public  var token:[UInt8]? {
        self.getToken()
    }

    init(response:[UInt8]) {
        self.response = response
    }

    private func getIsSuccess()-> Bool {
        guard let index0 = self.response[safe: 0] else { return false }
        return index0 == 0x01
    }

    private func getIndex()-> Int? {
        guard let index1 = self.response[safe: 1] else { return nil }
        return index1.toInt
    }

    private func getToken()-> [UInt8]? {
        guard self.response[safe: 2] != nil else { return nil }
        guard self.response[safe: 9] != nil else { return nil }
        return Array(self.response[2...9])
    }
}


