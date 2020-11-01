//
//  UniqueQueie.swift
//  Localizations
//
//  Created by Пламен Великов on 3/20/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

/**
  Implementation of Queue with unique elements. Queue uses FIFO (First-In, First-Out) structure.
 Also handles the uniqueness and orderness of the elements. This means that each element in the queue will be
 unique and the order in which they appear will be preserved.
 */
public struct UniqueQueue<T: Equatable> {
    
    //Data items
    private var uniqueOrderedCollection: [T] = []
    
    public init() { }
    
    /**
     Inserts element at the end of the queue. 
     If element is already in collection it's moved at the end of the queue.
     */
    public mutating func insert(_ element: T) {
        if containsElement(element) {
            //remove it in order to be able to append it at the end
            removeItem(element)
            
        }
        uniqueOrderedCollection.append(element)
    }
    
    /**
     Retrieves and removes the head element of the queue. If queue has no elements nil is returned
     
     - returns: The elements in the order of their insertion. If there are no elements, nil is returned
     */
    public mutating func poll() -> T? {
        guard let headElement = peek() else { return nil }
        
        removeItem(headElement)
        return headElement
    }
    
    /**
     Retrieves but doesn't remove the head element of the queue. If queue has no elements nil is returned
     
     - returns: The head element. If there are no elements, nil is returned
     */
    public func peek() -> T? {
        return uniqueOrderedCollection.first
    }
    
    /**
      Remove all elements from the queue
     */
    public mutating func clearAllTasks() {
        uniqueOrderedCollection.removeAll()
    }
    
    public func containsElement(_ element: T) -> Bool {
        
        return uniqueOrderedCollection.contains(element)
    }
    
    private mutating func removeItem(_ element: T) {
        guard let index = uniqueOrderedCollection.index(of: element) else { return }
        uniqueOrderedCollection.remove(at: index)
    }
}
