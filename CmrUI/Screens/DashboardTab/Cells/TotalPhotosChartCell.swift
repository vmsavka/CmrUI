//
//  TotalPhotosChartCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/23/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private struct Constants {
    static let topGradientColor = UIColor(red: 52.0/255.0, green: 99.0/255.0, blue: 145.0/255.0, alpha: 1.0)
    static let bottomGradientColor = UIColor(red: 158.0/255.0, green: 191.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    static let cornerCircleWidth: CGFloat = 2
    static let cornerCircleColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let kMaxYAxisOffset: Double = 1.5
    
    static let markerColor = NSUIColor.black
    static let markerFocusedColor = NSUIColor.yellow
}

class TotalPhotosChartCell: UICollectionViewCell, DashboardCellView {
    
    
    @IBOutlet weak var photosTotalTitleLabel: UILabel!
    @IBOutlet weak var photosTotalValueLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var chartPhotosView: LineChartView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var circleColors = [NSUIColor]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        setup()
    }
    
    public func setup() {
        setupLineChart()
        gradientView.addGradient(colors: [Constants.topGradientColor,
                                          Constants.bottomGradientColor],
                                 start: CGPoint(x:0.5, y:0),
                                 end: CGPoint(x:0.5, y:1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = frame
        gradientView.updateGradientLayerFrame()
    }
    
    private let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM/dd"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        return fmt
    }()
}

extension TotalPhotosChartCell {
    
    func setProgressIndicator(isEnabled: Bool) {
        activityIndicatorView.isHidden = isEnabled ? false : true
        chartPhotosView.isHidden = isEnabled ? true : false
        if isEnabled {
            activityIndicatorView.startAnimating()
        }
        else {
            activityIndicatorView.stopAnimating()
        }
    }

    
    func displayPhotosCount(totalValue: Int) {
        photosTotalValueLabel.text = "\(totalValue)"
    }
    
    func display(title: String) {
        photosTotalTitleLabel.text = title
    }
    
    func display(image: UIImage) {}
    
    func display(date: Date) {
        
    }
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }
}

extension TotalPhotosChartCell {
    
    func dispalyPhotoesStatistics(_ photoesDict: [String: Int]) {
        var dates: [Date] = []
        var keys: [String] = []
        var maxValue: Int = 0
        
        for (key, value) in photoesDict {
            if let date = self.dateFormatter.date(from: key) {
                dates.append(date)
                keys.append(key)
                print("<key=%@, value=%ld>\n", key, value)
                maxValue = value > maxValue ? value : maxValue
                //let month = NSCalendar.current.component(.month, from: date)
            }
        }
        
        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (dates.map { $0.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
 
        // Define chart entries
        var entries = [ChartDataEntry]()
        for i in 0..<dates.count {
            let timeInterval = dates[i].timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = photoesDict[keys[i]]
            let entry = ChartDataEntry(x: xValue, y: Double(yValue ?? 0))
            entries.append(entry)
        }
        entries.sort(by: { $0.x < $1.x })
        
        let chartData = LineChartData()
        chartData.setDrawValues(true)
        
        //Add main chart line
        let lineDates = LineChartDataSet(values: entries, label: nil)
        chartData.addDataSet(lineDates)
        chartData.setDrawValues(false)
        lineDates.colors = [UIColor.white]
        lineDates.lineWidth = 2.0
        lineDates.drawCirclesEnabled = true
        lineDates.circleRadius = 3.0
        lineDates.circleColors = [UIColor.black]
        lineDates.drawValuesEnabled = false
        lineDates.mode = .horizontalBezier
        /*
        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xAxisFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        */
        
        //Axes setup
        let xAxis = chartPhotosView.xAxis
        //xAxis.valueFormatter = xAxisFormatter
        xAxis.axisMinimum = 0
        /*if let x = entries.last?.x {
            xAxis.axisMaximum = x + 0.05
        }*/

        chartPhotosView.xAxis.drawGridLinesEnabled = false
        chartPhotosView.xAxis.drawLabelsEnabled = false
        chartPhotosView.rightAxis.enabled = false
        chartPhotosView.leftAxis.enabled = false
        chartPhotosView.xAxis.enabled = false
        chartPhotosView.leftAxis.drawGridLinesEnabled = false
        chartPhotosView.leftAxis.axisMinimum = 0
        chartPhotosView.leftAxis.axisMaximum = Double(maxValue) * Constants.kMaxYAxisOffset
        chartPhotosView.leftAxis.labelCount = 0
        chartPhotosView.data = chartData
    }
    
    func setupLineChart() {
        //Configure Chart View
        chartPhotosView.delegate = self
        chartPhotosView.chartDescription?.enabled = false
        
        refreshMarkerColors()
        //chartPhotosView.dragEnabled = true
        //chartPhotosView.setScaleEnabled(true)
        //chartPhotosView.pinchZoomEnabled = true
        
        chartPhotosView.noDataTextColor = UIColor.clear
        chartPhotosView.noDataText = ""
        chartPhotosView.backgroundColor = UIColor.clear
        chartPhotosView.legend.enabled = false
        chartPhotosView.drawMarkers = true
        chartPhotosView.chartDescription?.enabled = false
        
        chartPhotosView.xAxis.drawGridLinesEnabled = false
        chartPhotosView.leftAxis.drawLabelsEnabled = false
        chartPhotosView.extraBottomOffset = 0
        chartPhotosView.highlightPerTapEnabled = true
        
        let marker = BalloonMarker(color: UIColor.clear,
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        marker.chartView = chartPhotosView
        marker.minimumSize = CGSize(width: 30, height: 18)
        chartPhotosView.marker = marker
        chartPhotosView.tintColor = UIColor.blue

        chartPhotosView.animate(xAxisDuration: 0.5)
    }
    
    func refreshMarkerColors() {
        var points = LineChartDataSet()
        guard let dataSets = chartPhotosView.data?.dataSets else { return }
        if dataSets.count > 0 {
            points = (dataSets[0] as? LineChartDataSet)!
            circleColors = [NSUIColor](repeating: Constants.markerColor, count: points.values.count)
        }
    }
}

    // MARK: - ChartViewDelegate

extension TotalPhotosChartCell: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var dataSet = LineChartDataSet()
        dataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        let values = dataSet.values
        let index = values.index(where: {$0.x == highlight.x})
        
        refreshMarkerColors()
        dataSet.circleColors = circleColors
        dataSet.circleColors[index!] = Constants.markerFocusedColor
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        var dataSet = LineChartDataSet()
        dataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        dataSet.circleColors = circleColors
        
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
}
