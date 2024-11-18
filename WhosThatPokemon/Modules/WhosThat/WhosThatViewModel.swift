//
//  WhosThatViewModel.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import Foundation

struct WhosThatDisplayModel {
    let pokemon: Pokemon?
}

class WhosThatViewModel: ObservableObject {
    
    @Published var displayModel: WhosThatDisplayModel = .init(pokemon: nil)
    
    private let pokemonService: PokemonServicing
    
    init(pokemonService: PokemonServicing) {
        self.pokemonService = pokemonService
    }
    
    func onAppear() async {
        do {
            let entries = try await pokemonService.getPokedexEntries()
            print(entries)
            let pokemon = try await pokemonService.getPokemon(name: "\(entries[50].name)")
            print(pokemon)
        } catch {
            print(error)
        }
    }
    
}
