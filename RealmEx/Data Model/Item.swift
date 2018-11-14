//
//  Item.swift
//  RealmEx
//
//  Created by Excell on 14/11/2018.
//  Copyright © 2018 Excell. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
