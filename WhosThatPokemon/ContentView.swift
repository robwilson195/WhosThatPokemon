//
//  ContentView.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: WhosThatViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView(viewModel: WhosThatViewModel(pokemonService: PreviewPokemonService()))
}

class PreviewPokemonService: PokemonServicing {
    func getPokedexEntries() async throws -> [PokedexEntry] {
        []
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        Pokemon(id: 1, name: "bulbassaur", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
    }
}
