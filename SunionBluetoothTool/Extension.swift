//
//  Extension.swift
//  SunionBluetoothTool
//
//  Created by Sunion User 2 on 2022/11/28.
//


import Foundation
// MARK: - Data
extension Data {
    
    var bytes : [UInt8]{
        return [UInt8](self)
    }
    
}

// MARK: - String
extension String {
    
    var fromBase64:Data? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        return data
    }
    
    var lockNameToMacAddress: String {
        let string = self.replacingOccurrences(of: "BT_Lock_", with: "")
        let string2 = string.replacingOccurrences(of: "FFFE", with: "").lowercased()
        return string2
    }
    
    var hexStringTobyteArray: [UInt8] {
        let chunkedString = self.chunked(into: 2, separatedBy: ":")
        let arrayString = chunkedString.components(separatedBy: ":")
        let byteArray = arrayString.map { UInt8($0, radix: 16) ?? 0x00 }
        return byteArray
    }
    
    var appendTrailingZero:String {
        if self.count >= 9 {
            return self
        } else {
            return self + "".padding(toLength: 9 - self.count, withPad: "0", startingAt: 0)
        }
    }
    
    func subString(start: Int, end: Int) -> String {
        let startIndex = String.Index(utf16Offset: start, in: self)
        let endIndex = String.Index(utf16Offset: end, in: self)

        let substring = String(self[startIndex...endIndex])
        return substring
    }
    
    func chunked(into size: Int, separatedBy separator: String) -> String {
        let array = Array(self)
        let newArray = array.chunked(into: size)
        var newString = ""
        for (index, item) in newArray.enumerated() {
            if index == 0 {
                newString = String(item)
            } else {
                newString += separator + String(item)
            }
        }
        return newString
    }
    
    
}

// MARK: - Array
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element == UInt8 {

    func bytesToHex(spacing: String = ",") -> String {
        var hexString: String = ""
        var count = self.count
        for byte in self {
            hexString.append(String(format:"%02X", byte))
            count = count - 1
            if count > 0 {
                hexString.append(spacing)
            }
        }

        return hexString + ", length: \(self.count)"
    }

    func safe(safeRange: Range<Int>) -> ArraySlice<Element>? {
        if safeRange.endIndex > endIndex {
            if safeRange.startIndex >= endIndex {return nil}
            else {return self[safeRange.startIndex..<endIndex]}
        }
        else {
            return self[safeRange]
        }
    }
    
    public func toHexString() -> String {
      `lazy`.reduce(into: "") {
        var s = String($1, radix: 16)
        if s.count == 1 {
          s = "0" + s
        }
        $0 += s
      }
    }
    
}

// MARK: - Double
extension Double {
    
    var toInt32:Int32 {
        return Int32(self)
    }
    
    var toInt64: Int64 {
        return Int64(self)
    }
    
    var decimalPartToInt32:Int32 {
        let decimalPart = String("\(self)".components(separatedBy: ".").last?.prefix(9) ?? "")
        let withZero = decimalPart.appendTrailingZero
        if self >= 0 {
            let value = Int32(withZero) ?? 0
            return value
        } else {
            let value = Int32(withZero) ?? 0
            return -value
        }

    }
    


    
}

// MARK: - Byte
typealias Byte = UInt8

extension Byte {
    // 以排序成位置 7 6 5 4 3 2 1 0
    var bits: [UInt16] {
        let bitsOfAbyte = 8
        var bitsArray = [UInt16](repeating: 0, count: bitsOfAbyte)
        for (index, _) in bitsArray.enumerated() {
            // Bitwise shift to clear unrelevant bits
            let bitVal: UInt8 = 1 << UInt8(bitsOfAbyte - 1 - index)
            let check = self & bitVal

            if check != 0 {
                bitsArray[index] = 1
            }
        }
        return bitsArray.reversed()
    }

    var toInt: Int { return Int(self) }
}

// MARK: - Int
extension Int {
    
    enum ToTwoByteOption {
        case low
        case high
    }
    
    var toString: String {
        return "\(self)"
    }
    

    
    var to4digitHexString:String {
        return String(format: "%04X", self)
    }
    
    func toTwoByte(_ option:ToTwoByteOption)-> UInt8 {
        let hexString = self.to4digitHexString
        switch option {
        case .low:
            let startIndex2 = hexString.index(hexString.startIndex, offsetBy: 2)
            let endIndex2 = hexString.index(hexString.startIndex, offsetBy: 3)
            let second = UInt8(hexString[startIndex2...endIndex2], radix: 16) ?? 0x00
            let result = second
            return result
        case .high:
            let startIndex1 = hexString.index(hexString.startIndex, offsetBy: 0)
            let endIndex1 = hexString.index(hexString.startIndex, offsetBy: 1)
            let first = UInt8(hexString[startIndex1...endIndex1], radix: 16) ?? 0x00
            return first
        }
    }
}

// MARK: - Collection
extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}


// MARK: - bytes
extension ContiguousBytes {
    func object<T>() -> T {
        withUnsafeBytes { $0.load(as: T.self) }
    }
}
