//
//  APIResultModel.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/10/01.
//

struct APIResultModel: Decodable {
    var code: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}
