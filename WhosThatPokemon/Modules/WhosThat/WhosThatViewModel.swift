//
//  WhosThatViewModel.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import Foundation

enum GameState: Equatable {
    case loading
    case choosing(Pokemon)
    case lostRound(Pokemon)
    case wonRound(Pokemon)
    case wonGame
}

@MainActor
class WhosThatViewModel: ObservableObject {
    
    @Published var gameState: GameState = .loading
    @Published var options: [String] = []
    @Published var round = 0
    let maxRounds = 5
    
    private let pokemonService: PokemonServicing
    private var cachedEntries: [PokedexEntry] = []
    
    init(pokemonService: PokemonServicing) {
        self.pokemonService = pokemonService
    }
    
    func onAppear() async {
        do {
            cachedEntries = try await pokemonService.getPokedexEntries()
            await startRandomRound()
        } catch {
            print(error)
        }
    }
    
    func choseOption(_ chosenName: String) {
        guard case .choosing(let pokemon) = gameState else { return }
        let won = pokemon.name.lowercased() == chosenName.lowercased()
        if won, round >= maxRounds {
            gameState = .wonGame
        } else if won {
            gameState = .wonRound(pokemon)
        } else {
            gameState = .lostRound(pokemon)
        }
    }
    
    func nextPressed() async {
        await startRandomRound()
    }
    
    func retryPressed() async {
        round = 0
        await startRandomRound()
    }
    
    private func startRandomRound() async {
        let randomEntries = cachedEntries.randomEntries(desiredLength: 4)
        guard let first = randomEntries.first else { return }
        do {
            let pokemon = try await pokemonService.getPokemon(name: first.name)
            round += 1
            options = randomEntries.shuffled().map(\.name)
            gameState = .choosing(pokemon)
        } catch {
            print(error)
        }
    }
    
}

extension Array where Element == PokedexEntry {
    func randomEntries(desiredLength: Int) -> [PokedexEntry] {
        guard count >= desiredLength else { return self }
        var randomEntries = [PokedexEntry]()
        while randomEntries.count < desiredLength {
            guard let random = self.randomElement() else { return self }
            if !randomEntries.contains(random) { randomEntries.append(random) }
        }
        return randomEntries
    }
}
