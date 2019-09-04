class PointData {
    static let numCols = 10
    static let numRows = 10

    class func buildPointLists() -> [[Int]] {
        var pointLists: [[Int]] = []

        for _ in 0..<numRows {
            let points = buildPoints()

            pointLists.append(points)
        }

        return pointLists
    }

    class func buildPoints() -> [Int] {
        var points: [Int] = []

        for _ in 0..<numCols {
            let randomValue = point()

            points.append(randomValue)
        }

        return points
    }

    class func point() -> Int {
        let randomValue = Int.random(in: 0..<50)

        return randomValue
    }
}

