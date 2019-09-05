import UIKit

@IBDesignable class ChartView: UIView {
    var _gridColour = UIColor.darkGray
    let cubicCurveAlgorithm = CubicCurveAlgorithm()

    @IBInspectable var gridColour: UIColor {
        get {
            return _gridColour
        }
        set {
            _gridColour = newValue
        }
    }

    private let lineColor: UIColor = UIColor.red

    var lineLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit(bounds: bounds)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit(bounds: bounds)
    }

    func sharedInit(bounds: CGRect) {
        self.lineLayer = buildLineLayer(linePath: UIBezierPath())

        if let lineLayer = self.lineLayer {
            self.layer.addSublayer(lineLayer)
        }
    }

    override func prepareForInterfaceBuilder() {
        let bounds = CGRect(x: 0, y: 0, width: 362, height: 681)

        let pointLists = PointData.buildPointLists()

        drawChart(view: self, bounds: bounds, pointLists: pointLists)
    }

    func drawChart(view: UIView, bounds: CGRect, pointLists: [[Int]]) {
        let numRows = pointLists.count
        let numCols = pointLists[0].count
        let gridShape = buildGridShape(view: view, bounds: bounds, numCols: numCols, numRows: numRows)

        view.layer.addSublayer(gridShape)

        let pointLists = PointData.buildPointLists()

        let path = buildPath(pointLists: pointLists)
        lineLayer!.path = path.cgPath
    }

    func buildPath(pointLists: [[Int]]) -> UIBezierPath {
        let numRows = pointLists.count
        let numCols = pointLists[0].count

        let path = buildPath(numRows: numRows, numCols: numCols, pointLists: pointLists)

        return path
    }

    private func buildPath(numRows: Int, numCols: Int, pointLists: [[Int]]) -> UIBezierPath {
        let path = UIBezierPath()

        let ySpacing: Int = Int(bounds.height) / numRows

        for (index, pointList) in pointLists.enumerated() {
            let initX: Int = 0
            let initY: Int = Int(bounds.height) - ySpacing * index
            let newPath = drawCurve(bounds: bounds, initX: initX, initY: initY, points: pointList)

            path.append(newPath)
        }

        return path
    }

    private func drawCurve(bounds: CGRect, initX: Int, initY: Int, points: [Int]) -> UIBezierPath {
        var dataPoints = Array<CGPoint>()

        let width = Int(bounds.width)
        let xSpacing = width / points.count

        for (index, value) in points.enumerated() {
            let point = CGPoint(x: initX + index * xSpacing, y: initY - Int(value))

            dataPoints.append(point)
        }

        let path = buildPath(dataPoints: dataPoints)

        return path
    }

    private func buildPath(dataPoints: [CGPoint]) -> UIBezierPath {
        let controlPoints = cubicCurveAlgorithm.controlPointsFromPoints(dataPoints: dataPoints)

        let linePath = UIBezierPath()

        for i in 0..<dataPoints.count {
            let point = dataPoints[i];

            if i == 0 {
                linePath.move(to: point)
            } else {
                let segment = controlPoints[i - 1]
                linePath.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }

        return linePath
    }

    private func buildLineLayer(linePath: UIBezierPath) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()

        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = self.lineColor.cgColor
        lineLayer.lineWidth = 4.0

        lineLayer.shadowColor = UIColor.black.cgColor
        lineLayer.shadowOffset = CGSize(width: 0, height: 8)
        lineLayer.shadowOpacity = 0.5
        lineLayer.shadowRadius = 6.0

        return lineLayer
    }
}

extension ChartView {
    private func buildGridShape(view: UIView, bounds: CGRect, numCols: Int, numRows: Int) -> CAShapeLayer {
        let path = UIBezierPath()
        let width = Int(bounds.width)
        let ySpacing: Int = Int(view.bounds.height / CGFloat(numRows))
        let yOffSet = 1 * ySpacing

        for i in 0...10 {
            let y = yOffSet + i * ySpacing

            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: width, y: y))
        }

        let gridShape = buildGridShape(path: path, view: self, bounds: bounds)

        return gridShape
    }

    private func buildGridShape(path: UIBezierPath, view: UIView, bounds: CGRect) -> CAShapeLayer {
        let pathLayer = CAShapeLayer()

        pathLayer.frame = bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = _gridColour.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineJoin = CAShapeLayerLineJoin.bevel

        return pathLayer
    }

    private func animatePath(path: UIBezierPath, pathLayer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
    }

}
