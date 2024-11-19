//
//  LandingView.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                Image("ash")
                    .resizable()
                    .scaledToFit()
                    .mask(LinearGradient(
                        gradient: Gradient(colors: [.black, .black, .black, .clear]),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                VStack {
                    Text("Become a pokemon master!")
                        .pokemonTextStyle(size: 34)
                    Spacer()
                    VStack {
                        Text("Correctly identify 5 pokémon to win!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                        NavigationLink(destination: {
                            WhosThatView(viewModel: WhosThatViewModel(pokemonService: PokemonService()))
                        }, label: {
                            Text("Start")
                                .foregroundStyle(.red)
                                .font(.title.bold())
                        })
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    .padding()
                    Spacer()
                }
            }
        }
        
    }
}

#Preview {
    LandingView()
}
