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
    private var adjustments: [(description: String, amount: Int)] = []

    func add(item: SKU) {
        scannedItems.append(item)
    }
    
    func items() -> [SKU] {
        return scannedItems
    }

    func addAdjustment(description: String, amount: Int) {
        adjustments.append((description, amount))
    }

    func apply(schemes: [PricingScheme]) {
        for scheme in schemes {
            scheme.apply(to: self)
        }
    }

    func subtotal() -> Int {
        let itemsTotal = scannedItems.reduce(0) { $0 + $1.price() }
        let adjustmentsTotal = adjustments.reduce(0) { $0 + $1.amount }
        return itemsTotal + adjustmentsTotal
    }

    func total() -> Int {
        return subtotal()
    }

    func output() -> String {
        var lines: [String] = []
        lines.append("Receipt:")
        for item in scannedItems {
            let priceStr = String(format: "$%.2f", Double(item.price())/100)
            lines.append("\(item.name): \(priceStr)")
        }
        for adj in adjustments {
            let priceStr = String(format: "$%.2f", Double(adj.amount)/100)
            lines.append("\(adj.description): \(priceStr)")
        }
        lines.append("------------------")
        let totalStr = String(format: "$%.2f", Double(total())/100)
        lines.append("TOTAL: \(totalStr)")
        return lines.joined(separator: "\n")
    }
}


class Register {
    private var currentReceipt = Receipt()
    private let schemes: [PricingScheme]

    init(schemes: [PricingScheme] = []) {
        self.schemes = schemes
        self.currentReceipt = Receipt()
    }

    func scan(_ item: SKU) {
        currentReceipt.add(item: item)
    }

    func subtotal() -> Int {
        return currentReceipt.subtotal()
    }

    func total() -> Receipt {
        currentReceipt.apply(schemes: schemes)
        let finalized = currentReceipt
        currentReceipt = Receipt()
        return finalized
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

protocol PricingScheme {
    func apply(to receipt: Receipt)
}

class WeightedItem: SKU {
    let name: String
    let unitPrice: Int
    let weight: Double

    init(name: String, unitPrice: Int, weight: Double) {
        self.name = name
        self.unitPrice = unitPrice
        self.weight = weight
    }

    func price() -> Int {
        let raw = Double(unitPrice) * weight
        return Int(raw.rounded())
    }
}


class TwoForOneScheme: PricingScheme {
    let targetName: String
    init(targetName: String) {
        self.targetName = targetName
    }

    func apply(to receipt: Receipt) {
        let matches = receipt.items().filter { $0.name == targetName }
        let groups = matches.count / 3
        guard groups > 0, let sample = matches.first else { return }
        let discount = -groups * sample.price()
        receipt.addAdjustment(description: "2-for-1 promo (\(targetName))", amount: discount)
    }
}


class GroupedScheme: PricingScheme {
    let groupA: Set<String>
    let groupB: Set<String>
    let discountPercent: Double

    init(groupA: [String], groupB: [String], discountPercent: Double) {
        self.groupA = Set(groupA)
        self.groupB = Set(groupB)
        self.discountPercent = discountPercent
    }

    func apply(to receipt: Receipt) {
        let items = receipt.items()
        let countA = items.filter { groupA.contains($0.name) }.count
        let countB = items.filter { groupB.contains($0.name) }.count
        let pairs = min(countA, countB)
        guard pairs > 0 else { return }

        var applied = 0
        for item in items {
            if applied >= pairs * 2 { break }
            if groupA.contains(item.name) || groupB.contains(item.name) {
                let disc = Int(Double(item.price()) * discountPercent)
                receipt.addAdjustment(description: "\(Int(discountPercent*100))% off (\(item.name))", amount: -disc)
                applied += 1
            }
        }
    }
}


class CouponScheme: PricingScheme {
    let targetName: String
    let discountPercent: Double

    init(targetName: String, discountPercent: Double) {
        self.targetName = targetName
        self.discountPercent = discountPercent
    }

    func apply(to receipt: Receipt) {
        guard let item = receipt.items().first(where: { $0.name == targetName }) else { return }
        let disc = Int(Double(item.price()) * discountPercent)
        receipt.addAdjustment(description: "Coupon \(Int(discountPercent*100))% (\(targetName))", amount: -disc)
    }
}



class RainCheckScheme: PricingScheme {
    let targetName: String
    let rainPrice: Int

    init(targetName: String, rainPrice: Int) {
        self.targetName = targetName
        self.rainPrice = rainPrice
    }

    func apply(to receipt: Receipt) {
        guard let item = receipt.items().first(where: { $0.name == targetName }) else { return }
        let original = item.price()
        let diff = rainPrice - original
        receipt.addAdjustment(description: "Rain check (\(targetName))", amount: diff)
    }
}


