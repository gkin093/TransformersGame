//
//  DuelViewModel.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 10/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation

class DuelViewModel {
    var transformersList: [Transformer] = [] {
        didSet {
            autobotsList = transformersList.sorted(by: { $0.overallRating > $1.overallRating }).filter { $0.team == "A" }
            decepticonsList = transformersList.sorted(by: { $0.overallRating > $1.overallRating }).filter { $0.team == "D" }
            thereIsNoAutobots = autobotsList.count == 0
            thereIsNoDecepticon = decepticonsList.count == 0
            self.teamEqualizer()
            self.autobotsHasSpecials = (autobotsList.filter { $0.name.uppercased() == "OPTIMUS PRIME" || $0.name.uppercased() == "PREDAKING" }).count > 0
            self.deceptionsHasSpceials = (decepticonsList.filter { $0.name.uppercased() == "OPTIMUS PRIME" || $0.name.uppercased() == "PREDAKING" }).count > 0
            print(autobotsList)
        }
    }
    var autobotsList:[Transformer] = []
    var decepticonsList: [Transformer] = []
    var autobotsHasSpecials: Bool = false
    var deceptionsHasSpceials: Bool = false
    var thereIsNoAutobots: Bool = false
    var thereIsNoDecepticon: Bool = false
    var autobotsSurvivors: [Transformer] = []
    var decepticonsSurvivors: [Transformer] = []
    
    func teamEqualizer() {
        if autobotsList.count > decepticonsList.count {
            while autobotsList.count > decepticonsList.count {
                autobotsSurvivors.append(autobotsList.last!)
                autobotsList.removeLast()
            }
        } else {
            while autobotsList.count < decepticonsList.count {
                decepticonsSurvivors.append(decepticonsList.last!)
                decepticonsList.removeLast()
            }
        }
    }
    
    
    func fight()  -> FightResult {
        var decepticonsDestroyed = 0
        var autobotsDestroyed = 0
        
        if thereIsNoAutobots {
            return .decepticons
        } else if thereIsNoDecepticon {
            return .autobots
        } 
        
        if autobotsHasSpecials && !deceptionsHasSpceials {
            return .autobotsWithSpecials
        } else if autobotsHasSpecials && deceptionsHasSpceials {
            return .allDestroyed
        } else if !autobotsHasSpecials && deceptionsHasSpceials {
            return.decepticonsWithSpecials
        }
        
        for i in 0...autobotsList.count - 1 {
            let autobot = autobotsList[i]
            let decepticom = autobotsList[i]
            if autobot.courage <= decepticom.courage - 4 && autobot.strength <= decepticom.strength - 3 {
                autobotsDestroyed += 1
            } else if decepticom.courage <= autobot.courage - 4 && decepticom.strength <= autobot.strength - 3 {
                decepticonsDestroyed += 1
            } else if autobot.skill >= decepticom.skill + 3 {
                decepticonsDestroyed += 1
            } else if decepticom.skill >= autobot.skill + 3 {
                autobotsDestroyed += 1
            } else if autobot.overallRating > decepticom.overallRating {
                decepticonsDestroyed += 1
            } else if autobot.overallRating < decepticom.overallRating {
                autobotsDestroyed += 1
            } else {
                autobotsDestroyed += 1
                decepticonsDestroyed += 1
            }
        }
        
        if decepticonsDestroyed > autobotsDestroyed {
            return .autobots
        } else if decepticonsDestroyed < autobotsDestroyed {
            return .decepticons
        } else {
            return .draw
        }
    }
}

enum FightResult {
    case draw
    case decepticons
    case autobots
    case allDestroyed
    case autobotsWithSpecials
    case decepticonsWithSpecials
}
