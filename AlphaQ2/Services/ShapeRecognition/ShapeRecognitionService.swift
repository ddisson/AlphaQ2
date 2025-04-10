import SwiftUI

/// Service responsible for basic shape recognition for Level 3.
struct ShapeRecognitionService {

    // Configuration
    private let numberOfSamplePoints = 20 // How many points to sample on the reference path
    private let coverageToleranceMultiplier: CGFloat = 1.5 // How close drawing needs to be (relative to line width)

    /// Attempts to recognize if the drawn lines match the reference path.
    /// - Parameters:
    ///   - lines: The lines drawn by the user.
    ///   - referencePath: The target shape path (e.g., `letterData.tracePath`).
    /// - Returns: A percentage (0-100) indicating the match quality based on covered sample points.
    func recognizeShape(lines: [Line], referencePath: Path) -> Double {
        guard !lines.isEmpty, !referencePath.isEmpty else { return 0.0 }

        // 1. Sample points along the reference path
        let samplePoints = samplePointsAlongPath(path: referencePath, count: numberOfSamplePoints)
        guard !samplePoints.isEmpty else { return 0.0 } // Path might be too simple or sampling failed

        // 2. Count how many sample points are covered by the user's drawing
        var coveredPoints = 0
        for point in samplePoints {
            if isPointCoveredByDrawing(point: point, lines: lines) {
                coveredPoints += 1
            }
        }

        // 3. Calculate percentage
        let percentage = (Double(coveredPoints) / Double(samplePoints.count)) * 100.0
        print("Shape Recognition: Sample Points=\(samplePoints.count), Covered=\(coveredPoints), Percentage=\(percentage)%")
        return percentage
    }

    // MARK: - Path Sampling Helper

    /// Samples approximately equidistant points along a given path.
    /// NOTE: This is a simplified implementation. Accurate, equidistant sampling
    /// along complex curves requires more sophisticated geometry calculations.
    private func samplePointsAlongPath(path: Path, count: Int) -> [CGPoint] {
        guard count > 0 else { return [] }
        
        var points: [CGPoint] = []
        let totalLength = path.length // Needs a helper to estimate path length
        guard totalLength > 0 else { return path.currentPoint.map { [$0] } ?? [] } // Return start point if length is 0
        
        let segmentLength = totalLength / CGFloat(count)
        var distanceRemaining = segmentLength / 2 // Start halfway into the first segment
        var currentPoint = path.currentPoint ?? .zero // Track position
        var firstPoint: CGPoint? = nil
        
        path.forEach { element in
            switch element {
            case .move(to: let p):
                currentPoint = p
                firstPoint = p
                // Add start point if only 1 sample needed?
                if count == 1 && points.isEmpty { points.append(p) }
            case .line(to: let p):
                let segmentVector = CGPoint(x: p.x - currentPoint.x, y: p.y - currentPoint.y)
                let segmentLen = distancePoints(p1: .zero, p2: segmentVector) // Faster than distancePoints(p1,p2)
                
                while distanceRemaining <= segmentLen && points.count < count {
                    let fraction = distanceRemaining / segmentLen
                    let sample = CGPoint(x: currentPoint.x + fraction * segmentVector.x,
                                         y: currentPoint.y + fraction * segmentVector.y)
                    points.append(sample)
                    distanceRemaining += segmentLength
                }
                distanceRemaining -= segmentLen
                currentPoint = p
            case .quadCurve(to: let p, control: let cp):
                // VERY simple approximation: treat as line for length/sampling
                let segmentVector = CGPoint(x: p.x - currentPoint.x, y: p.y - currentPoint.y)
                let segmentLen = distancePoints(p1: .zero, p2: segmentVector)
                 while distanceRemaining <= segmentLen && points.count < count {
                     let fraction = distanceRemaining / segmentLen
                     let sample = CGPoint(x: currentPoint.x + fraction * segmentVector.x,
                                          y: currentPoint.y + fraction * segmentVector.y)
                     points.append(sample)
                     distanceRemaining += segmentLength
                 }
                 distanceRemaining -= segmentLen
                 currentPoint = p
            case .curve(to: let p, control1: _, control2: _):
                // VERY simple approximation: treat as line for length/sampling
                let segmentVector = CGPoint(x: p.x - currentPoint.x, y: p.y - currentPoint.y)
                let segmentLen = distancePoints(p1: .zero, p2: segmentVector)
                 while distanceRemaining <= segmentLen && points.count < count {
                     let fraction = distanceRemaining / segmentLen
                     let sample = CGPoint(x: currentPoint.x + fraction * segmentVector.x,
                                          y: currentPoint.y + fraction * segmentVector.y)
                     points.append(sample)
                     distanceRemaining += segmentLength
                 }
                 distanceRemaining -= segmentLen
                 currentPoint = p
            case .closeSubpath:
                guard let start = firstPoint else { break }
                 let segmentVector = CGPoint(x: start.x - currentPoint.x, y: start.y - currentPoint.y)
                 let segmentLen = distancePoints(p1: .zero, p2: segmentVector)
                 while distanceRemaining <= segmentLen && points.count < count {
                     let fraction = distanceRemaining / segmentLen
                     let sample = CGPoint(x: currentPoint.x + fraction * segmentVector.x,
                                          y: currentPoint.y + fraction * segmentVector.y)
                     points.append(sample)
                     distanceRemaining += segmentLength
                 }
                 distanceRemaining -= segmentLen
                 currentPoint = start
            }
        }
        
        // Add final point if needed and not enough samples collected
        if points.count < count {
            // Determine the last known point safely
            let lastKnownPoint = path.currentPoint ?? currentPoint
            // Directly use lastKnownPoint as it's guaranteed to be non-nil here
            let lastPoint = lastKnownPoint
            if points.isEmpty || distancePoints(p1: points.last!, p2: lastPoint) > 1e-6 { // Avoid duplicates
                points.append(lastPoint)
            }
         }
         
        // Ensure we return exactly `count` points if possible (might be less if path is short)
        return Array(points.prefix(count))
    }
    
