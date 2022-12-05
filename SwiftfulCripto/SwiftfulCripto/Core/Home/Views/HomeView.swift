//
//  HomeView.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/19.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortpolio: Bool = false
    @State private var showPortfolioView: Bool = false
    var body: some View {
        ZStack {
            //background Layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            //content Layer
            VStack {
                
                homeHeader
                HomeStatsView(showPortfolio: $showPortpolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortpolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortpolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                
                
                Spacer(minLength: 0)
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
        
        
    }
}


extension HomeView {
    private var homeHeader: some View {
        HStack {
            
            CircleButtonView(iconName: showPortpolio ? "plus" : "info")
                .animation(.none, value: showPortpolio)
                .onTapGesture {
                    if showPortpolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortpolio)
                )
            Spacer()
            Text(showPortpolio ? "Porfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortpolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortpolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            
            ForEach(vm.allCoins) { coin in
                
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            
            ForEach(vm.portfolioCoins) { coin in
                
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortpolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}


