//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item : SKU {
    let name: String
    private let priceEach: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }

    func price() -> Int {
        return priceEach
    }
}

class Receipt {
    private var scannedItems: [SKU] = []

    func add(item: SKU) {
        scannedItems.append(item)
    }

    func items() -> [SKU] {
        return scannedItems
    }
    
    func total() -> Int {
        return scannedItems.reduce(0) { $0 + $1.price() }
    }

    func output() -> String {
        var lines: [String] = []
        lines.append("Receipt:")
        for item in scannedItems {
            let priceString = String(format: "$%.2f", Double(item.price())/100)
            lines.append("\(item.name): \(priceString)")
        }
        lines.append("------------------")
        let totalString = String(format: "$%.2f", Double(total())/100)
        lines.append("TOTAL: \(totalString)")
        return lines.joined(separator: "\n")
    }
}

class Register {
    private var currentReceipt: Receipt

    init() {
        self.currentReceipt = Receipt()
    }

    func scan(_ item: SKU) {
        currentReceipt.add(item: item)
    }

    func subtotal() -> Int {
        return currentReceipt.total()
    }

    func total() -> Receipt {
        let completed = currentReceipt
        currentReceipt = Receipt()
        return completed
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