    // MARK: - Coverage Check Helper

    /// Checks if a given point is covered by the user's drawn lines.
    private func isPointCoveredByDrawing(point: CGPoint, lines: [Line]) -> Bool {
        for line in lines {
            let minimumDistance = (line.lineWidth / 2) * coverageToleranceMultiplier + 2 // Generous tolerance
            var previousPoint = line.points.first

            for currentPoint in line.points.dropFirst() {
                guard let prev = previousPoint else { continue }
                if distancePointToLineSegment(point: point, p1: prev, p2: currentPoint) <= minimumDistance {
                    return true
                }
                previousPoint = currentPoint
            }
            if line.points.count == 1, let firstPoint = line.points.first {
                 if distancePoints(p1: point, p2: firstPoint) <= minimumDistance {
                    return true
                 }
            }
        }
        return false
    }

    // MARK: - Geometry Helpers (Move to Core/Utils later)
    
    private func distancePointToLineSegment(point: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
        let l2 = distancePointsSquared(p1: p1, p2: p2)
        if l2 == 0.0 { return distancePoints(p1: point, p2: p1) }
        var t = ((point.x - p1.x) * (p2.x - p1.x) + (point.y - p1.y) * (p2.y - p1.y)) / l2
        t = max(0, min(1, t))
        let projection = CGPoint(x: p1.x + t * (p2.x - p1.x), y: p1.y + t * (p2.y - p1.y))
        return distancePoints(p1: point, p2: projection)
    }
    private func distancePointsSquared(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)
    }
    private func distancePoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(distancePointsSquared(p1: p1, p2: p2))
    }
}

// MARK: - Path Extension for Length (Simplified)

extension Path {
    /// Estimates the total length of the path by summing lengths of line segments (approximates curves).
    var length: CGFloat {
        var totalLength: CGFloat = 0
        var currentPoint: CGPoint? = nil
        var firstPoint: CGPoint? = nil

        forEach { element in
            switch element {
            case .move(to: let p):
                currentPoint = p
                firstPoint = p
            case .line(to: let p):
                if let start = currentPoint {
                    totalLength += distance(from: start, to: p)
                }
                currentPoint = p
            case .quadCurve(to: let p, control: _):
                // Approximation: Use straight line distance
                if let start = currentPoint {
                    totalLength += distance(from: start, to: p)
                }
                currentPoint = p
            case .curve(to: let p, control1: _, control2: _):
                 // Approximation: Use straight line distance
                 if let start = currentPoint {
                    totalLength += distance(from: start, to: p)
                }
                currentPoint = p
            case .closeSubpath:
                if let start = currentPoint, let first = firstPoint {
                    totalLength += distance(from: start, to: first)
                }
                currentPoint = firstPoint
            }
        }
        return totalLength
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
} 