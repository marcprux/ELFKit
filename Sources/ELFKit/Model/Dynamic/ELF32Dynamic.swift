//
//  ELF32Dynamic.swift
//
//
//  Created by p-x9 on 2024/04/28
//  
//

import Foundation
import ELFKitC

public struct ELF32Dynamic: LayoutWrapper {
    public typealias Layout = Elf32_Dyn

    public var layout: Layout
}

extension ELF32Dynamic: ELFDynamicProtocol {
    public var _commonTag: DynamicTag? {
        .init(
            rawValue: numericCast(layout.d_tag),
            osabi: .none,
            machine: .none
        )
    }

    public func tag(inELF header: ELFHeader) -> DynamicTag? {
        .init(
            rawValue: numericCast(layout.d_tag),
            osabi: header.osABI ?? .none,
            machine: header.machine ?? .none
        )
    }

    public var value: Int {
        numericCast(layout.d_un.d_val)
    }
    
    public var pointer: Int {
        numericCast(layout.d_un.d_ptr)
    }
}
