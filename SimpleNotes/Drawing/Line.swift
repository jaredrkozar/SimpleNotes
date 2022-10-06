//
//  Line.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public struct Line: Equatable {
    var color: UIColor
    var width: Double
    var opacity: Double
    var path: UIBezierPath
    var type: DrawingType
    var strokeType: StrokeTypes?

    enum CodingKeys: CodingKey {
        case color
        case width
        case opacity
        case path
        case type
        case strokeType
    }
}

enum DrawingType {
    case drawing
    case text
}

extension KeyedEncodingContainer {
    func encode(path: CGPath) -> Data {
        var elements = [PathElement]()
        
        path.applyWithBlock() { elem in
            let elementType = elem.pointee.type
            let n = numPoints(forType: elementType)
            var points: Array<CGPoint>?
            if n > 0 {
                points = Array(UnsafeBufferPointer(start: elem.pointee.points, count: n))
            }
            elements.append(PathElement(type: Int(elementType.rawValue), points: points))
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(elements)
        } catch {
            return Data()
        }
    }
}

func numPoints(forType type: CGPathElementType) -> Int
{
    var n = 0
    
    switch type {
    case .moveToPoint:
        n = 1
    case .addLineToPoint:
        n = 1
    case .addQuadCurveToPoint:
        n = 2
    case .addCurveToPoint:
        n = 3
    case .closeSubpath:
        n = 0
    default:
        n = 0
    }
    
    return n
}


struct PathElement: Codable {
    var type: Int
    var points: Array<CGPoint>?
}
