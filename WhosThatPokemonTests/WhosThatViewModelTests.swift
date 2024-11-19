//
//  WhosThatViewModelTests.swift
//  WhosThatPokemonTests
//
//  Created by Rob Wilson on 19/11/2024.
//

@testable import WhosThatPokemon
import XCTest

final class WhosThatViewModelTests: XCTestCase {
    
    private var sut: WhosThatViewModel!
    private var service: MockPokemonService!
    private let defaultPokemon = Pokemon(
        id: 1,
        name: "bulbasaur",
        imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    )

    override func setUpWithError() throws {
        service = MockPokemonService()
        sut = WhosThatViewModel(pokemonService: service)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
    }

    func test_givenGetPokemonNamesFails_whenOnAppear_thenErrorShown() async {
        // Given
        service.getPokemonNamesThrownError = MockError.general
        
        // When
        await sut.onAppear()
        
        // Then
        XCTAssertEqual(service.getPokemonNamesCallCount, 1)
        XCTAssertEqual(service.getPokemonByNameCallCount, 0)
        XCTAssertEqual(sut.gameState, .error)
    }
    
    func test_givenGetPokemonByNameFails_whenOnAppear_thenErrorShown() async {
        // Given
        service.getPokemonByNameThrownError = MockError.general
        
        // When
        await sut.onAppear()
        
        // Then
        XCTAssertEqual(service.getPokemonNamesCallCount, 1)
        XCTAssertEqual(service.getPokemonByNameCallCount, 1)
        XCTAssertEqual(sut.gameState, .error)
    }
    
    func test_givenServicesSucceed_WhenOnAppear_thenChoosingGameStateShown() async {
        // When
        await sut.onAppear()
        
        // Then
        XCTAssertEqual(service.getPokemonNamesCallCount, 1)
        XCTAssertEqual(service.getPokemonByNameCallCount, 1)
        XCTAssertEqual(
            sut.gameState,
            .choosing(defaultPokemon)
        )
        XCTAssertEqual(sut.options.count, 4)
        for option in sut.options {
            XCTAssert(service.getPokemonNamesReturnValue.contains(option))
        }
    }
    
    func test_whenCorrectAnswerChosen_thenWonRoundGameStateShown() async {
        // Given
        await sut.onAppear()
        
        // When
        await sut.choseOption("bulbasaur")
        
        // Then
        XCTAssertEqual(sut.gameState, .wonRound(defaultPokemon))
    }
    
    func test_givenRoundWon_whenNextPressed_thenRoundIncrementedAndChooseStateShown() async {
        // Given
        await sut.onAppear()
        await sut.choseOption("bulbasaur")
        
        // When
        await sut.nextPressed()
        
        // Then
        XCTAssertEqual(sut.gameState, .choosing(defaultPokemon))
        XCTAssertEqual(service.getPokemonByNameCallCount, 2)
        XCTAssertEqual(sut.round, 2)
    }
    
    func test_givenFiveRoundsWon_whenNextPressed_thenGameWonStateShown() async {
        // Given
        await sut.onAppear()
        for _ in 1...4 {
            await sut.choseOption("bulbasaur")
            await sut.nextPressed()
        }
        await sut.choseOption("bulbasaur")
        XCTAssertEqual(sut.gameState, .wonRound(defaultPokemon))
        
        // When
        await sut.nextPressed()
        
        // Then
        XCTAssertEqual(sut.gameState, .wonGame)
        XCTAssertEqual(service.getPokemonNamesCallCount, 1)
        XCTAssertEqual(service.getPokemonByNameCallCount, 5)
    }
    
    func test_whenWrongAnswerChosen_thenLostRoundGameStateShown() async {
        // Given
        await sut.onAppear()
        
        // When
        await sut.choseOption("charmander")
        
        // Then
        XCTAssertEqual(sut.gameState, .lostRound(defaultPokemon))
    }
    
    func test_givenRoundLost_whenRetryPressed_thenRoundResetAndChooseStateShown() async {
        // Given
        await sut.onAppear()
        await sut.choseOption("charmander")
        XCTAssertEqual(sut.round, 1)
        
        // When
        await sut.retryPressed()
        
        // Then
        XCTAssertEqual(sut.gameState, .choosing(defaultPokemon))
        XCTAssertEqual(service.getPokemonNamesCallCount, 2)
        XCTAssertEqual(service.getPokemonByNameCallCount, 2)
        XCTAssertEqual(sut.round, 1)
        
    }

}
