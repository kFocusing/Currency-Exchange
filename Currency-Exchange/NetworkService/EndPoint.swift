//
//  EndPoint.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import Alamofire

//MARK: EndPointConstants
private struct EndPointConstants {
    static let baseURL = "http://api.evp.lt/currency/commercial"
    static let tail = "/latest"
}

//MARK: EndPoint
enum EndPoint {
    case convertCurrency(fromAmount: Double,
                         fromCurrency: String,
                         toCurrency: String)
    
    var path: String {
        switch self {
        case let .convertCurrency(fromAmount, fromCurrency, toCurrency):
            return "/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default: return URLEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    static func fullURLString(for endpoint: EndPoint) -> String {
        return String(format: "%@%@%@",
                      EndPointConstants.baseURL,
                      endpoint.path,
                      EndPointConstants.tail)
    }
}
