//
//  SplashScreenViewModel.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SplashScreenViewModel {
    private let hasTokenVariable = BehaviorRelay(value: false)
    var hasToken: Observable<Bool> {
        return hasTokenVariable.asObservable()
    }
    
    func generateToken() {
        if KeychainService.load(service: KeychainConstant.tokenKey) == nil {
            APIMAnager.requestData(path: "allspark", method: .get, parameters: nil, header: nil) { (result) in
                switch result {
                case .success(let data):
                    if let data = data, let token = String(data: data, encoding: .utf8) {
                        print(token)
                        KeychainService.save(service: KeychainConstant.tokenKey, token: token as NSString)
                        self.hasTokenVariable.accept(true)
                    }
                case .failure(let error):
                    self.hasTokenVariable.accept(false)
                    print(error)
                }
            }
        } else {
            sleep(2)
            hasTokenVariable.accept(true)
        }
    }
}
