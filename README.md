# Twenty-One Game

## Overview
The Twenty-One Game is a simple console-based implementation of the classic card game where the player competes against a dealer. The goal is to have a hand value as close to 21 as possible without going over.

## Classes
- **Player**: Represents a player in the game. Handles card drawing and score calculation.
- **Dealer**: Inherits from Player. Deals cards to the player and itself.
- **Deck**: Represents a standard deck of cards, initializing with 52 cards.
- **Card**: Represents a single playing card with a value and suit.
- **Game**: Manages the game flow, including dealing cards, player turns, dealer turns, and determining the winner.

## How to Run
1. Ensure you have Ruby installed on your machine.
2. Clone this repository or copy the code into a Ruby file (e.g., `twenty_one.rb`).
3. Run the game using:
   ```bash
   ruby twenty_one.rb
