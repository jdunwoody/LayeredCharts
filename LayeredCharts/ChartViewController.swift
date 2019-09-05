import UIKit

class ChartViewController: UIViewController {
    @IBOutlet weak var chartView: ChartView!

    let audioFrequencyCapture = AudioFrequencyCapture()
    var signalTimer: Timer?
    var pointLists: [[Int]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        pointLists = PointData.buildPointLists()

        chartView.drawChart(view: view, bounds: view.bounds, pointLists: pointLists)

        signalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.timerFired()
        })
    }

    private func timerFired() {
        if let chartView = chartView {
            for i in 0..<pointLists.count {
                pointLists[i].removeFirst(1)
                pointLists[i].append(PointData.point())
            }

            let oldPath = chartView.lineLayer!.path

            let newPath = chartView.buildPath(pointLists: pointLists)

            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.9//CATransaction.animationDuration()
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            animation.fromValue = oldPath
            animation.toValue = newPath.cgPath
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            chartView.lineLayer!.add(animation, forKey: "pathAnimation")

            //            chartView.lineLayer!.path = path.cgPath
        }
    }
}
