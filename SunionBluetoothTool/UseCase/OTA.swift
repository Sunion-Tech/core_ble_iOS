//
//  OTA.swift
//  SunionBluetoothTool
//
//  Created by Cthiisway on 2024/3/26.
//

import Foundation

public class OTA  {
    
    weak var tool: useCase?
    
    init(tool: useCase) {
        self.tool = tool
    }
    
    
    public func status(model: OTAStatusRequestModel) {
        tool?.tool?.bluetoothService?.V3otaStatus(req: model)
    }
    
    public func data(model: OTADataRequestModel) {
        tool?.tool?.bluetoothService?.V3otaData(req: model)
    }
    


}
