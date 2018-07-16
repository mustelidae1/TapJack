package  {

	import flash.display.MovieClip; 
	import flash.events.Event;

	import flash.ui.Multitouch; 
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;	
	
	import AnimationManager; 
	
	import Card; 
	import Deck; 
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	
	/*
	* Main TapJack game code
	* @author Olivia Thomas 
	*/
	public class TapJack1 extends MovieClip {
		
		private var deck:Deck = new Deck(56); 
		private var player1Deck:Deck = new Deck(0); 
		private var player2Deck:Deck = new Deck(0); 
		
		private var p1Deck:MovieClip = new P1Deck(); 
		private var p2Deck:MovieClip = new P2Deck(); 
		private var p1Progress:MovieClip = new Player1Progress(); 
		private var p2Progress:MovieClip = new Player2Progress(); 
		private var p1Tap:MovieClip = new Player1Tap(); 
		private var p2Tap:MovieClip = new Player2Tap(); 
		private var winText:MovieClip = new WinText(); 
		private var p1Text = new Player1Text(); 
		private var p2Text = new Player2Text(); 
		private var menuButton = new MenuButton(); 
		private var rematchButton = new RematchButton(); 
		private var helpButton = new HelpButton(); 
		
		private var touchLayer:Sprite = new Sprite();   // container object for all interactable objects (above) 
		private var cardsLayer:Sprite = new Sprite();   // container object for all non-interactable objects (below) 
		
		private var currentCard:Card; 
		
		private var progressWidth:Number; 
		
		private var player1Turn:Boolean = true; 
		private var animationInProgress:Boolean = false; 
		
		private var driver:TapJackDoc; 
		
		public var jackTimer:Number = 10; 
		private const JACK_DELAY:Number = 10; 
		
		/*
		* Sets up deck and stage to initialize the game. 
		*/ 
		public function TapJack1(driver:TapJackDoc) {
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.driver = driver;
			splitDeck(); 
			
			addEventListener(Event.ADDED_TO_STAGE, setUpStage);
		}
		
		//////////////////////////////////
		// GAME EVENTS 
		//////////////////////////////////
		
		/*
		* Called when a player taps a jack. 
		* Transfers current deck to appropriate player and 
		* determines whether there is a winner. 
		*/ 
		function playerTap(event: TouchEvent) :void {
			if (currentCard != null && currentCard.getValue() == 11 && animationInProgress == false) { 
				var deckSize:int = deck.getLength(); 
				var cardsMoved:int = 0; 
				var curWidth:int; 
				if (event.target == p1Tap) {
					p1Progress.alpha = 100; 
					curWidth = p1Progress.width; 
					AnimationManager.IncreaseWidth(p1Progress, curWidth + (progressWidth * deckSize)); 
				} else if (event.target == p2Tap) {
					p2Progress.alpha = 100; 
					curWidth = p2Progress.width; 
					AnimationManager.IncreaseWidth(p2Progress, curWidth + (progressWidth * deckSize)); 
				}
				for (var i:int = 0; i < deckSize; i++) {
					cardsMoved++; 
					if (deck.getCardAt(i) != null && deck.getCardAt(i).getCardMC().stage) {
						animationInProgress = true; 
						if (event.target == p1Tap) {
							AnimationManager.moveCard(deck.getCardAt(i).getCardMC(), stage.stageHeight, function(){destroyEverything(deckSize, cardsMoved, 1)}); 
						} else if (event.target == p2Tap) {
							AnimationManager.moveCard(deck.getCardAt(i).getCardMC(), 0, function(){destroyEverything(deckSize, cardsMoved, 2)}); 
						}
					} 
					 
				}
			} 
		}
		
		/* 
		* Called when player 1 lays down a card. 
		* Moves the card to the deck and determines 
		* if player 1 has lost. 
		*/ 
		function player1(event: TouchEvent) :void {
			if (player1Turn == true && player1Deck.getLength() > 0 && animationInProgress == false && jackTimer > JACK_DELAY) {
				if (player1Deck.getCardAt(0) == null) {
					trace("Error: Null Card"); 
				}
				var cardPlayed = player1Deck.removeCard();
				deck.addCard(cardPlayed); 
				currentCard = cardPlayed;
				cardPlayed = cardPlayed.getCardMC(); 
				cardsLayer.addChild(cardPlayed); 
				cardPlayed.x = stage.stageWidth / 2; 
				cardPlayed.y = (stage.stageHeight / 2) + 50; 
				cardPlayed.rotation = Math.random() * 5;
				AnimationManager.layCardDown(cardPlayed);  
				p1Progress.width -= progressWidth; 
				removeCard(); 
				// If this is a jack, set delay timer
				if (currentCard.getValue() == 11) {
					jackTimer = 0; 
				} 
				// Check if this is player1's last card (player2 wins) 
				if (player1Turn == true && player1Deck.getLength() == 0) {
					//trace("Player 2 wins!"); 
					p1Progress.alpha = 0; 
					if (currentCard.getValue() == 11) {
						trace("Last Jack!"); 
						p1Deck.alpha = 0; 
						yourTurn(1); // keep turn on player 1 so someone must take the jack 
					} else {
						winner(2);
					}
				} else {
					yourTurn(2); 
				}
				
			}
			
			
		}
		
		/* 
		 * Called when player 2 lays down a card. 
		 * Moves the card to the deck and determines 
		 * if player 2 has lost. 
		 */ 
		function player2(event: TouchEvent) :void {
			if (player1Turn == false && player2Deck.getLength() > 0 && animationInProgress == false && jackTimer > JACK_DELAY) {
				if (player2Deck.getCardAt(0) == null) {
					trace("Error: Null Card"); 
				}
				var cardPlayed = player2Deck.removeCard(); 
				deck.addCard(cardPlayed); 
				currentCard = cardPlayed; 
				cardPlayed = cardPlayed.getCardMC();
				cardsLayer.addChild(cardPlayed); 
				cardPlayed.x = stage.stageWidth / 2; 
				cardPlayed.y = (stage.stageHeight / 2) - 50; 
				cardPlayed.rotation = Math.random() * -5; 
				AnimationManager.layCardUp(cardPlayed); 
				p2Progress.width -= progressWidth; 
				if (deck.getLength() > 10 && deck.getCardAt(0).getCardMC().stage) {
					cardsLayer.removeChild(deck.getCardAt(0).getCardMC());
				}
				removeCard(); 
				// If this is a jack, set delay timer
				if (currentCard.getValue() == 11) {
					jackTimer = 0; 
				}
				// Check if this is player2's last card (player1 wins) 
				if (player1Turn == false && player2Deck.getLength() == 0) {
					p2Progress.alpha = 0; 
					if (currentCard.getValue() == 11) {
						trace("Last jack!"); 
						p2Deck.alpha = 0; 
						yourTurn(2); // keep turn on player 2 so someone must take the jack 
					} else {
						winner(1); 
					}
				} else {
					yourTurn(1);
				}  
			}
			
		}
		
		/*
		 * Determines whose turn it is. 
		 */ 
		function yourTurn(player:int) :void {
			if (player == 1) {
				player1Turn = true; 
				p1Text.gotoAndStop(2); 
				p2Text.gotoAndStop(1); 
			} else if (player == 2) {
				player1Turn = false; 
				p1Text.gotoAndStop(1); 
				p2Text.gotoAndStop(2); 
			}
		}
		
		/*
		 * Ends the game when there is a winner. 
		 */ 
		function winner(player:Number) :void {
			addChild(winText); 
			winText.x = stage.stageWidth / 2; 
			
			if (player == 1) {
				winText.y = 3 * (stage.stageHeight / 4);
				if (p2Deck.stage) {
					touchLayer.removeChild(p2Deck); 
				}
 			} else if (player == 2) {
				winText.y = stage.stageHeight / 4; 
				winText.rotation = 180; 
				if (p1Deck.stage) {
					touchLayer.removeChild(p1Deck);
				}
			}
			
			addChild(helpButton); 
			helpButton.x = stage.stageWidth / 4; 
			helpButton.y = stage.stageHeight / 2;
			AnimationManager.ZoomIn(helpButton); 
			helpButton.addEventListener(TouchEvent.TOUCH_BEGIN, menu); 
			addChild(rematchButton); 
			rematchButton.x = 3 * (stage.stageWidth / 4); 
			rematchButton.y = stage.stageHeight / 2; 
			AnimationManager.ZoomIn(rematchButton);
			rematchButton.addEventListener(TouchEvent.TOUCH_BEGIN, rematch); 
		}
		
		function menu(event:TouchEvent): void {
			menuButton.removeEventListener(TouchEvent.TOUCH_BEGIN, menu); 
			driver.endGame(); 
		}
		
		function rematch(event:TouchEvent) :void {
			rematchButton.removeEventListener(TouchEvent.TOUCH_BEGIN, rematch); 
			driver.rematch(); 
		}
		
		////////////////////////////////
		// DECK UTILITY METHODS 
		///////////////////////////////
		
		/*
		 * Splits the deck into two equal decks. 
		 */
		private function splitDeck() :void {
			var deck1:Boolean = true; 
			
			for (var k:Number = 0; k < 52; k++) {
				 
				if (deck1 == true) {
					player1Deck.addCard(deck.removeCard()); 
					deck1 = false; 
				} else if (deck1 == false) {
					player2Deck.addCard(deck.removeCard()); 
					deck1 = true; 
				}
				
			}
			
		}
		
		/*
		 * Removes the graphic of the card at the 
		 * bottom of the deck if there are more than 
		 * ten cards.
		 */ 
		function removeCard() :void {
			if (deck.getLength() > 5) {
				var found:Boolean; 
				var count:Number = 0; 
				while (found == false) {
					if (deck.getCardAt(count).getCardMC().stage) {
						cardsLayer.removeChild(deck.getCardAt(count).getCardMC()); 
						found = true; 
						//trace("card removed"); 
					}
					count++; 
				}
			}
		}
		
		/*
		 *  Makes the deck and progress bar visible for the specified player. 
		 */ 
		function makeVisible(player:int) {
			if (player == 1) {
				p1Deck.alpha = 100; 
				p1Progress.alpha = 100; 
 			} else {
				p2Deck.alpha = 100; 
				p2Progress.alpha = 100; 
			}
		}
		
		/*
		 *  Destroys all instances of cards displayed onscreen and adds those cards to 
		 *  the respective player's deck. 
		 */ 
		function destroyEverything(deckSize:int, cardsMoved:int, player:int) {
			//trace("EXTERMINATE"); 
			//trace(deckSize, cardsMoved); 
			makeVisible(player); 
			if (deckSize == cardsMoved) {
				for (var j:int = deckSize; j > 0; j--) {
					var curCard:Card = deck.getCardAt(j-1); 
					if (curCard != null) {
						if (player == 1) {
							player1Deck.addCard(curCard); 
						} else {
							player2Deck.addCard(curCard); 
						}
						if (curCard.getCardMC().stage) {
							cardsLayer.removeChild(curCard.getCardMC());
						}
					}
					deck.removeCard(); 
				}
				if (player2Deck.getLength() <= 1) {
					winner(1); 
				}
				if (player1Deck.getLength() <= 1) {
					winner(2); 
				}
				if (player == 1) {
					yourTurn(2); 
				} else {
					yourTurn(1); 
				}
				animationInProgress = false; 
			}

		}
		
		///////////////////////////////////////////////
		//  OTHER UTILITY METHODS 
		///////////////////////////////////////////////
		
		/*
		 * Sets up the main stage at the
		 * beginning of the game. 
		 */ 
		function setUpStage(e:Event) :void {
			removeEventListener(Event.ADDED_TO_STAGE, setUpStage);			
			
			addChild(cardsLayer); 
			addChild(touchLayer); 
			
			touchLayer.addChild(p1Deck); 
			p1Deck.x = stage.stageWidth / 2; 
			p1Deck.y = stage.stageHeight - 50;
			AnimationManager.layCardUp(p1Deck); 
			p1Deck.addEventListener(TouchEvent.TOUCH_BEGIN, player1);
			
			touchLayer.addChild(p2Deck); 
			p2Deck.x = stage.stageWidth / 2; 
			p2Deck.y = 0 + 50;
			AnimationManager.layCardDown(p2Deck); 
			p2Deck.addEventListener(TouchEvent.TOUCH_TAP, player2); 
			//trace("setup complete"); 
			
			touchLayer.addChild(p1Progress); 
			p1Progress.x = 0; 
			p1Progress.y = stage.stageHeight - p1Progress.height; 
			p1Progress.width = 0; 
			AnimationManager.IncreaseWidth(p1Progress, stage.stageWidth / 2); 
			
			touchLayer.addChild(p2Progress); 
			p2Progress.width = 0; 
			AnimationManager.IncreaseWidth(p2Progress, stage.stageWidth / 2); 
			p2Progress.x = stage.stageWidth;
			p2Progress.y = 0;
			
			progressWidth = (stage.stageWidth / 2) / 26;
			
			touchLayer.addChild(p1Tap);  
			p1Tap.width = stage.stageWidth; 
			p1Tap.height = 1 * (stage.stageHeight / 3); 
			p1Tap.x = stage.stageWidth / 2; 
			p1Tap.y = (stage.stageHeight / 2) + (p1Tap.height / 2); 
			p1Tap.addEventListener(TouchEvent.TOUCH_TAP, playerTap); 
			
			touchLayer.addChild(p2Tap); 
			p2Tap.width = stage.stageWidth; 
			p2Tap.height = stage.stageHeight / 3; 
			p2Tap.x = stage.stageWidth / 2; 
			p2Tap.y = (stage.stageHeight / 4) + (p2Tap.height / 4); 
			p2Tap.addEventListener(TouchEvent.TOUCH_TAP, playerTap); 
			
			touchLayer.addChild(p1Text); 
			p1Text.y = stage.stageHeight - p1Text.height; 
			p1Text.x = stage.stageWidth - p1Text.width; 
			p1Text.gotoAndStop(2); 
			
			touchLayer.addChild(p2Text); 
		}

		/*
		 * Cleans up event listeners 
		 */ 
		public function clear():void {
			p1Deck.removeEventListener(TouchEvent.TOUCH_BEGIN, player1);
			p2Deck.removeEventListener(TouchEvent.TOUCH_TAP, player2); 
			p1Tap.removeEventListener(TouchEvent.TOUCH_TAP, playerTap); 
			p2Tap.removeEventListener(TouchEvent.TOUCH_TAP, playerTap); 
		}

	}
	
}
