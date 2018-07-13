package  {
	import flash.display.Bitmap;
	import flash.display.MovieClip; 
	
	/*
	* This object represents a standard playing card. 
	* @author Olivia Thomas 
	*/ 
	public class Card {
		
		//////////////////////////
		//    Suit Key:         //
		//       1 = Clubs      //
		//       2 = Diamonds   //
		//       3 = Hearts     //
		//       4 = Spades     // 
		//                      //
		//    Value Key:        //
		//       11 = Jack      //
		//       12 = Queen     //
		//       13 = King      //
		//       1 = Ace        //
		//////////////////////////
		
		private var suit:int; 
		private var value:int; 
		private var card:MovieClip; 

		public function Card(newSuit, newValue):void {
			suit = newSuit; 
			value = newValue; 
			
			getBitmap(); 

		}
		
		public function getSuit() :int  {
			return suit; 
		}
		
		public function getValue() :int {
			return value; 
		}
		
		public function getCardMC() :MovieClip {
			return card; 
		}
		
		private function getBitmap() {
			switch (suit) {
				case (1) :
					//trace("clubs"); 
					
					switch (value) {
						case (1) :
							card = new ClubsAce();
							break; 
						case (2) : 
							card = new Clubs2(); 
							break; 
						case (3) : 
							card = new Clubs3(); 
							break; 
						case (4) : 
							card = new Clubs4(); 
							break; 
						case (5) :
							card = new Clubs5(); 
							break; 
						case (6) : 
							card = new Clubs6(); 
							break; 
						case (7) : 
							card = new Clubs7(); 
							break; 
						case (8) : 
							card = new Clubs8(); 
							break; 
						case (9) : 
							card = new Clubs9(); 
							break; 
						case (10) : 
							card = new Clubs10(); 
							break; 
						case (11) : 
							card = new ClubsJack(); 
							break; 
						case (12) :
							card = new ClubsQueen(); 
							break; 
						case (13) :
							card = new ClubsKing(); 
							break; 
						default : 
							trace("You shouldn't be here."); 
							card = null; 
							break;
					}
				
					break; 
	
				case (2) :
					//trace("diamonds"); 

					switch (value) {
						case (1) :
							card = new DiamondsAce();
							break; 
						case (2) : 
							card = new Diamonds2(); 
							break; 
						case (3) : 
							card = new Diamonds3(); 
							break; 
						case (4) : 
							card = new Diamonds4(); 
							break; 
						case (5) :
							card = new Diamonds5(); 
							break; 
						case (6) : 
							card = new Diamonds6(); 
							break; 
						case (7) : 
							card = new Diamonds7(); 
							break; 
						case (8) : 
							card = new Diamonds8(); 
							break; 
						case (9) : 
							card = new Diamonds9(); 
							break; 
						case (10) : 
							card = new Diamonds10(); 
							break; 
						case (11) : 
							card = new DiamondsJack(); 
							break; 
						case (12) :
							card = new DiamondsQueen(); 
							break; 
						case (13) :
							card = new DiamondsKing(); 
							break; 
						default :
							trace("You shouldn't be here."); 
							card = null; 
							break; 
					}
				
					break; 
				
				case (3) :
					//trace("hearts"); 

					switch (value) {
						case (1) :
							card = new HeartsAce();
							break; 
						case (2) : 
							card = new Hearts2(); 
							break; 
						case (3) : 
							card = new Hearts3(); 
							break; 
						case (4) : 
							card = new Hearts4(); 
							break; 
						case (5) :
							card = new Hearts5(); 
							break; 
						case (6) : 
							card = new Hearts6(); 
							break; 
						case (7) : 
							card = new Hearts7(); 
							break; 
						case (8) : 
							card = new Hearts8(); 
							break; 
						case (9) : 
							card = new Hearts9(); 
							break; 
						case (10) : 
							card = new Hearts10(); 
							break; 
						case (11) : 
							card = new HeartsJack(); 
							break; 
						case (12) :
							card = new HeartsQueen(); 
							break; 
						case (13) :
							card = new HeartsKing(); 
							break; 
						default : 
							trace("You shouldn't be here."); 
							card = null; 
							break; 
					}
				
					break; 
				
				case (4) :
					//trace("spades"); 

					switch (value) {
						case (1) :
							card = new SpadesAce();
							break; 
						case (2) : 
							card = new Spades2(); 
							break; 
						case (3) : 
							card = new Spades3(); 
							break; 
						case (4) : 
							card = new Spades4(); 
							break; 
						case (5) :
							card = new Spades5(); 
							break; 
						case (6) : 
							card = new Spades6(); 
							break; 
						case (7) : 
							card = new Spades7(); 
							break; 
						case (8) : 
							card = new Spades8(); 
							break; 
						case (9) : 
							card = new Spades9(); 
							break; 
						case (10) : 
							card = new Spades10(); 
							break; 
						case (11) : 
							card = new SpadesJack(); 
							break; 
						case (12) :
							card = new SpadesQueen(); 
							break; 
						case (13) :
							card = new SpadesKing(); 
							break; 
						default : 
							trace("You shouldn't be here."); 
							card = null; 
							break; 
					}
				
					break; 
				
				default :
					trace("You definitely shouldn't be here."); 
					card = null; 
					break; 
				
				
			}
			
		}
		
		public function print() :void {
			trace("Suit: " + suit, " Value: " + value); 
		}

	}
	
}
