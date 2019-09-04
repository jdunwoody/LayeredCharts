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

        signalTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (Timer) in
            self.timerFired()
        })
    }

    private func timerFired() {
        if let chartView = chartView {
            for i in 0..<pointLists.count {
                pointLists[i].removeFirst(1)
                pointLists[i].append(PointData.point())

            }

            let path = chartView.buildPath(pointLists: pointLists)
            chartView.lineLayer!.path = path.cgPath
        }
    }
}
