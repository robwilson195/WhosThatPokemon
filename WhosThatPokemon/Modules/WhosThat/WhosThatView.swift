//
//  ContentView.swift
//  WhosThatPokemon
//
//  Created by Catherine Megregian on 18/11/2024.
//

import SwiftUI

struct WhosThatView: View {
    
    @ObservedObject var viewModel: WhosThatViewModel
    
    @State var renderingMode: Image.TemplateRenderingMode = .template
    
    var body: some View {
        VStack {
            switch viewModel.gameState {
            case .loading:
                ProgressView()
                    .scaleEffect(3)
            case .choosing(let pokemon),
                    .wonRound(let pokemon),
                    .lostRound(let pokemon):
                roundView()
                pokemonImage(url: pokemon.imageURL)
                Text(promptText())
                    .pokemonTextStyle(size: 30)
                    .padding(.bottom, 20)
                if case .choosing = viewModel.gameState {
                    ForEach(viewModel.options, id: \.self) { option in
                        Button(option.capitalized) {
                            viewModel.choseOption(option)
                        }
                        .modifier(PrimaryCTAStyle())
                    }
                } else if case .wonRound = viewModel.gameState {
                    Button(viewModel.round >= viewModel.maxRounds ? "Next" : "Next round") {
                        Task {
                            await viewModel.nextPressed()
                        }
                    }
                    .modifier(PrimaryCTAStyle())
                } else if case .lostRound = viewModel.gameState {
                    Button("Retry") {
                        Task {
                            await viewModel.retryPressed()
                        }
                    }
                    .modifier(PrimaryCTAStyle())
                }
            case .wonGame:
                Text(promptText())
                    .pokemonTextStyle(size: 30)
                    .padding(30)
            }
        }
        .onChange(of: viewModel.gameState) { state in
            withAnimation {
                switch state {
                case .choosing:
                    renderingMode = .template
                default:
                    renderingMode = .original
                }
            }
        }
        .animation(.easeInOut, value: viewModel.gameState)
        .task {
            await viewModel.onAppear()
        }
    }
    
    func roundView() -> some View {
        Text("Round: \(viewModel.round)/\(viewModel.maxRounds)")
            .font(.title)
    }
    
    func pokemonImage(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .renderingMode(renderingMode)
                .foregroundStyle(.black)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 300)
        .scaleEffect(renderingMode == .original ? 1.2 : 1)
    }
    
    func promptText() -> String {
        switch viewModel.gameState {
        case .choosing:
            return "Who's that pokémon?"
        case .wonRound(let pokemon):
            return "It's \(pokemon.name.capitalized)!"
        case .lostRound(let pokemon):
            return "It's \(pokemon.name.capitalized)! \nYou lost!"
        case .wonGame:
            return "You're a pokémon master!"
        case .loading:
            return "Loading..."
        }
    }
}

#Preview {
    class PreviewPokemonService: PokemonServicing {
        func getPokemonNames() async throws -> [String] {
            ["bulbasaur", "charmander", "dog", "potato"]
        }
        
        func getPokemon(name: String) async throws -> Pokemon {
            Pokemon(id: 1, name: "bulbasaur", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        }
    }
    
    return WhosThatView(viewModel: WhosThatViewModel(pokemonService: PreviewPokemonService()))
}


