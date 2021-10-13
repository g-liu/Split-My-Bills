//
//  Heap.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct Heap<Element> {
  typealias ComparisonFunction = (Element, Element) -> Bool
  var elements: [Element]
  let priorityFunction: ComparisonFunction // TODO: Replace with Comparable?
  
  var isEmpty: Bool {
    elements.isEmpty
  }
  
  var count: Int {
    elements.count
  }
  
  init(elements: [Element] = [], priorityFunction: @escaping ComparisonFunction) {
    self.elements = elements
    self.priorityFunction = priorityFunction
    buildHeap()
  }
  
  private mutating func buildHeap() {
    for index in (0..<count/2).reversed() {
      siftDown(elementAtIndex: index)
    }
  }
  
  func peek() -> Element? {
    elements.first
  }
  
  mutating func enqueue(_ element: Element) {
    elements.append(element)
    siftUp(elementAtIndex: count - 1)
  }
  
  mutating func dequeue() -> Element? {
    guard !isEmpty
    else { return nil }
    swapElement(at: 0, with: count - 1)
    let element = elements.removeLast()
    if !isEmpty {
      siftDown(elementAtIndex: 0)
    }
    return element
  }
  
  private func isRoot(_ index: Int) -> Bool {
    index == 0
  }
  
  private func leftChildIndex(of index: Int) -> Int {
    (2 * index) + 1
  }
  
  private func rightChildIndex(of index: Int) -> Int {
    (2 * index) + 2
  }
  
  private func parentIndex(of index: Int) -> Int {
    (index - 1) / 2
  }
  
  private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
    priorityFunction(elements[firstIndex], elements[secondIndex])
  }
  
  private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
    guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex) else {
      return parentIndex
    }
    return childIndex
  }
  
  private func highestPriorityIndex(for parent: Int) -> Int {
    highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
  }
  
  private mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
    guard firstIndex != secondIndex
    else { return }
    elements.swapAt(firstIndex, secondIndex)
  }
  
  private mutating func siftUp(elementAtIndex index: Int) {
    let parent = parentIndex(of: index)
    guard !isRoot(index),
          isHigherPriority(at: index, than: parent)
    else { return }
    swapElement(at: index, with: parent)
    siftUp(elementAtIndex: parent)
  }
  
  private mutating func siftDown(elementAtIndex index: Int) {
    let childIndex = highestPriorityIndex(for: index)
    if index == childIndex {
      return
    }
    swapElement(at: index, with: childIndex)
    siftDown(elementAtIndex: childIndex)
  }
}
