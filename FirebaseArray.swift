//
//  FirebaseArray.swift
//  Ransom
//
//  Created by deast on 5/13/15.
//  Copyright (c) 2015 davideast. All rights reserved.
//

@objc protocol FirebaseArrayDelegate {
  optional func list(list: [FDataSnapshot], indexAdded: Int, data: FDataSnapshot)
  optional func list(list: [FDataSnapshot], indexChanged: Int, data: FDataSnapshot)
  optional func list(list: [FDataSnapshot], indexRemoved: Int, data: FDataSnapshot)
  optional func list(list: [FDataSnapshot], oldIndex: Int, newIndex: Int, data: FDataSnapshot)
}

class FirebaseArray {
  
  var list: [FDataSnapshot]!
  var ref: Firebase!
  var delegate: FirebaseArrayDelegate?
  
  init(ref: Firebase) {
    list = []
    self.ref = ref
    self.sync()
  }
  
  func sync() {
    initializeListeners()
  }
  
  func stopSyncing() {
    ref.removeAllObservers()
  }
  
  func initializeListeners() {
    addListenerWithPrevKey(FEventType.ChildAdded, method: serverAdd)
    addListenerWithPrevKey(FEventType.ChildMoved, method: serverMove)
    addListener(FEventType.ChildChanged, method: serverChange)
    addListener(FEventType.ChildRemoved, method: serverRemove)
  }
  
  func addListener(event: FEventType, method: (FDataSnapshot!) -> Void) {
    ref.observeEventType(event, withBlock: method)
  }
  
  func addListenerWithPrevKey(event: FEventType, method: (FDataSnapshot!, String?) -> Void) {
    ref.observeEventType(event, andPreviousSiblingKeyWithBlock: method)
  }
  
  func serverAdd(snap: FDataSnapshot!, prevKey: String?) {
    var position = moveTo(snap.key, data: snap, prevKey: prevKey)
    delegate?.list?(list, indexAdded: position, data: snap)
  }
  
  func serverChange(snap: FDataSnapshot!) {
    var position = findKeyPosition(snap.key)
    if let position = position {
      list[position] = snap
      delegate?.list?(list, indexChanged: position, data: snap)
    }
  }
  
  func serverRemove(snap: FDataSnapshot!) {
    var position = findKeyPosition(snap.key)
    if let position = position {
      list.removeAtIndex(position)
      delegate?.list?(list, indexRemoved: position, data: snap)
    }
  }
  
  func serverMove(snap: FDataSnapshot!, prevKey: String?) {
    var key = snap.key
    var oldPosition = findKeyPosition(key)
    if let oldPosition = oldPosition {
      var data = list[oldPosition]
      list.removeAtIndex(oldPosition)
      var newPosition = moveTo(key, data: data, prevKey: prevKey)
      delegate?.list?(list, oldIndex: oldPosition, newIndex: newPosition, data: snap)
    }
  }

  func moveTo(key: String, data: FDataSnapshot, prevKey: String?) -> Int {
    var position = placeRecord(key, prevKey: prevKey)
    list.insert(data, atIndex: position)
    return position
  }
  
  func placeRecord(key: String, prevKey: String?) -> Int {
    
    if let prevKey = prevKey {
      var i = findKeyPosition(prevKey)
      if let i = i {
        return i + 1
      } else {
        return list.count
      }
    } else {
      return 0
    }
    
  }
  
  func findKeyPosition(key: String) -> Int? {
    for var i = 0; i < list.count; i++ {
      var item = list[i]
      if item.key == key {
        return i
      }
    }
    return nil
  }
  
  func dispose() {
    stopSyncing()
    list.removeAll(keepCapacity: false)
  }
  
}