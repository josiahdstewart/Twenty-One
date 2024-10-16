require 'pry'

class Player
  BUST_THRESHOLD = 21
  ACE_LOW = 1
  ACE_HIGH = 11
  FACE_CARD_VALUE = 10
  ACE = 'A'

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def hit(deck)
    card = deck.cards.sample
    deck.cards.delete(card)
    card
  end

  def busted?
    total > BUST_THRESHOLD
  end

  def total
    num_aces = cards.map(&:value).select { |value| ace?(value) }.size
    current_points = total_points_without_ace
    num_aces.times { |_| current_points += ace_high_or_low(current_points) }
    current_points
  end

  private

  def total_points_without_ace
    cards.map(&:value).select { |value| !ace?(value) }.map do |value|
      if value.to_i.to_s == value
        value.to_i
      elsif value != ACE
        FACE_CARD_VALUE
      end
    end.sum
  end

  def ace_high_or_low(current_point_total)
    (current_point_total + ACE_HIGH) > BUST_THRESHOLD ? ACE_LOW : ACE_HIGH
  end

  def ace?(value)
    value == ACE
  end
end

class Dealer < Player
  def deal(deck)
    [hit(deck), hit(deck)]
  end
end

class Deck
  SUITS = ["♣", "♠", "♥", "♦"]
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_reader :cards

  def initialize
    @cards = []
    SUITS.each do |suit|
      VALUES.each { |value| cards << Card.new(value, suit) }
    end
  end

  private

  attr_writer :cards
end

class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value}#{suit}"
  end
end

class Game
  DEALER_THRESHOLD = 17

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def start
    loop do
      deal_cards
      display_cards
      player_turn
      dealer_turn if !player.busted?
      show_result
      break unless play_again?
      # reset
    end
    display_goodbye_message
  end

  private

  attr_reader :player, :dealer
  attr_accessor :deck

  def deal_cards
    player.cards = dealer.deal(deck)
    dealer.cards = dealer.deal(deck)
  end

  def display_cards
    system 'clear'
    player_cards_display = player.cards.map { |card| "|  #{card}  " }.join
    dealer_cards_display = dealer.cards.map { |card| "|  #{card}  " unless card.equal?(dealer.cards.last) }.join
    puts "             CARDS"
    puts "PLAYER |#{player_cards_display}"
    puts "DEALER |#{dealer_cards_display}| HIDDEN"
    puts "PLAYER SCORE: #{player.total}"
  end

  def player_turn
    if player_hit?
      loop do
        player.cards << player.hit(deck)
        display_cards
        break if player.busted? || !player_hit?
      end
    end
    puts "YOU BUSTED" if player.busted?
  end

  def player_hit?
    answer = nil
    loop do
      puts "Would you like to hit or stay? (h/s)"
      answer = gets.chomp
      break if answer == 'h' || answer == 's'
      puts "Please insert a valid answer."
    end
    answer == 'h'
  end

  def dealer_turn
    loop do
      break unless dealer.total < DEALER_THRESHOLD
      dealer.cards << dealer.hit(deck)
    end
    display_cards
    puts "DEALER BUSTED WITH #{dealer.total}" if dealer.busted?
  end

  def show_result
    message = if player.busted? || player.total < dealer.total
                "<<<<<<<<<<<DEALER WON>>>>>>>>>>>"
              elsif dealer.busted? || player.total > dealer.total
                "<<<<<<<<<<<YOU WON>>>>>>>>>>>"
              else
                "<<<<<<<<<<<TIE>>>>>>>>>>>"
              end
    puts message
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if answer == 'y' || answer == 'n'
    end
    answer == 'y'
  end

  def reset
    self.deck = Deck.new
  end

  def display_goodbye_message
    puts "Thank you for playing Twenty-One!"
    puts "Good-bye!"
  end
end

Game.new.start
