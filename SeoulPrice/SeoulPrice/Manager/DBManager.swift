//
//  DBManager.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2022/03/30.
//

import Foundation
import RealmSwift
import CommonCrypto

class DBManager {
    private let realm: Realm
    static let shared = DBManager()
    
    private init() {
        var config = Realm.Configuration.defaultConfiguration
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        let data = seoulPriceAPIKey.data(using: String.Encoding.utf8 , allowLossyConversion: true)
        let value =  data! as NSData
        CC_SHA512(value.bytes, CC_LONG(value.length), &digest)
        config.encryptionKey = Data(digest)
        
        do {
            realm = try Realm(configuration: config)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(_ object: Object) {
      try! realm.write {
        realm.add(object)
      }
    }
    
    func add(_ objects: [Object]) {
      try! realm.write {
        realm.add(objects)
      }
    }
    
    func addOrUpdate(_ objects: [Object]) {
      try! realm.write {
        realm.add(objects, update: .modified)
      }
    }
    
    func addOrUpdate(_ object: Object) {
      try? realm.write({
        realm.add(object, update: .modified)
      })
    }
    
    func remove(_ objects: [Object]) {
      objects.forEach { object in
        if !object.isInvalidated {
          try? realm.write {
            realm.delete(object)
          }
        }
      }
    }
    
    func remove(_ object: Object) {
      try? realm.write {
        realm.delete(object)
      }
    }
}

extension DBManager {
    func getAllSeoulPrice() -> [SeoulPriceModel] {
        return realm.objects(SeoulPriceModel.self).compactMap{$0}
    }
}
