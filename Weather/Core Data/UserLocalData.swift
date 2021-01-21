//
//  UserLocalData.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import Foundation
import CoreData
import UIKit
struct UserLocalData {
    func createContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       return appDelegate.persistentContainer.viewContext
    }
   func saveUserData(userLoc: UserLocation, with complition: okComplition) {
        let context = createContext()
         let entity = NSEntityDescription.entity(forEntityName: "UserLocations", in: context)
               let userlocations = NSManagedObject(entity: entity!, insertInto: context) as? UserLocations
        userlocations?.location = userLoc.address
         userlocations?.latitude = userLoc.lattitude
         userlocations?.longitude = userLoc.longtitude
        do {
           try context.save()
           complition(true)
          } catch {
           print("Failed saving")
             complition(false)
        }
    }
    func getUserBookedLocation() -> [UserLocations]?{
         let context = createContext()
        let request = UserLocations.fetchUserLocationRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            return []
        }
    }
    func deleteUserBookedLocation(deleteLocation: UserLocations, with complition: okComplition){
         let context = createContext()
        context.delete(deleteLocation)
        do {
            try context.save()
            complition(true)
        } catch _ {
            complition(false)
        }
    }
}
