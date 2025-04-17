//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    

    // My Tests
    func testTwoForOneScheme() {
        let scheme = TwoForOneScheme(targetName: "Beans")
        let reg = Register(schemes: [scheme])
        for _ in 0..<3 {
            reg.scan(Item(name: "Beans", priceEach: 199))
        }
        let receipt = reg.total()
        XCTAssertEqual(398, receipt.total())
    }

    func testComboDiscountScheme() {
        let scheme = GroupedScheme(groupA: ["Ketchup"], groupB: ["Beer"], discountPercent: 0.10)
        let reg = Register(schemes: [scheme])
        reg.scan(Item(name: "Ketchup", priceEach: 300))
        reg.scan(Item(name: "Beer", priceEach: 500))
        reg.scan(Item(name: "Beer", priceEach: 500))
        reg.scan(Item(name: "Ketchup", priceEach: 300))
        let receipt = reg.total()
        // 2 Ketchups + 2 Beers = 1600, 10% off 4 items = 160 discount => 1440
        XCTAssertEqual(1440, receipt.total())
    }

    func testWeightedItemPricing() {
        let weighted = WeightedItem(name: "Steak", unitPrice: 899, weight: 1.234)
        XCTAssertEqual(1109, weighted.price())
    }

    func testWeightedItemInRegister() {
        let reg = Register()
        reg.scan(WeightedItem(name: "Apple", unitPrice: 150, weight: 0.75))
        let receipt = reg.total()
        // 150 * 0.75 = 112.5 -> rounded to 113
        XCTAssertEqual(113, receipt.total())
    }

    func testCouponScheme() {
        let scheme = CouponScheme(targetName: "Beans", discountPercent: 0.15)
        let reg = Register(schemes: [scheme])
        reg.scan(Item(name: "Beans", priceEach: 200))
        reg.scan(Item(name: "Pencil", priceEach: 100))
        let receipt = reg.total()
        // Beans: 200 - 30 = 170 + Pencil:100 = 270
        XCTAssertEqual(270, receipt.total())
    }

    func testRainCheckScheme() {
        let scheme = RainCheckScheme(targetName: "Beans", rainPrice: 150)
        let reg = Register(schemes: [scheme])
        reg.scan(Item(name: "Beans", priceEach: 200))
        reg.scan(Item(name: "Beans", priceEach: 200))
        let receipt = reg.total()
        // 2 beans = 400, rain check replaces one bean price to 150 => discount -50 => 350
        XCTAssertEqual(350, receipt.total())
    }

}
