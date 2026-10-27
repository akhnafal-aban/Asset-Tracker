//
//  StatCardView.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 15/06/26.
//

import SwiftUI

struct StatCardView: View {
    let tittle: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tittle)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                
                Text(unit)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    StatCardView(tittle: "Total Assets", value: "5", unit: "assets")
}
