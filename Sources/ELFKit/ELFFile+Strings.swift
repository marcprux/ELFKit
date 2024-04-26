//
//  ELFFile+Strings.swift
//
//
//  Created by p-x9 on 2024/04/27
//  
//

import Foundation

extension ELFFile {
    public struct Strings: Sequence {
        public let data: Data

        /// file offset of string table start
        public let offset: Int

        /// size of string table
        public let size: Int

        public func makeIterator() -> Iterator {
            .init(data: data)
        }
    }
}

extension ELFFile.Strings {
    init(elf: ELFFile, offset: Int, size: Int) {
        let data = elf.fileHandle.readData(
            offset: numericCast(offset),
            size: size
        )
        self.init(
            data: data,
            offset: offset,
            size: size
        )
    }
}

extension ELFFile.Strings {
    public struct Iterator: IteratorProtocol {
        public typealias Element = StringTableEntry

        private let data: Data
        private let tableSize: Int

        private var nextOffset: Int

        init(data: Data) {
            self.data = data
            self.tableSize = data.count
            self.nextOffset = 0
        }

        public mutating func next() -> Element? {
            data.withUnsafeBytes {
                if nextOffset >= tableSize { return nil }
                guard let baseAddress = $0.baseAddress else { return nil }

                let ptr = baseAddress
                    .advanced(by: nextOffset)
                    .assumingMemoryBound(to: CChar.self)
                let string = String(cString: ptr)

                let nextPointer = UnsafePointer(strchr(ptr, 0))
                    .advanced(by: 1)

                let result = Element(string: string, offset: nextOffset)

                nextOffset += Int(bitPattern: nextPointer) - Int(bitPattern: ptr)

                return  result
            }
        }
    }
}
