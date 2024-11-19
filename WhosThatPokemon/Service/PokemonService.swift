//
//  PokemonService.swift
//  WhosThatPokemon
//
//  Created by Rob Wilson on 18/11/2024.
//

import Foundation

protocol PokemonServicing {
    func getPokemonNames() async throws -> [String]
    func getPokemon(name: String) async throws -> Pokemon
}

class PokemonService: PokemonServicing {
    let pokemonURL: URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func getPokemonNames() async throws -> [String] {
        let allPokemonURL = pokemonURL.appending(queryItems: [.init(name: "limit", value: "150")])
        let (data, _) = try await URLSession.shared.data(from: allPokemonURL)
        let pokedex = try JSONDecoder().decode(Pokedex.self, from: data)
        return pokedex.results.map(\.name)
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        let pokemonURL = pokemonURL.appending(path: "/\(name)")
        let (data, _) = try await URLSession.shared.data(from: pokemonURL)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
    
}
