//
//  Enum.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2023/2/6.
//

import Foundation

public enum LockDirectionOption: String {
    case left
    case right
    case unknown
    case ignore
    case unsupport
    case error

}

public enum BatteryWarningOption: String {
    case normal
    case low
    case emergancy
    case error
}

public enum LockOption: String {
    case locked
    case unlocked
    case error
    case loading
}

public enum AccessTypeOption: String {
    case AccessCode
    case AccessCard
    case Fingerprint
    case Face
    case error
}

public enum setupAccessOption: UInt8 {
    case start = 0x01
    case quit = 0x00
    case update = 0x02
}

public enum CodeStatus: String {
    case open
    case close
    case unsupport
    case error
}

public enum DeadboltStatus: String {
    case protrude
    case retract
    case unsupport
    case error
}

public enum DoorStateStatus: String {
    case close
    case unclose
    case unsupport
    case error
}

public enum LockStateSatus: String {
    case lockedUnlinked
    case unlockedLinked
    case unknow
    case error
}

public enum SecruityboltStatus: String {
    case protrude
    case unprotrude
    case unsupport
    case error
}

public enum VoiceType: String {
    case onoff
    case level
    case percentage
    case error
}

public enum VoiceValue {
    case open
    case close
    case loudly
    case whisper
    case value(Int)
    case error
    
    public var name: String {
        switch self {
        case .open:
            return "open"
        case .close:
            return "close"
        case .loudly:
            return "loudly"
        case .whisper:
            return "whisper"
        case .value:
            return "value"
        default:
            return "error"
        }
    }
}
