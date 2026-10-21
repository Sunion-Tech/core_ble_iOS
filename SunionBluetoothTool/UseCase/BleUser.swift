//
//  Token.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation
import SwiftyJSON


public class BleUser  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func array() {
        tool?.tool?.bluetoothService?.V3bleUserArray()
    }
    
    public func data(position: Int) {
        tool?.tool?.bluetoothService?.V3getbleUser(position: position)
    }
    
    public func create(model: addBleUserModel) {
        tool?.tool?.bluetoothService?.V3createbleUser(model: model)
    }
    
    public func createPermanent(model: addBleUserModel) {
        tool?.tool?.bluetoothService?.V3createPermanentbleUser(model: model)
    }
    
    public func edit(model: EditBleUserModel) {
        tool?.tool?.bluetoothService?.V3editbleUser(model: model)
    }
    
    public func delete(model: BleUserModel) {
        tool?.tool?.bluetoothService?.V3delbleUser(model: model)
    }
    
    public func qrCode(barcodeKey: String, tokenIndex: Int, aes1Key: Data, macAddress: String?, uuid: String?, userName: String, modelName: String, deviceName: String) {
        tool?.tool?.bluetoothService?.V3getbleUserQrCode(barcodeKey: barcodeKey, tokenIndex: tokenIndex, aes1Key: aes1Key, macAddress: macAddress, uuid: uuid, userName: userName, modelName: modelName, deviceName: deviceName)
    }
    
    // offline share (wifi / gateway device offline): token is from 8F, no need N8B
    // I: token index, R: Manager or User, N: share to user name
    public func offlineShareString(barcodeKey: String, tokenIndex: Int, token: [UInt8], aes1Key: Data, macAddress: String?, uuid: String, userName: String, modelName: String, deviceName: String, role: String, shareToName: String) -> String? {
        let dic = ["T": token.toHexString(), "K": aes1Key.toHexString(), "A": macAddress ?? "", "F": userName, "L": deviceName, "M": modelName, "U": uuid, "I": String(tokenIndex), "R": role, "N": shareToName]
        guard let json = JSON(dic).rawString() else { return nil }
        return AESModel.shared.encodeBase64String(json, barcodeKey: barcodeKey)
    }

    // decode offline share string (keys same as offlineShareString), no state change
    public func decodeOfflineShareString(barcodeKey: String, shareString: String) -> OfflineShareModel? {
        guard let decode = AESModel.shared.decodeBase64String(shareString, barcodeKey: barcodeKey)?.replacingOccurrences(of: "\0", with: "") else { return nil }
        let json = JSON(parseJSON: decode)
        guard json.type == .dictionary else { return nil }
        return OfflineShareModel(token: json["T"].stringValue.lowercased(),
                                 aes1Key: json["K"].stringValue,
                                 macAddress: json["A"].stringValue,
                                 userName: json["F"].stringValue,
                                 deviceName: json["L"].stringValue,
                                 modelName: json["M"].stringValue,
                                 uuid: json["U"].stringValue,
                                 tokenIndex: json["I"].string.flatMap({ Int($0) }) ?? json["I"].int,
                                 role: json["R"].stringValue,
                                 shareToName: json["N"].stringValue)
    }

}

// decoded offline share string
public struct OfflineShareModel {
    public let token: String        // T, hex lowercased
    public let aes1Key: String      // K, hex
    public let macAddress: String   // A
    public let userName: String     // F, name of share from
    public let deviceName: String   // L
    public let modelName: String    // M
    public let uuid: String         // U
    public let tokenIndex: Int?     // I
    public let role: String         // R, Manager or User
    public let shareToName: String  // N, name of share to
}
