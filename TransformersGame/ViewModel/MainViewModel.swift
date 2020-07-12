//
//  ViewModel.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    private let hasTokenVariable = BehaviorRelay(value: false)
    var hasToken: Observable<Bool> {
        return hasTokenVariable.asObservable()
    }

    private let transformersListVariable: BehaviorRelay<[Transformer]> = BehaviorRelay(value: [])
    var transformersList: Observable<[Transformer]> {
        return transformersListVariable.asObservable()
    }

    var list: [Transformer] {
        return transformersListVariable.value
    }
    
    func generateToken() {
        if KeychainService.load(service: KeychainConstant.tokenKey) == nil {
            APIMAnager.requestData(path: "allspark", method: .get, parameters: nil, header: nil) { (result) in
                switch result {
                case .success(let data):
                    if let data = data, let token = String(data: data, encoding: .utf8) {
                        KeychainService.save(service: KeychainConstant.tokenKey, token: token as NSString)
                        self.hasTokenVariable.accept(true)
                    }
                case .failure:
                    self.hasTokenVariable.accept(false)
                }
            }
        } else {
            hasTokenVariable.accept(true)
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
                    self.transformersListVariable.accept(parsedData.transformers)
                    print(parsedData.transformers.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func delete(at indexPath: IndexPath) {
        let transformer = self.transformersListVariable.value[indexPath.row]
        self.delete(id: transformer.id ?? "")
    }
    
    func delete(id: String) {
        let token = KeychainService.load(service: KeychainConstant.tokenKey) as String?
        let headers = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "application/json"
        ]
        APIMAnager.requestData(path: "transformers/\(id)", method: .delete, parameters: nil, header: headers) { (result) in
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
