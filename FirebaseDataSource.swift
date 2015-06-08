//
//  FirebaseDataSource.swift
//  OfflineQueries
//
//  Created by deast on 5/25/15.
//  Copyright (c) 2015 davideast. All rights reserved.
//

import Foundation
import UIKit

@objc protocol FirebaseDataSourceDelegate {
  optional func dataSource(dataSource: FirebaseDataSource, itemAddedAtIndexPath: NSIndexPath, data: FDataSnapshot)
  optional func dataSource(dataSource: FirebaseDataSource, itemChangedAtIndexPath: NSIndexPath, data: FDataSnapshot)
  optional func dataSource(dataSource: FirebaseDataSource, itemRemovedAtIndexPath: NSIndexPath, data: FDataSnapshot)
  optional func dataSource(dataSource: FirebaseDataSource, itemMovedAtIndexPath: NSIndexPath, toIndexPath: NSIndexPath, data: FDataSnapshot)
}

class FirebaseDataSource: NSObject, FirebaseArrayDelegate {
  
  private var syncArray: FirebaseArray
  var delegate: FirebaseDataSourceDelegate?
  
  var count: Int {
    return syncArray.list.count
  }
  
  var list: [FDataSnapshot] {
    return syncArray.list
  }
  
  init(ref: Firebase) {
    syncArray = FirebaseArray(ref: ref)
    super.init()
    syncArray.delegate = self
  }

  func list(list: [FDataSnapshot], indexAdded: Int, data: FDataSnapshot) {
    var path = createNSIndexPath(indexAdded)
    delegate?.dataSource?(self, itemAddedAtIndexPath: path, data: data)
  }
  
  func list(list: [FDataSnapshot], indexChanged: Int, data: FDataSnapshot) {
    var path = createNSIndexPath(indexChanged)
    delegate?.dataSource?(self, itemChangedAtIndexPath: path, data: data)
  }
  
  func list(list: [FDataSnapshot], indexRemoved: Int, data: FDataSnapshot) {
    var path = createNSIndexPath(indexRemoved)
    delegate?.dataSource?(self, itemRemovedAtIndexPath: path, data: data)
  }

  func list(list: [FDataSnapshot], oldIndex: Int, newIndex: Int, data: FDataSnapshot) {
    var oldPath = createNSIndexPath(oldIndex)
    var newPath = createNSIndexPath(newIndex)
    delegate?.dataSource?(self, itemMovedAtIndexPath: oldPath, toIndexPath: newPath, data: data)
  }

  func createNSIndexPath(forItem: Int, inSection: Int = 0) -> NSIndexPath {
    return NSIndexPath(forItem: forItem, inSection: inSection)
  }
  
}
