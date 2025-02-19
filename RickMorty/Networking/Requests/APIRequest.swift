//
//  APIRequest.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation
import Alamofire

struct APIRequest<T: Codable, U: Codable> {
    let method: HTTPMethod
    let endpoint: String
    let queryParams: [String: String]?
    let headers: [String: String]?

    init(
        method: HTTPMethod,
        endpoint: String,
        queryParams: [String: String]? = nil,
        headers: [String: String]? = nil
    ) {
        self.method = method
        self.endpoint = endpoint
        self.queryParams = queryParams
        self.headers = headers
    }
}
