//
//  ViewModel.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation

class ViewModel {
    
    var list: [Transformer] = []
    
    func create(_ transformer: Transformer) {
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
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func listTransformers() {
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]
        APIMAnager.requestData(path: "transformers", method: .get, parameters: nil, header: headers) { (result) in
            switch result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    let parsedData = try! decoder.decode(TransformersListResponse.self, from: data)
                    self.list = parsedData.transformers
                    print(parsedData.transformers.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(_ transformer: Transformer) {
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]
        var updateItem:Transformer? = nil
        if list.count > 0 {
            updateItem = list.first!
            updateItem?.name = "teste 2"
        }
        APIMAnager.requestData(path: "transformers", method: .put, parameters: updateItem!.toUpdateDictionary(), header: headers) { (result) in
            switch result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    let parsedData = try! decoder.decode(Transformer.self, from: data)
                    print("id: \(parsedData.id!)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func delete(id: String) {
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]
        if let transfomerId = self.list.first?.id {
            APIMAnager.requestData(path: "transformers/\(transfomerId)", method: .delete, parameters: nil, header: headers) { (result) in
                switch result {
                case .success(let data):
                    if let data = data {
                        print(String(data: data, encoding: .utf8))
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
