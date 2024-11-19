//
//  MockPokemonService.swift
//  WhosThatPokemonTests
//
//  Created by Catherine Megregian on 19/11/2024.
//

@testable import WhosThatPokemon
import Foundation

class MockPokemonService: PokemonService {
    
    var getPokemonNamesThrownError: Error?
    var getPokemonNamesReturnValue = ["pikachu", "charmander", "squirtle", "bulbasaur", "mewtwo", "mew"]
    private(set) var getPokemonNamesCallCount = 0
    override func getPokemonNames() async throws -> [String] {
        getPokemonNamesCallCount += 1
        if let getPokemonNamesThrownError {
            throw getPokemonNamesThrownError
        } else {
            return getPokemonNamesReturnValue
        }
    }
    
    var getPokemonByNameThrownError: Error?
    var getPokemonByNameReturnValue = Pokemon(id: 1, name: "bulbasaur",
                                            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
    private(set) var getPokemonByNameNameInputs = [String]()
    private(set) var getPokemonByNameCallCount = 0
    override func getPokemon(name: String) async throws -> Pokemon {
        getPokemonByNameCallCount += 1
        getPokemonByNameNameInputs.append(name)
        if let getPokemonByNameThrownError {
            throw getPokemonByNameThrownError
        } else {
            return getPokemonByNameReturnValue
        }
    }
}
