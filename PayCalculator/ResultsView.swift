//
//  ResultsView.swift
//  PayCalculator
//
//  Created by James Beattie on 28/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    var onDismiss: () -> Void
    @ObservedObject var viewModel = ResultsViewModel()

    var btnBack : some View {
        Button(action: {
            self.onDismiss()
        }, label: {
            HStack {
                Image(systemName: "arrow.left.circle")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("Heading"))
            }
        })
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 30) {
                SegmentedInput(viewModel: self.$viewModel.period).frame(maxWidth: .infinity)
                Divider()
                BarChartView(bars: [
                    Bar(id: UUID(), value: 50, label: "Pension", color: Asset.pension.uiColor),
                    Bar(id: UUID(), value: 25, label: "Tax", color: Asset.tax.uiColor),
                    Bar(id: UUID(), value: 15, label: "NI", color: Asset.nationalInsurance.uiColor),
                    Bar(id: UUID(), value: 40, label: "Student loan", color: Asset.studentLoan.uiColor),
                    Bar(id: UUID(), value: 200, label: "Take home", color: Asset.takeHomePay.uiColor)
                ])
                    .frame(minHeight: 400, maxHeight: .infinity)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitle(viewModel.period.selection)
    }
}

struct BarChartView: View {
    let bars: [Bar]

    var body: some View {
        Group {
            if bars.isEmpty {
                Text("There is no data to display chart...")
            } else {
                BarsView(bars: bars)
            }
        }
    }
}

struct BarsView: View {
    let bars: [Bar]
    let max: Double

    init(bars: [Bar]) {
        self.bars = bars
        self.max = bars.map { $0.value }.max() ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 30) {
                ForEach(self.bars) { bar in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(bar.label)
                                .frame(width: geometry.size.width / 2, alignment: .leading)
                            Text(self.formatted(value: bar.value))
                                .frame(width: geometry.size.width / 2, alignment: .trailing)
                        }
                        Rectangle()
                            .fill(bar.color)
                            .frame(width: CGFloat(bar.value) / CGFloat(self.max) * geometry.size.width, height: 5)
                            .accessibility(label: Text(bar.label))
                            .accessibility(value: Text(bar.label))
                    }
                }
            }
            .animation(.spring())
        }
    }
    
    private func formatted(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

struct Bar: Identifiable {
    let id: UUID
    let value: Double
    let label: String
    let color: Color
}