//
//  SetupCredentialModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2024/2/1.
//


import Foundation

public class SetupCredentialModel {
    
    public var type : CredentialStructModel.CredentialTypeEnum {
        self.getType()
    }
    
    public var state: setupAccessOption {
        self.getState()
    }
    
    public var status: setupStatusOption {
        self.getStatus()
    }
    
    public var index: Int? {
        self.getIndex()
    }

    
    public var data: [UInt8]? {
        self.getData()
    }
    
    public var faceError: String {
       // 0x04    過近, 請遠離 please take a step to the backward and keep your face facing the camera
       // 0x05    過遠, 請靠近 please take a step to the foward and keep your face facing the camera
       // 0x0C    過左, 請向右走一步 please take a step to the right and keep your face facing the camera
       // 0x0D    過右, 請向左走一步 please take a step to the left and keep your face facing the camera
      //  其他    未知, 請面向鏡頭並保持約1m   Please stand in front of the lockset and keep your face facing the camera
    
        self.getFaceError()
    }
    
    private var response:[UInt8]
    
    
    public init(_ response:[UInt8]) {
        self.response = response
    }
    
    
    private func getFaceError() -> String {
        guard let index0 = self.response[safe: 5] else { return "Please stand in front of the lockset and keep your face facing the camera" }
      
        switch index0 {
        case 0x04:
            return "please take a step to the backward and keep your face facing the camera"
        case 0x05:
            return "please take a step to the foward and keep your face facing the camera"
        case 0x0C:
            return "please take a step to the right and keep your face facing the camera"
        case 0x0D:
            return "please take a step to the left and keep your face facing the camera"
        default:
            let hexString = String(format: "%02x", index0)
            return "Error: \(hexString)"
        }

    }
    
    private func getType() -> CredentialStructModel.CredentialTypeEnum {
        guard  let status = response[safe: 0]  else { return .unknownEnumValue }
        
        switch status {
        case 0x00:
            return .programmingPIN
        case 0x01:
            return .pin
        case 0x02:
            return .rfid
        case 0x03:
            return .fingerprint
        case 0x04:
            return .fingerVein
        case 0x05:
            return .face
        default:
            return .unknownEnumValue
        }
    }
    
    private func getState() -> setupAccessOption {
        guard let index1 = self.response[safe: 1] else { return .quit }
        
        
        switch index1 {
        case 0x00:
            return .quit
        case 0x01:
            return .start
        case 0x02:
            return .update
        default:
            return .quit
        }
    }
    

    
    private func getIndex() -> Int? {
        guard let index1 = self.response[safe: 2] else { return nil }
        guard let index2 = self.response[safe: 3] else { return nil }
        
        let data = Data([index1, index2, 0x00, 0x00])
        let uint32 = UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) })
        let intValue = Int32(bitPattern: UInt32(uint32))

        return  Int(intValue)
    }
    
    private func getStatus()-> setupStatusOption {
        guard let index0 = self.response[safe: 4] else { return .fail }
    
        switch index0 {
            
        case 0x00:
            return .fail
        case 0x01:
            return .success
        case 0x02:
            return .failwithfull
        default:
            return .fail
        }
    }
    
    
    private func getData() -> [UInt8]? {
        guard self.response[safe: 5] != nil else { return nil }
        
        let data = Array(self.response[5...self.response.count - 1])
        
        return data
        
    }
  
    
}

