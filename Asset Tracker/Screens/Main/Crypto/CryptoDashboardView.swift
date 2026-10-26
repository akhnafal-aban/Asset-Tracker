//
//  CryptoDashboardView.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 18/06/26.
//

import SwiftUI

struct CryptoDashboardView: View {

    @State private var viewModel =
        CryptoDashboardViewModel()

    var body: some View {

        VStack(spacing: 16) {

            Text("BTC/USD")
                .font(.title)

            Text(
                viewModel.currentPrice,
                format: .currency(code: "USD")
            )
            .font(.largeTitle)
            .bold()

        }
        .task {
            viewModel.start()
        }
    }
}

#Preview {
    CryptoDashboardView()
}
