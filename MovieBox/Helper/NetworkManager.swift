//
//  NetworkManager.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import Foundation
import Alamofire

enum HttpResponseError : Error {
    case incorrectParameters
    case unautorized
    case lackOfPermission
    case noPathExists
    case internalServerError
    case undefinedCode
    
    init?(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .incorrectParameters
        case 401:
            self = .unautorized
        case 403:
            self = .lackOfPermission
        case 404:
            self = .noPathExists
        case 500... :
            self = .internalServerError
        default :
            self = .undefinedCode
        }
    }
    
    var description : String {
        switch self {
        case .incorrectParameters:
            return "[400] Incorrect parameters or body assumed"
        case .unautorized:
            return "[401] Unautorized Request: Invalid access token"
        case .lackOfPermission:
            return "[403] Lack of permission: Check the user's permission"
        case .noPathExists:
            return "[404] No path exists: Confirm base url / path behind"
        case .internalServerError:
            return "[500] Internal server error: Check the server side notice"
        case .undefinedCode:
            return "[XXX] Undefined code: Check the response document"
        }
    }
}

enum MoviewRequest {
    case trending
    case search(query: String, page: Int)
    case credit(movieId: Int)
    case image(movieId: Int)
    
    var authorizationHeader: HTTPHeaders {
        return ["Authorization": "Bearer \(APIKeys.accessKey.rawValue)"]
    }
    
    var method: HTTPMethod { .get }
    
    var baseURL: String { Datasource.baseURL.rawValue }
    var currentAPIVersion: Int {3}
    
    var endpoint: URL {
        switch self {
        case .trending: return URL(string: baseURL + "\(currentAPIVersion)/"+"trending/movie/day?language=ko-KR&page=1" )!
        case .search(let query, let page): return URL(string: baseURL + "\(currentAPIVersion)/"+"search/movie?query=\(query)&include_adult=false&language=ko-KR&page=\(page)" )!
        case .credit(let movieId): return URL(string: baseURL + "\(currentAPIVersion)/"+"/movie/\(movieId)/credits?language=ko-KR")!
        case .image(let movieId) : return URL(string: baseURL + "\(currentAPIVersion)/"+"/movie/\(movieId)/images")!
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest<T: Codable>(
        apiKind : MoviewRequest,
        completionHandler: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(apiKind.endpoint, method: apiKind.method, headers: apiKind.authorizationHeader).responseDecodable(of: T.self) { response in
            completionHandler(response.result)
        }
    }
}
