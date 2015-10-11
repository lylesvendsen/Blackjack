# Blackjack
Blackjack Demo with Coldfusion and AngularJs

# Required Downloads
- CFwheels (1.4.2) - http://docs.cfwheels.org/page/download (installed at the root)

# Frameworks Used
- CfWheels
- AngularJs
	- angular-route
    - angular-resource
- Jquery
- Bootstrap


## Goal
Create a blackjack game demo to meet the following requirements under "Blackjack as a Service (BaaS) with Micro UI"

## End Points
- **new** - Creates new games, with a new shoe and players
- **clearTable** - Clears the table and deals a new hand
- **deal** - Deals the next hand. Last hand must be completed first
- **action** - Player Action requests, Hit & Stay
- **dealerAction** - Advances to the next dealer action.
- **getGame** - Gets the public game structure. Same structe that is returned from other public endpoints with no action executed.
- **saveGame** - This is a stubed in end point to save the game history
- **getGameFull** - Return the internat game structure including the full shoe detail. (Not For Production Use)

## Development Notes
The application structure was chosen as a pragmatic solution to deliver the needed functionality while demonstrating the desired coding skills. There are elements of OOP & MVC being used, but due to time constraints and coding exploration it may have deviated from some of my usual coding practices.

One of the elements that is missing that would be a normally be a part of the structure is a service layer in the REST application. CfWheels does not natively "promote" a service layer, but it can be added. I opted instead for a thicker model layer with model objects there are more functionally aware. I do not see this a necessarily as a short coming but has the potential to limiting in larger scale application. Additional a service layer would allow for a slight thinning of the functionality currently in the game controller.

The game state and functionality is solely in the API, leaving the UI with no functional operations that could corrupt the outcome of the game.

## Requirements Not Met and Compromises
- Aces can count as 11 or 1. Sorry I could not with good conscience make a Blackjack game without it.
- Game Data Persistence
	Simply because of time constraints the game score is maintained in the session and will be reset is a full new game is requested. It is possible in the near future to add game and player record data persistence, but I'm currently out of time. That being said the player game history is displayed real-time for each player at the table in their status boxes. (Win/Loss) Push data is maintained but not displayed.
    
    Planned persistance through either MS SQL or Mongo

## Requirements Exceeded
- Aces are 11 or 1. Again not blackjack without it. :P
- Up to 5 player in addition to the dealer. With further development with could be extended to remote player capability.
- UI exceeded required game “test harness” playablity
- Multi-Deck Shoe with a random shuffle index (the yellow cutting card at the casino)
- 

## Scalability 
If the game data was persisted the game platform would be scalable across a stateless cluster with some minor changes. Although load balancers with sticky sessions would allow a scalability as well. There are code notes alluding to the topic.




## Project Requirements : Blackjack as a Service (BaaS) with Micro UI

#### Purpose
The goal of this exercise is to create a RESTful API that can be consumed by a simple UI layer. This will be one player vs one automated dealer. The UI can be extremely simple and will serve as mostly a “test harness” around your service. You are building both the service and the UI.

#### House Rules/Game Constraints
This is a fairly simple online casino. You are not going to be supporting some of the advanced blackjack components like splits, double downs, surrenders, insurance. 

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
There are very few constraints for this exercise. It is left wide open for good reason. The technologies used are up to you. There are certain implied constraints that go along with “good” development strategies. 

#### Some questions to help guide you:
- Where will you maintain state? 
- If it is in the API, how will it scale beyond a single machine?
- If the UI has the responsibility, how will you validate/authenticate their requests?
- Will your state design, and chosen stack, impact the manner in which you engineer the service?
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
- Must have an endpoint that returns how many TOTAL times player has won, and how many TOTAL times dealer has won. This should be a single endpoint that queries the database