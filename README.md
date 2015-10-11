# Blackjack
Blackjack Demo with Coldfusion and AngularJs


## Goal
Create a blackjack game demo to meet the following requirements:

### Blackjack as a Service (BaaS) with Micro UI

#### Purpose

The goal of this exercise is to create a RESTful API that can be consumed by a simple UI layer. This will be one player vs one automated dealer. The UI can be extremely simple and will serve as mostly a “test harness” around your service. You are building both the service and the UI.

#### House Rules/Game Constraints

This is a fairly simple online casino. You are not going to be supporting some of the advanced 

blackjack components like splits, double downs, surrenders, insurance. 

The only game mechanics that must be supported are:

- Player can request a new game.

- Player receives their hand and the dealers up card.

- The player will only know the “top” card for the dealer, not what their “hidden” card is.

- Player makes decision (hit/stay).

- This decision continues until player goes over 21 or chooses to stay.

- Final decision happens when player stays (stop hitting) or goes over 21.

- The rules for the dealer are simple. They hit until 17. 

- Aces are always 11 for the purposes of this exercise.

- If a dealer is dealt 21 initially, the player immediately loses.

#### Guiding Questions

There are very few constraints for this exercise. It is left wide open for good reason. The 

technologies used are up to you. There are certain implied constraints that go along with “good” 

development strategies. 

#### Some questions to help guide you:

- Where will you maintain state? 

- If it is in the API, how will it scale beyond a single machine?

- If the UI has the responsibility, how will you validate/authenticate their requests?

- Will your state design, and chosen stack, impact the manner in which you engineer the 

service?

- Will you go OOP? Functional? 

- What types of data structures will you use for:

- Game state

- Deck(s)

#### Development Constraints

- The code must be on github.com with a fully documented README explaining usage.

- The code must be deployed, somewhere, and linked from the README as a demo.

- Must be RESTful and speak JSON.

- UI must be built using a modern javascript framework. You pick.

- Game RESULTS must be persisted to a database. Only the final outcome. 

- Example data: Player: 21, Dealer: 22, Winner: Player.

- Must have an endpoint that returns how many TOTAL times player has won, and how many 

TOTAL times dealer has won. This should be a single endpoint that queries the database