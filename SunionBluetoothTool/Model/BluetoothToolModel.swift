//
//  QrcodeModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//

import Foundation

public class BluetoothToolModel {
    public var token: [UInt8]?
    public var aes1Key: [UInt8]?
    public var macAddress: String?
    public var permission: CommandService.TokenPermission = .error
    public var aes2Key: [UInt8]?
    public var permanentToken: [UInt8]?
    public var qrCodeShareFrom: String?
    public var qrCodeSerialNumber: String?
    public var qrCodeDisplayName: String?
    public var modelName: String?
    public var FirmwareVersion: String?
    public var RFVersion: String?
    public var bleName: String?
    public var identifier: String?
}
