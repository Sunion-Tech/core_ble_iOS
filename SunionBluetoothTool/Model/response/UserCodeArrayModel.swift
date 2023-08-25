//
//  PinCodeArrayModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation

public class PinCodeArrayModel {
    private var response:[UInt8]

    init(response:[UInt8]) {
        self.response = response
    }
    
    public var count: Int {
        return PinCodeCount()
    }
    
    public var data: [Int] {
        return PinCodeExistList()
    }
    
    public var firstEmptyIndex: Int {
        return indexOfFirstEmpty()
    }
    

    private func indexOfFirstEmpty()-> Int {
        let bits = self.response.flatMap({ (element: UInt8) -> [UInt16] in
            return element.bits
        })
  
       for (index, element) in bits.enumerated() {
           if (element == 0) {
               return index
           }
       }
        return 1

    }

    private  func PinCodeExistList() ->  [Int] {
        let bits = self.response.flatMap({ (element: UInt8) -> [UInt16] in
            return element.bits
        })
        
        return bits
            .enumerated()
            .filter{$0.1 == 1}
            .map { (index, element) -> Int in
                return index
            }

    }

    private  func PinCodeCount()-> Int {
        let bits = self.response.flatMap({ (element: UInt8) -> [UInt16] in
            return element.bits
        })
        return bits.filter{$0 == 1}.count - 1// not to present admin code
    }
}


