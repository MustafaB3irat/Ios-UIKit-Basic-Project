//
//  Note+CoreDataProperties.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 04/06/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var user_id: Int16

}
