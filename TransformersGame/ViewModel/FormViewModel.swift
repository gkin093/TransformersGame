//
//  FormViewModel.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 10/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum SubimmitStatus {
    case saved
    case notSaved
    case notSubmmited
}

class FormViewModel {
    var transformer: Transformer?
    private let teamsVariable: BehaviorRelay<[Team]> = BehaviorRelay(value: [.autobots, .decepticons])
    var teams: Observable<[Team]> {
        return teamsVariable.asObservable()
    }
    
    private let submmitStatusVariable = BehaviorRelay(value: SubimmitStatus.notSubmmited)
    var submmitStatus: Observable<SubimmitStatus> {
        return submmitStatusVariable.asObservable()
    }
    
    func getSelectedTeam(_ value: Int) -> String {
        let team = teamsVariable.value[value]
        return team.valueOfTeam()
    }
    
    func createChar(transformer: Transformer) {
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]
        
        APIMAnager.requestData(path: "transformers", method: .post, parameters: transformer.toCreateDictionary(), header: headers) { (result) in
            switch result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    let parsedData = try! decoder.decode(Transformer.self, from: data)
                    print("id: \(parsedData.id!)")
                    self.submmitStatusVariable.accept(.saved)
                }
            case .failure(let error):
                self.submmitStatusVariable.accept(.notSaved)
                print(error)
            }
        }
    }
    
    func updateChar() {
        guard let transformer = self.transformer else { return }
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]

        APIMAnager.requestData(path: "transformers", method: .put, parameters: transformer.toUpdateDictionary(), header: headers) { (result) in
            switch result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    let parsedData = try! decoder.decode(Transformer.self, from: data)
                    print("id: \(parsedData.id!)")
                    self.submmitStatusVariable.accept(.saved)
                }
            case .failure(let error):
                self.submmitStatusVariable.accept(.notSaved)
                print(error)
            }
        }
    }
}
