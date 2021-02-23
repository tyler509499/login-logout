//
//  ModelData.swift
//  login-logout
//
//  Created by Galkov Nikita on 22.02.2021.
//

import Foundation

class CodableModel {
    
    struct loginResponse: Codable {
        var success: String
        var response: Token
    }
    struct Token: Codable {
        var token: String
    }
    
    
    struct PaymentsResponse: Codable {
        var success : String
        var response: [Payments]
    }
    
    struct Payments: Codable {
        var desc: String
        var amount: Amount
        var currency: String?
        var created: Double
    }
    
    enum Amount: Codable {
        case double(Double)
        case string(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Double.self) {
                self = .double(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(Amount.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Amount"))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .double(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }
}
