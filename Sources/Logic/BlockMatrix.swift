//
//  BlockMatrix.swift
//  hello-eggy-ios-swift
//
//  Created by Melinda Lu on 8/21/21.
//

import Foundation

protocol Block {
    associatedtype Value
    
    var number: Value { get set }
}

struct IndexedBlock<T> where T: Block {
    typealias Index = BlockMatrix<T>.Index
    
    let index: Self.Index
    let item: T
}

struct BlockMatrix<T> : CustomDebugStringConvertible where T: Block {
    typealias Index = (Int, Int)
    
    fileprivate var matrix: [[T?]]
    
    init() {
        matrix = [[T?]]()
        for _ in 0..<4 {
            var row = [T?]()
            for _ in 0..<4 {
                row.append(nil)
            }
            matrix.append(row)
        }
    }
    
    var debugDescription: String {
        matrix.map { row -> String in
            row.map {
                if $0 == nil {
                    return " "
                } else {
                    return String(describing: $0!.number)
                }
            }.joined(separator: "\t")
        }.joined(separator: "\n")
    }
    
    var flatten: [IndexedBlock<T>] {
        return self.matrix.enumerated().flatMap { (y: Int, element: [T?]) in
            element.enumerated().compactMap { (x: Int, element: T?) in
                guard let element = element else {
                    return nil
                }
                return IndexedBlock(index: (x, y), item: element)
            }
        }
    }
    
    subscript(index: Self.Index) -> T? {
        guard isIndexValid(index) else {
            return nil
        }
        
        return matrix[index.1][index.0]
    }
    
    // Move the block to a specific location, leaving the original location empty
    mutating func move(from: Self.Index, to: Self.Index) {
        guard isIndexValid(from) && isIndexValid(to) else {
            return
        }
        
        guard let source = self[from] else {
            return
        }
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    // Move the block to a specific location and change its value, leaving the original location blank
    mutating func move(from: Self.Index, to: Self.Index, with newValue: T.Value) {
        guard isIndexValid(from) && isIndexValid(to) else {
            return
        }
        
        guard var source = self[from] else {
            return
        }
        
        source.number = newValue
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    // Place a block at a specific location
    mutating func place(_ block: T?, to: Self.Index) {
        matrix[to.1][to.0] = block
    }
    
    fileprivate func isIndexValid(_ index: Self.Index) -> Bool {
        guard index.0 >= 0 && index.0 < 4 else {
            return false
        }
        
        guard index.1 >= 0 && index.1 < 4 else {
            return false
        }
        
        return true
    }
}
