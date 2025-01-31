//
//  Pokemon.swift
//  WhosThatPokemon
//
//  Created by Rob Wilson on 18/11/2024.
//

import Foundation

struct PokedexEntry: Decodable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Pokedex: Decodable {
    let results: [PokedexEntry]
}

struct Pokemon: Decodable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL
    
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case sprites
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        self.imageURL = sprites.other.officialArtwork.front_default
    }
    
    
    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = URL(string: imageURL) ?? URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png")!
    }
}

struct Sprites: Decodable {
    let other: OtherSprites
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let front_default: URL
}
