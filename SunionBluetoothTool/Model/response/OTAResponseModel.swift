//
//  OTAResponseModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/10/11.
//

import Foundation


public class OTAResponseModel {
    private var response:[UInt8]
    
    
    public var target: otaTarget {
        self.getTarget()
    }
    
    public var state: otaState {
        self.getOTAState()
    }
    
    public var isSuccess:Bool {
        self.getIsSuccess()
    }


    init(response:[UInt8]) {
        self.response = response
    }
    
    private func getTarget() -> otaTarget {
        guard let index = self.response[safe: 0] else { return .wireless }
        return index == 0x01 ? .wireless : .mcu
    }
    
    
    private func getOTAState() -> otaState {
        guard let index = self.response[safe: 1] else { return .cancel }
        return index == 0x00 ? .cancel : index == 0x01 ? .finish : .start
    }

    private func getIsSuccess()-> Bool {
        guard let index0 = self.response[safe: 2] else { return false }
        return index0 == 0x01
    }
    



}
