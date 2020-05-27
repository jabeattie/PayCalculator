//
//  SegmentedInput.swift
//  PayCalculator
//
//  Created by James Beattie on 29/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import SwiftUI

class SegmentedViewModel: ObservableObject {
    @Published var choice: Int {
        didSet { selection = options[choice] }
    }
    @Published var selection: String
    var options: [String]
    
    init(options: [String], choice: Int) {
        self.choice = choice
        self.options = options
        self.selection = options[choice]
    }
}

struct SegmentedInput: View {
    @Binding var viewModel: SegmentedViewModel
    var title: (() -> Text)?
    
    var body: some View {
        HStack {
            Group {
                if title != nil {
                    title?()
                    Spacer()
                }
                Picker("Options", selection: $viewModel.choice) {
                    ForEach(0 ..< viewModel.options.count) { index in
                        Text(self.viewModel.options[index])
                            .tag(index)
                    }
                    
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}
