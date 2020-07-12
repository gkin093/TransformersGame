//
//  TransformersGameTests.swift
//  TransformersGameTests
//
//  Created by Gustavo Kin on 08/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import XCTest
@testable import TransformersGame

class TransformersGameTests: XCTestCase {
    var viewModel: DuelViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = DuelViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDuelAutobotsWin() {
        let autobotOne = Transformer(name: "Autobot", strength: 10, intelligence: 5, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 5, skill: 10, team: "A")
        let decepticonOne = Transformer(name: "Decepticon", strength: 5, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 5, firepower: 10, skill: 10, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.autobots)
    }

    func testDuelDecepticonsWin() {
        let autobotOne = Transformer(name: "Autobot", strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 6, team: "A")
        let decepticonOne = Transformer(name: "Decepticon", strength: 10, intelligence: 6, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.decepticons)
    }
    
    func testDuelDraw() {
        let autobotOne = Transformer(name: "Autobot", strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10, team: "A")
        let decepticonOne = Transformer(name: "Decepticon", strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.draw)
    }
    
    func testDuelAutobotWinWithSpecial() {
        let autobotOne = Transformer(name: "Optimus Prime", strength: 0, intelligence: 0, speed: 0, endurance: 0, rank: 0, courage: 0, firepower: 5, skill: 0, team: "A")
        let decepticonOne = Transformer(name: "Decepticon", strength: 5, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 5, firepower: 10, skill: 10, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.autobotsWithSpecials)
    }
    
    func testDuelDecepticonWinWithSpecial() {
        let autobotOne = Transformer(name: "Autobot", strength: 10, intelligence: 5, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 5, skill: 10, team: "A")
        let decepticonOne = Transformer(name: "Predaking", strength: 0, intelligence: 0, speed: 0, endurance: 0, rank: 0, courage: 0, firepower: 0, skill: 0, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.decepticonsWithSpecials)
    }
    
    func testDuelAllDestroyed() {
        let autobotOne = Transformer(name: "Optimus Prime", strength: 10, intelligence: 5, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 5, skill: 10, team: "A")
        let decepticonOne = Transformer(name: "Predaking", strength: 5, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 5, firepower: 10, skill: 10, team: "D")
        let transformers = [autobotOne, decepticonOne]
        viewModel.transformersList = transformers
        let result = viewModel.fight()
        XCTAssertEqual(result, FightResult.allDestroyed)
    }
}
