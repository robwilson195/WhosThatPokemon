# Whos That Pokémon?
Technical challenge by Rob Wilson

## Planning
- For planning, see the excalidraw file (WhosThatPokemonPlanning.excalidraw)

## User experience
- The landing screen serves as a simple onboarding experience, advising the user on how to win the game.
- When the user starts, they're pushed to the game view and presented with the first pokemon.
- The user wins the game when they correctly identify 5 pokemon, and have to start over if they fail.

## Architecture
- Given the simple nature of this application, an MVVM architecture was used. If more screens or modules were anticipated, one might consider adding a router or coordinator to better abstract navigation from the view.
- The WhosThatViewModel controls the state of the main game view, predominantly with the published gameState property. 
- Service calls are made through a PokemonService, which returns only the data required by the app. If caching were desired, this might itself be accessed through a repository which could access resources locally or through a service as appropriate.
- Importantly, the business logic of the view model does not access a concrete service class, but instead anything conforming to PokemonServicing. This facilitates simple mocking, and would make it easy to abstract the services to a separate module or package if the scale of the app merits it in the future.
