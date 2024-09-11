//
//  EndpointRequestModel.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/9/11.
//

import Foundation
import CommonCrypto
import CryptoKit

public enum EndpointTargetEnum: UInt8 {
    case api = 0x00
    case path = 0x01
    case mqtt = 0x02
    case hash = 0x03
    case error = 0x04
    
}


public class EndpointRequestModel {
    


    
    public var type: EndpointTargetEnum
    public var data: String
    
    
    var command:[UInt8] {
        self.getCommand()
    }
    
    public init(type: EndpointTargetEnum, data: String) {
        self.type = type
        self.data = data
    
    }
    
    private func getCommand()-> [UInt8] {
        var byteArray:[UInt8] = []
        
        byteArray.append(self.type.rawValue)
        
        if self.type == .hash {
            let dataValue = sha256Hash(self.data)
            dataValue.forEach{byteArray.append($0)}
        } else {
            let dataValue = data.data(using: .utf8)?.bytes
            
            dataValue?.forEach{byteArray.append($0)}
        }

        return byteArray
    }
    
    private func sha256Hash(_ input: String) -> [UInt8] {
        if #available(iOS 13.0, *) {
            return Array(SHA256.hash(data: Data(input.utf8)))
        } else {
            let inputData = Data(input.utf8)
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            
            inputData.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(inputData.count), &hash)
            }
            
            return hash
        }
    }
}
