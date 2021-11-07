//
//  SeoulPriceModel.swift
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

struct SeoulPriceModel: Decodable {
    var dataId: Int
    var martId: Int
    var martName: String
    var itemId: Int
    var itemName: String
    var itemUnit: String
    var itemPrice: String
    var notes: String
    var researchDate: String
    var registrationDate: String
    var martTypeCode: String
    var martTypeName: String
    var guCode: String
    var guName: String
    
    enum CodingKeys: String, CodingKey {
        case dataId = "P_SEQ"
        case martId = "M_SEQ"
        case martName = "M_NAME"
        case itemId = "A_SEQ"
        case itemName = "A_NAME"
        case itemUnit = "A_UNIT"
        case itemPrice = "A_PRICE"
        case notes = "ADD_COL"
        case researchDate = "P_YEAR_MONTH"
        case registrationDate = "P_DATE"
        case martTypeCode = "M_TYPE_CODE"
        case martTypeName = "M_TYPE_NAME"
        case guCode = "M_GU_CODE"
        case guName = "M_GU_NAME"
    }
}

struct APIResponseModel: Decodable {
    var totalCount: Int
    var result: APIResultModel
    var prices: [SeoulPriceModel]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "list_total_count"
        case result = "RESULT"
        case prices = "row"
    }
}

struct ListNecessariesPricesService: Decodable {
    var apiResponse: APIResponseModel
    
    enum CodingKeys: String, CodingKey {
        case apiResponse = "ListNecessariesPricesService"
    }
}
