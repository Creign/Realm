//
//  Category.swift
//  RealmEx
//
//  Created by Excell on 14/11/2018.
//  Copyright © 2018 Excell. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
