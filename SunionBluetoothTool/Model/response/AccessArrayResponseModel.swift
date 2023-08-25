//
//  AccessArrayModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/7.
//

import Foundation

public class AccessArrayResponseModel {
    
    public var type: AccessTypeOption {
        self.getAccessModel()
    }
    public var finish: Bool? {
        self.getFinish()
    }
    public var hasDataAIndex: [Int] = []
    
    private var datalen: Int? {
        self.getDatalen()
    }


    
    private var response: [UInt8]
    
    init(data: [UInt8]) {
        self.response = data
        

        if data.count - 1 >= 2 {
            let stringData = Array(data[3...datalen!])
      
            for (location, element) in stringData.enumerated() {
        
                var count  = 0
                let val = element.bits.map{Int($0)}
                
      
                for el in val {
                
                    if el == 1 {
                   
                        let index = (location * 8) + count
                        if index < 199 {
                          hasDataAIndex.append(index)
                        }
                       
                    }
                    count = count + 1
                }
           
            }
           
        }
  
    }
    
    private func getDatalen() -> Int {
        guard let index4 = response[safe: 0] else { return 0 }
        return index4.toInt
    }
    
    private  func getAccessModel()  -> AccessTypeOption {
        guard let index4 = response[safe: 1] else { return .error }
        switch index4 {
        case 0x00:
            return .AccessCode
        case 0x01:
            return .AccessCard
        case 0x02:
            return .Fingerprint
        case 0x03:
            return .Face
        default:
            return .error
            
        }
      
    }
    
    private func getFinish() -> Bool? {
        guard let index4 = response[safe: 2] else { return nil }
        switch index4 {
        case 0x00:
            return false
        case 0x01:
            return true
        default:
            return nil
            
        }
    }
    

    
}
