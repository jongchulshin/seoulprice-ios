//
//  SeoulPriceModel.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/10/01.
//

import RealmSwift

struct ResultModel: Decodable {
    var code: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

class SeoulPriceModel: Object, Decodable {
    @Persisted var dataId: Int = 0
    @Persisted var martId: Int = 0
    @Persisted var martName: String = ""
    @Persisted var itemId: Int = 0
    @Persisted var itemName: String = ""
    @Persisted var itemUnit: String = ""
    @Persisted var itemPrice: String = ""
    @Persisted var notes: String = ""
    @Persisted var researchDate: String = ""
    @Persisted var registrationDate: String = ""
    @Persisted var martTypeCode: String = ""
    @Persisted var martTypeName: String = ""
    @Persisted var guCode: String = ""
    @Persisted var guName: String = ""
    
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
    
    override class func primaryKey() -> String? {
      return "dataId"
    }
}

struct APIResponseModel: Decodable {
    var totalCount: Int
    var result: ResultModel
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
