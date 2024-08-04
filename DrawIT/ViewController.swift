//
// ViewController.swift
//
// Created by Speedyfriend67 on 04.08.24
//
 
import UIKit

class ViewController: UIViewController {

    private let canvasView = CanvasView()
    private var replayLines: [(points: [CGPoint], width: CGFloat)] = []
    private var currentReplayIndex: Int = 0
    private var currentPointIndex: Int = 0
    private var replayTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        canvasView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        view.addSubview(canvasView)
        
        let replayButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 60, width: 100, height: 50))
        replayButton.setTitle("Replay", for: .normal)
        replayButton.backgroundColor = .blue
        replayButton.addTarget(self, action: #selector(replayDrawing), for: .touchUpInside)
        view.addSubview(replayButton)
        
        let clearButton = UIButton(frame: CGRect(x: 130, y: view.frame.height - 60, width: 100, height: 50))
        clearButton.setTitle("Clear", for: .normal)
        clearButton.backgroundColor = .red
        clearButton.addTarget(self, action: #selector(clearDrawing), for: .touchUpInside)
        view.addSubview(clearButton)
        
        let widthSlider = UISlider(frame: CGRect(x: 250, y: view.frame.height - 60, width: 200, height: 50))
        widthSlider.minimumValue = 1
        widthSlider.maximumValue = 20
        widthSlider.value = 5
        widthSlider.addTarget(self, action: #selector(widthChanged(_:)), for: .valueChanged)
        view.addSubview(widthSlider)
    }

    @objc private func widthChanged(_ sender: UISlider) {
        let width = CGFloat(sender.value)
        canvasView.setCurrentWidth(width)
    }

    @objc private func replayDrawing() {
        replayLines = canvasView.getLines()
        canvasView.setLines([])
        currentReplayIndex = 0
        currentPointIndex = 0
        replayTimer?.invalidate()
        replayTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(drawNextLineSegment), userInfo: nil, repeats: true)
    }

    @objc private func drawNextLineSegment() {
        guard currentReplayIndex < replayLines.count else {
            replayTimer?.invalidate()
            return
        }
        
        var segments: [(points: [CGPoint], width: CGFloat)] = []
        
        for i in 0..<currentReplayIndex {
            segments.append(replayLines[i])
        }
        
        if currentPointIndex < replayLines[currentReplayIndex].points.count {
            let points = Array(replayLines[currentReplayIndex].points.prefix(currentPointIndex + 1))
            segments.append((points: points, width: replayLines[currentReplayIndex].width))
            currentPointIndex += 1
        } else {
            segments.append(replayLines[currentReplayIndex])
            currentReplayIndex += 1
            currentPointIndex = 0
        }
        
        canvasView.setLines(segments)
    }

    @objc private func clearDrawing() {
        canvasView.setLines([])
        replayLines = []
        currentReplayIndex = 0
        currentPointIndex = 0
        replayTimer?.invalidate()
    }
}