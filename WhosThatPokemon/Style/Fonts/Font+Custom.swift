//
//  Font+Custom.swift
//  WhosThatPokemon
//
//  Created by Rob Wilson on 18/11/2024.
//

import SwiftUI
extension Font {
    static func pokemonHollow(size: CGFloat) -> Font {
        Font.custom("Pokemon Hollow", size: size)
    }
    
    static func pokemonSolid(size: CGFloat) -> Font {
        Font.custom("Pokemon Solid", size: size)
    }
}
