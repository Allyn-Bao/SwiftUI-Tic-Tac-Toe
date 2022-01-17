//
//  ContentView.swift
//  SwiftUITut-TicTacToe
//
//  Created by Allyn Bao on 2022-01-16.
//

import SwiftUI



struct GameView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    let colorSpectrum : Gradient = Gradient(colors: [Color("LightRed"), Color("Red")])
    let buttonSizeDivisor : Double = 3.4
    let buttonMarkPadding : Double = 50.0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Title
                Text("Tic Tac Toe")
                    .foregroundColor(Color("TitleColor"))
                    .font(.system(size: 50, weight: .bold, design: .default))
                    .padding()
                // Message
                Text(viewModel.message)
                    .foregroundColor(Color("TitleColor"))
                    .font(.system(size: 32, weight: .medium, design: .default))
                    
                Spacer()
                
                // Board
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { i in
                        
                        // Block
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: colorSpectrum, startPoint: UnitPoint.leading, endPoint: UnitPoint.trailing))
                                .frame(width: geometry.size.width / buttonSizeDivisor, height: geometry.size.width / buttonSizeDivisor)
                            Image(systemName: viewModel.moves[i]?.indicator ?? "") // default value ""
                                .resizable()
                                .frame(width: geometry.size.width / buttonSizeDivisor - buttonMarkPadding, height: geometry.size.width / buttonSizeDivisor - buttonMarkPadding)
                                .foregroundColor(.white)
                        }
                        .onTapGesture { viewModel.humanMove(boardIndex: i) }
                    }
                }
                .padding(1)
                
                Spacer()
                    
                Button {
                    viewModel.reset()
                } label : {
                    Text("Start Over")
                        .frame(width: 280, height: 50)
                        .foregroundColor(.white)
                        .background(Color("Red"))
                        .opacity(1)
                        .font(.system(size: 20, weight: .bold, design:.default))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
