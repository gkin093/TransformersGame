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

protocol MainViewModelDelegate: class {
    func onErrorList()
}

class MainViewModel {
    private let hasTokenVariable: BehaviorRelay<APICallResult> = BehaviorRelay(value: .notCalled)
    var hasToken: Observable<APICallResult> {
        return hasTokenVariable.asObservable()
    }

    private let transformersListVariable: BehaviorRelay<[Transformer]> = BehaviorRelay(value: [])
    var transformersList: Observable<[Transformer]> {
        return transformersListVariable.asObservable()
    }

    var list: [Transformer] {
        return transformersListVariable.value
    }
    
    weak var delegate: MainViewModelDelegate?
    
    func generateToken() {
        if KeychainService.load(service: KeychainConstant.tokenKey) == nil {
            APIMAnager.requestData(path: "allspark", method: .get, parameters: nil, header: nil) { (result) in
                switch result {
                case .success(let data):
                    if let data = data, let token = String(data: data, encoding: .utf8) {
                        KeychainService.save(service: KeychainConstant.tokenKey, token: token as NSString)
                        self.hasTokenVariable.accept(.success)
                    }
                case .failure:
                    self.hasTokenVariable.accept(.error)
                }
            }
        } else {
            hasTokenVariable.accept(.notCalled)
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
                }
            case .failure(_):
                self.delegate?.onErrorList()
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
                if let _ = data {
                    self.listTransformers()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

enum APICallResult {
    case success
    case notCalled
    case error
}
