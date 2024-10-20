//
//  Extensions.swift
//  EmergencyAssistant
//
//  Created by Arnur Sabet on 19.10.2024.
//

import Foundation

extension Data {
    func toArray<T>(type: T.Type) -> [T] where T: Numeric {
        let count = self.count / MemoryLayout<T>.size
        return withUnsafeBytes { bufferPointer in
            Array(bufferPointer.bindMemory(to: T.self))
        }
    }
}

extension Data {
    init<T>(copyingBufferOf array: [T]) {
        self = array.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }
    }
}
