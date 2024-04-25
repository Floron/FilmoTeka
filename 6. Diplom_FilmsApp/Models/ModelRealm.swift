//
//  ModelRealm.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 20.04.2024.
//

import Foundation
import RealmSwift

class RealmService {
 
    private init(){}
     
    static let shared = RealmService()
    var rm = try! Realm()
    var usefulConnections: Results<ModelForCollectionView>!
    
    func create<T: Object>(_ object: T){
      do{
        try rm.write{
          rm.add(object)
        }
      }catch{
        print("Cant create: \(error.localizedDescription)")
      }
    }
    
    func update<T: Object>(_ object: T, dictionary: [String: Any?]){
        do {
            try rm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("Cant update: \(error.localizedDescription)")
        }
    }
   
    /*
    func searchPerson(userCardId: String, userCardPin: Int) -> Bool {
        let realm = RealmService.shared.rm
        usefulConnections = realm.objects(BankUserModel.self)
        
        for person in usefulConnections {
            if person.userCardId == userCardId && person.userCardPin == userCardPin {
                return true
            }
        }
        return false
    }
    
    func getPersonData (cardNumber: String, PINcode: Int) -> BankUserModel? {
        for person in usefulConnections {
            if person.userCardId == cardNumber && person.userCardPin == PINcode {
                return person
            }
        }
        return nil
    }
    */
}
