//
//  PortfolioView.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/27.
//

import SwiftUI

struct PortfolioView: View {
    @State private var quantiyText: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var showCheckMark: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationBarTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: dismiss)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                               
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id  == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
//            .padding(.vertical, 4)
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings {
            quantiyText = "\(amount)"
        } else {
            quantiyText = ""
        }
        
        
    }
    
    private func getCurrentValue() -> Double {
        
        if let quantity = Double(quantiyText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimal() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantiyText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
        }
        .animation(.none, value: selectedCoin)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantiyText)) ? 1.0 : 0.0
            )

            
        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantiyText)
        else { return }
        //save to porfolio
        vm.updatePorfolio(coin: coin, amount: amount)
        
        //showCheckmark
        withAnimation {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        
        UIApplication.shared.endEditing()
        
        //hide checkmark
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
