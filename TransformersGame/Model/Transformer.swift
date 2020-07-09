//
//  TransformerResponse.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation

class Transformer: Codable {
    let id: String?
    var name: String
    var strength: Int
    var intelligence: Int
    var speed: Int
    var endurance: Int
    var rank: Int
    var courage: Int
    var firepower: Int
    var skill: Int
    var team: String
    var team_icon: String?
    
    init(name: String, strength: Int, intelligence: Int, speed: Int, endurance: Int, rank: Int, courage: Int, firepower: Int, skill: Int, team: String) {
        self.name = name
        self.strength = strength
        self.intelligence = intelligence
        self.speed = speed
        self.endurance = endurance
        self.rank = rank
        self.courage = courage
        self.firepower = firepower
        self.skill = skill
        self.team = team
        self.id = nil
        self.team_icon = nil
    }
    
    func toCreateDictionary() -> [String : Any] {
        return [
            "name": self.name,
            "strength": self.strength,
            "intelligence": self.intelligence,
            "speed": self.speed,
            "endurance": self.endurance,
            "rank": self.rank,
            "courage": self.courage,
            "firepower": self.firepower,
            "skill": self.skill,
            "team": self.team
        ]
    }
    
    func toUpdateDictionary() -> [String : Any] {
        return [
            "id": self.id,
            "name": self.name,
            "strength": self.strength,
            "intelligence": self.intelligence,
            "speed": self.speed,
            "endurance": self.endurance,
            "rank": self.rank,
            "courage": self.courage,
            "firepower": self.firepower,
            "skill": self.skill,
            "team": self.team
        ]
    }
}
