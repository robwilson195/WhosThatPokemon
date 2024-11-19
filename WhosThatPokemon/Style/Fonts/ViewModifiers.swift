//
//  ViewModifiers.swift
//  WhosThatPokemon
//
//  Created by Rob Wilson on 18/11/2024.
//

import SwiftUI

struct PokemonText: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.pokemonSolid(size: size))
            .shadow(
                    color: Color.blue,
                    radius: 0, /// shadow radius
                    x: 2, /// x offset
                    y: 2 /// y offset
                )
            .foregroundStyle(.yellow)
            .multilineTextAlignment(.center)
    }
}

struct PrimaryCTAStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(.red)
    }
}

extension View {
    func pokemonTextStyle(size: CGFloat = 18) -> some View {
        modifier(PokemonText(size: size))
    }
}
