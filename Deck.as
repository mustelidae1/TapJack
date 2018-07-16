package  {
	
	import flash.display.MovieClip; 
	import Card; 
	
	/*
	* This object represents a deck of cards. 
	* The deck can be instantiated as a full (56 card) 
	* or empty deck. 
	* @author Olivia Thomas
	*/
	public class Deck {
		
		private var deck:Array = new Array(); 

		public function Deck(size:Number) {
			createDeck(size); 
			shuffleDeck(); 
		}
		
		// ***** PUBLIC METHODS ******* //
		public function getCardAt(index:Number) :Card {
			return deck[index]; 
		}
		
		public function removeCard() :Card {
			return deck.pop(); // removes last card 
		}
		
		// remove card from end? 
		
		public function addCard(card:Card) :void {
			deck.push(card); // adds card to end 
		}
		
		public function getLength() :Number {
			return deck.length; 
		}
		
		public function print() :void {
			for each (var c:Card in deck) {
				if (c == null) {
					trace("NULL"); 
				} else {
					c.print(); 
				}
			}
		}
		
		// ***** UTILITY METHODS ****** // 
		
		/*
		* Creates a new deck. 
		*/ 
		private function createDeck(size:Number) :void {
			var i:int; 
			var j:int; 
			if (size == 56) {
				for (i = 1; i <= 4; i++) {
					for (j = 1; j <= 13; j++) {
						var card = new Card(i, j); 
						deck.push(card); 
					}
				}
			} else if (size == 0) {
				
 			} else {
				trace("Unsupported deck size."); 
			}
		}
		
		/*
		* Shuffles the deck. 
		*/ 
		private function shuffleDeck() :void {
			var tempDeck:Array = new Array(deck.length);
 
			var randomPos:Number = 0;
			for (var i:int = 0; i < tempDeck.length; i++)
			{
				randomPos = int(Math.random() * deck.length);
				tempDeck[i] = deck.splice(randomPos, 1)[0]; 
			}
			deck = new Array(); 
			for each (var c:Card in tempDeck) {
				deck.push(c); 
			}
		}

	}
	
}
