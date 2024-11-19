//
//  WhosThatViewModel.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import Foundation

enum GameState: Equatable {
    case error
    case loading
    case choosing(Pokemon)
    case lostRound(Pokemon)
    case wonRound(Pokemon)
    case wonGame
}

class WhosThatViewModel: ObservableObject {
    
    @Published var gameState: GameState = .loading
    @Published var options: [String] = []
    @Published var round = 0
    let maxRounds = 5
    
    private let pokemonService: PokemonServicing
    private var cachedPokemonNames: [String] = []
    
    init(pokemonService: PokemonServicing) {
        self.pokemonService = pokemonService
    }
    
    @MainActor
    func onAppear() async {
        do {
            cachedPokemonNames = try await pokemonService.getPokemonNames()
            round = 0
            await startRandomRound()
        } catch {
            gameState = .error
        }
    }
    
    @MainActor
    func choseOption(_ chosenName: String) {
        guard case .choosing(let pokemon) = gameState else { return }
        let won = pokemon.name.lowercased() == chosenName.lowercased()
        if won {
            gameState = .wonRound(pokemon)
        } else {
            gameState = .lostRound(pokemon)
        }
    }
    
    @MainActor
    func nextPressed() async {
        if round >= maxRounds {
            gameState = .wonGame
        } else {
            await startRandomRound()
        }
    }
    
    @MainActor
    func retryPressed() async {
        gameState = .loading
        await onAppear()
    }
    
    private func startRandomRound() async {
        let randomNames = Array(cachedPokemonNames.shuffled().prefix(4))
        guard let first = randomNames.first else { return }
        do {
            let pokemon = try await pokemonService.getPokemon(name: first)
            round += 1
            options = randomNames.shuffled()
            gameState = .choosing(pokemon)
        } catch {
            gameState = .error
        }
    }
    
}
