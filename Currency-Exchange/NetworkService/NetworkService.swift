//
//  NetworkService.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
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
                   encoding: endPoint.encoding).responseJSON { [weak self] response in
            guard let data = response.data else {
                if let error = response.error {
                    completion(.failure(error))
                } else {
                    completion(.failure(RequestError.invalidData))
                }
                return
            }
            
            let result = self?.parseJson(data, expecting: expecting)
            completion(.success(result))
        }
    }
    
    //MARK: - Private -
    private func parseJson<T: Codable>(_ data: Data,
                                       expecting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expecting, from: data)
            return decodateData
        } catch {
            return nil
        }
    }
    
    private enum RequestError: Error {
        case invalidURL
        case invalidData
    }
}

