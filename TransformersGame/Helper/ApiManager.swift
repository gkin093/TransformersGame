//
//  ApiManager.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 08/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIMAnager {
    static let baseUrl = "https://transformers-api.firebaseapp.com/"
    
    typealias parameters = [String : Any]
    typealias headers = [String : String]
    
    enum ApiResult {
        case success(Data?)
        case failure(RequestError)
    }
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationHeaderFormatError
        case authorizationError
        case invalidRequest
        case notFound
        case serverError
    }
    
    static func requestData(path: String, method: HTTPMethod, parameters: parameters?, header: headers?, completion: @escaping (ApiResult) -> Void) {
        guard let url = URL(string: baseUrl + path) else {
            completion(ApiResult.failure(.notFound))
            return
        }
        do {
            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            urlRequest.allHTTPHeaderFields = header
            if let parameters = parameters {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.httpBody = jsonData
            }
            urlRequest.httpMethod = method.rawValue
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(ApiResult.failure(.connectionError))
                } else if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        completion(ApiResult.success(data))
                    case 401:
                        completion(ApiResult.failure(.authorizationHeaderFormatError))
                    case 403:
                        completion(ApiResult.failure(.authorizationError))
                    case 404:
                        completion(ApiResult.failure(.notFound))
                    case 500...599:
                        completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                    }
                }
            }.resume()
        } catch {
            completion(ApiResult.failure(.invalidRequest))
        }
    }
}
