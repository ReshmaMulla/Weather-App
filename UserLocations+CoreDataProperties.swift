//
//  UserLocations+CoreDataProperties.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//
//

import Foundation
import CoreData


extension UserLocations {

    @nonobjc public class func fetchUserLocationRequest() -> NSFetchRequest<UserLocations> {
        return NSFetchRequest<UserLocations>(entityName: "UserLocations")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var location: String?

}
