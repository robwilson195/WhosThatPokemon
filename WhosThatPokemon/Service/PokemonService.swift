//
//  PokemonService.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import Foundation

protocol PokemonServicing {
    func getPokedexEntries() async throws -> [PokedexEntry]
    func getPokemon(name: String) async throws -> Pokemon
}

class PokemonService: PokemonServicing {
    let pokemonURL: URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func getPokedexEntries() async throws -> [PokedexEntry] {
        let allPokemonURL = pokemonURL.appending(queryItems: [.init(name: "limit", value: "150")])
        let (data, _) = try await URLSession.shared.data(from: allPokemonURL)
        let pokedex = try JSONDecoder().decode(Pokedex.self, from: data)
        return pokedex.results
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        let pokemonURL = pokemonURL.appending(path: "/\(name)")
        let (data, _) = try await URLSession.shared.data(from: pokemonURL)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
    
}
