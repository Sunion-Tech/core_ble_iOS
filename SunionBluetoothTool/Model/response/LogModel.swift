//
//  LogModel.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation
import SwiftyJSON

public class LogModel {

    public var timestamp: Double = 0
    public var event: Int = -1
    public var name: String = ""
    public var message: String?

    init(data: [UInt8]) {
        let index0 = data[safe: 0] ?? 0x00
        let index1 = data[safe: 1] ?? 0x00
        let index2 = data[safe: 2] ?? 0x00
        let index3 = data[safe: 3] ?? 0x00
        let value =
        [index3.toInt << 24, index2.toInt << 16, index1.toInt << 8, index0.toInt].reduce(0, +)
        let timestamp = Double(value)
        
        
        let event = data[safe: 4]?.toInt ?? -1
        if data.count - 1 >= 5 {
            let stringData = Array(data[5...data.count - 1])
            let name = String(data: Data.init(stringData), encoding: .utf8) ?? ""
            self.name = name
        }
        self.timestamp = timestamp
    
        self.event = event
    }

    init(json: JSON) {
        let event = json["Type"].intValue
        let timestamp = (json["Millisecond"].doubleValue) / 1000
        let name = json["ExtraDetail"]["Actor"].stringValue
        let message = json["ExtraDetail"]["Message"].string
        self.name = name
        self.timestamp = timestamp
        self.event = event
        self.message = message
    }
}



struct EventLogItem {
    let cell: EventLogCell
}

enum EventLogCell {
    case eventLog(LogModel)

    var logModel: LogModel {
        switch self {
        case .eventLog(let model): return model
        }
    }

}


