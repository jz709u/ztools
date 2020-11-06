import Foundation

extension Collection where Element: Equatable {
  func incrementIndexUntilUniqueValue(index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(after: &index)
    } while index < endIndex && self[prev] == self[index]
  }
}

extension BidirectionalCollection where Element: Equatable {
  func decrementIndexUntilUnique(index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(before: &index)
    } while index > startIndex && self[prev] == self[index]
  }
}

struct Algorithm {
    /**
     Sliding Window where
     - Left Index represents the begginning and the rightIndex the end
     - middle index is incremented within the window checking every combination.
     
     1. we begin by adding the sum of the beginning middle and right to see if it adds to target
     2. if so then add to solutions and increment middleIndex
    
     */
    static func threeSum<T: BidirectionalCollection>(_ collection: T,
                                              target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
        
        let sorted = collection.sorted()
        var solution = [[T.Element]]()
        
        func threeSum() {
            var leftIndex = sorted.startIndex
            while leftIndex < sorted.endIndex {
                var middleIndex = sorted.index(after: leftIndex)
                var rightIndex = sorted.index(before: sorted.endIndex)
                twoSum(leftIndex: &leftIndex, middleIndex: &middleIndex, rightIndex: &rightIndex)
                sorted.incrementIndexUntilUniqueValue(index: &leftIndex)
            }
        }
        
        func twoSum(leftIndex: inout Int,  middleIndex: inout Int, rightIndex: inout Int) {
            while middleIndex < rightIndex && rightIndex < sorted.endIndex {
                let sum = sorted[leftIndex] + sorted[middleIndex] + sorted[rightIndex]
                switch sum {
                case target:
                    solution.append([sorted[leftIndex], sorted[middleIndex], sorted[rightIndex]])
                    sorted.incrementIndexUntilUniqueValue(index: &middleIndex)
                    sorted.decrementIndexUntilUnique(index: &rightIndex)
                case let sum where sum < target:
                    sorted.incrementIndexUntilUniqueValue(index: &middleIndex)
                default:
                    sorted.decrementIndexUntilUnique(index: &rightIndex)
                }
            }
        }
        
        threeSum()
      
        return solution
    }
}


/**
 You are given an array of **distinct integers** arr and an array of integer arrays pieces,
 where the **integers in pieces are distinct**. Your goal is to form arr by concatenating the arrays in pieces in any order. However, you are not allowed to reorder the integers in each array pieces[i].
 */

/// Tricks:
/// - hash map to preprocess because it takes no time to access
/// - can use binary search on the sorted array of pieces based on their first item.
struct CheckArrayFormationThroughConcatenation {
    
    class Solution {
        
        func canFormArray(_ arr: [Int], _ pieces:  [[Int]]) -> Bool {
            
            var start = arr.startIndex
            
            // using map rocks to be able to reference things fast
            var map = [Int: [Int]]()
            pieces.forEach({ map[$0[0]] = $0 })
            
            // while loop doesnt mean n times for instance if a piece is not found
            // it will immediately return at constant time
            while (start < arr.endIndex) {
                // find the piece
                guard let foundPiece = map[arr[start]] else { return false }
                
                // loop over piece
                for part in foundPiece {
                    if (arr[start] != part || start >= arr.endIndex) { return false }
                    start += 1
                }
            }
            
            return true
        }
    }

    
    static func start() {
        let array = [1,2,3,10,22]
        let pieces = [[1,2], [3,10], [22]]
        print(Solution().canFormArray(array, pieces))
    }
}

struct BinarySearch {
    
    class Solution {
        
        func binarySearch<T: Comparable> (_ a: [T], key: T) -> Int? {
            var lowerBound = 0
            var upperBound = a.endIndex
            while (lowerBound < upperBound) {
                let midIndex = lowerBound + (upperBound - lowerBound) / 2
                if a[midIndex] == key {
                    return midIndex
                } else if (a[midIndex] < key) {
                    lowerBound = midIndex + 1
                } else {
                    upperBound = midIndex
                }
            }
            return nil
        }
    }
    
    static func start() {
        Solution().binarySearch([1,2,3,4,2,3,100], key: 100)
    }
}

struct MyBinarySearch {
    class Solution{
        func binarySearch<T: Comparable>( array: [T], key: T) -> Int? {
            var lowerBounds = 0
            var upperBounds = array.count
            
            while (lowerBounds < upperBounds) {
                let midIndex = lowerBounds + (upperBounds - lowerBounds) / 2
                
                switch array[midIndex] {
                case key:
                    return midIndex
                case (let value) where value < key:
                    lowerBounds = midIndex + 1
                default:
                    upperBounds = midIndex
                }
            }
            return nil
        }
    }
    
    static func start() {
        Solution().binarySearch(array: [1,2,3,4,100], key: 100)
    }
}

