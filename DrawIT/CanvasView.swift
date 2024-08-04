//
// ContentView.swift
//
// Created by Speedyfriend67 on 04.08.24
//
 
import UIKit

class CanvasView: UIView {

    private var lines: [(points: [CGPoint], width: CGFloat)] = []
    private var currentWidth: CGFloat = 5.0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lines.append((points: [CGPoint](), width: currentWidth))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        guard var lastLine = lines.popLast() else { return }
        let point = touch.location(in: self)
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)

        for line in lines {
            guard line.points.count > 1 else { continue }
            let path = UIBezierPath()
            path.lineWidth = line.width
            path.lineCapStyle = .round
            path.move(to: line.points[0])
            
            for i in 1..<line.points.count {
                let midPoint = CGPoint(
                    x: (line.points[i - 1].x + line.points[i].x) / 2,
                    y: (line.points[i - 1].y + line.points[i].y) / 2
                )
                path.addQuadCurve(to: midPoint, controlPoint: line.points[i - 1])
            }
            path.addLine(to: line.points.last!)
            UIColor.black.setStroke()
            path.stroke()
        }
    }

    func getLines() -> [(points: [CGPoint], width: CGFloat)] {
        return lines
    }

    func setLines(_ lines: [(points: [CGPoint], width: CGFloat)]) {
        self.lines = lines
        setNeedsDisplay()
    }

    func setCurrentWidth(_ width: CGFloat) {
        currentWidth = width
    }
}