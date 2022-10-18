//
//  NetworkService.swift
//  Currency-Exchange
//
//  Created on 12.10.2022.
//

import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Codable>(endPoint: EndPoint,
                             expecting: T.Type,
                             completion: @escaping (Result<T?, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    //MARK: - Internal -
    func request<T: Codable>(endPoint: EndPoint,
                             expecting: T.Type,
                             completion: @escaping (Result<T?, Error>) -> Void) {
        
        let fullURLString = EndPoint.fullURLString(for: endPoint)
        guard let url = URL(string: fullURLString) else {
            completion(.failure(RequestError.invalidURL))
            return
        }
        
        AF.request(url,
                   method: endPoint.method,
                   parameters: endPoint.parameters,
                   encoding: endPoint.encoding).responseJSON { response in
            guard let data = response.data else {
                if let error = response.error {
                    completion(.failure(error))
                } else {
                    completion(.failure(RequestError.invalidData))
                }
                return
            }
            
            do {
                let decodateData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodateData))
            } catch {
                completion(.failure(RequestError.invalidData))
            }
        }
    }
    private enum RequestError: String, Error {
        case invalidURL = "Invalid URL"
        case invalidData = "Invalid Data"
    }
}

