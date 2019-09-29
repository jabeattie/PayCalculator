//
//  ContentView.swift
//  PayCalculator
//
//  Created by James Beattie on 28/09/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import SwiftUI
import Combine

struct DetailsView: View {
    @State var resultsPushed: Bool = false
    @EnvironmentObject private var model: DetailsViewModel
    
    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .center, spacing: 30) {
                    Input()
                    Spacer()
                    NavigationLink(destination: ResultsView(onDismiss: { self.resultsPushed.toggle() }), isActive: $resultsPushed, label: {
                        CalculateView()
                    })
                    .disabled(!model.isValid)
                }
            }
            .animation(.easeIn)
            .padding(30)
            .navigationBarTitle(model.title)
            .navigationBarHidden(false)
        }
    }
}

struct CalculateView: View {
    @EnvironmentObject private var model: DetailsViewModel

    var body: some View {
        Text("Calculate")
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Asset.takeHomePay.uiColor)
            .opacity(model.isValid ? 1 : 0.3)
            .foregroundColor(Asset.heading.uiColor)
            .cornerRadius(10)
    }
}

struct Input: View {
    @EnvironmentObject private var model: DetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SalaryTaxInput()
            Divider()
            PensionInput()
            Divider()
            SegmentedInput(viewModel: $model.studentLoan) {
                Text("Student loan").headerText()
            }
            Divider()
            ToggleInput(selected: $model.noNI) {
                Text("No NI").headerText()
            }
            Divider()
            ToggleInput(selected: $model.blind) {
                Text("Blind").headerText()
            }
        }
    }
}

struct SalaryTaxInput: View {
    @EnvironmentObject private var model: DetailsViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            MoneyInput(placeholder: "25000", money: $model.salary) {
                Text("Salary").headerText()
            }
            Divider()
            TextInput(placeholder: "1250L", text: $model.taxCode) {
                Text("Tax code").headerText()
            }
        }
    }
}

struct PensionInput: View {
    @State var open: Bool = false
    @EnvironmentObject private var model: DetailsViewModel
    
    var body: some View {
        VStack {
            OpenableInput(open: $open) {
                Text("Pension").headerText()
            }
            .gesture(TapGesture().onEnded({ (_) in self.open.toggle() }))
            if open {
                TextInput(placeholder: "3%", text: $model.pensionPC) {
                    Text("Contribution").subheaderText()
                }
//                SegmentedInput(options: ["One", "Two"], choice: model.pensionType) {
//                    Text("Penstion type").subheaderText()
//                }
                MoneyInput(placeholder: "25000", money: $model.salary) {
                    Text("Contribution cap").subheaderText()
                }
            }
        }
    }
}

struct OpenableInput: View {
    @Binding var open: Bool
    var title: () -> Text
    
    var body: some View {
        HStack {
            title()
            Spacer()
            if open {
                Image(systemName: "arrow.up.circle")
            } else {
                Image(systemName: "arrow.down.circle")
            }
        }
    }
}

struct ToggleInput: View {
    @Binding var selected: Bool
    var title: () -> Text
    
    var body: some View {
        HStack(spacing: CGFloat(15)) {
            Toggle(isOn: $selected, label: title)
        }
    }
}

struct TextInput: View {
    var placeholder: String
    @Binding var text: String
    var title: () -> Text
    
    var body: some View {
        HStack(spacing: CGFloat(15)) {
            title()
            Spacer()
            TextField(placeholder, text: $text)
                .autocapitalization(.allCharacters)
        }
    }
}

struct MoneyInput: View {
    var placeholder: String
    @Binding var money: String
    var title: () -> Text
    
    var body: some View {
        HStack(spacing: CGFloat(15)) {
            title()
            Spacer()
            HStack(alignment: .center) {
                Text("£")
                TextField(placeholder, text: $money)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView().environmentObject(DetailsViewModel())
    }
}
