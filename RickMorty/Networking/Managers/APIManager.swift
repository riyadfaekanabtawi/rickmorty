//
//  APIManager.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation
import Alamofire

class APIManager: APIManagerProtocol {
    static let shared = APIManager()

    func request<T: Codable, U: Codable>(
        apiRequest: APIRequest<T, U>
    ) async throws -> U {
        let url = "https://rickandmortyapi.com/api/" + apiRequest.endpoint
        let queryParameters = apiRequest.queryParams ?? [:]
        let request = AF.request(
            url,
            method: apiRequest.method,
            parameters: queryParameters,
            headers: HTTPHeaders(apiRequest.headers ?? [:])
        )
        .validate()
        return try await withCheckedThrowingContinuation { continuation in
            request.responseDecodable(of: U.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
