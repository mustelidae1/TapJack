﻿package  {
	
	import flash.display.MovieClip; 
	import flash.events.Event;

	import flash.ui.Multitouch; 
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;	
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	import fl.transitions.TweenEvent; 
	import fl.transitions.Tween; 
	
	import Card; 
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	
	
	/*
	* Main TapJack game code
	* @author Olivia Thomas 
	*/
	public class TapJack extends MovieClip {
		
		private var deck:Array = new Array(); 
		private var player1Deck:Array = new Array(); 
		private var player2Deck:Array = new Array(); 
		
		private var p1Deck:MovieClip = new P1Deck(); 
		private var p2Deck:MovieClip = new P2Deck(); 
		private var p1Progress:MovieClip = new Player1Progress(); 
		private var p2Progress:MovieClip = new Player2Progress(); 
		private var p1Tap:MovieClip = new Player1Tap(); 
		private var p2Tap:MovieClip = new Player2Tap(); 
		private var winText:MovieClip = new WinText(); 
		private var p1Text = new Player1Text(); 
		private var p2Text = new Player2Text(); 
		private var tap = new Tap(); 
		private var miniMen1 = new MiniMenuButton(); 
		private var miniMen2 = new MiniMenuButton(); 
		private var menuButton = new MenuButton(); 
		private var rematchButton = new RematchButton(); 
		
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
		public function TapJack(driver:TapJackDoc) {
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.driver = driver;
			createDeck(); 
			shuffleDeck();
			splitDeck(); 
			
			addEventListener(Event.ADDED_TO_STAGE, setUpStage);
		}
		
		//////////////////////////////////
		// GAME EVENTS 
		//////////////////////////////////
		
		/*
		* Called when player 1 taps a jack. 
		* Transfers current deck to player 1 and 
		* determines whether player 1 has won. 
		*/ 
		function playerTap(event: TouchEvent) :void {
			if (currentCard != null && currentCard.getValue() == 11 && animationInProgress == false) { 
				var deckSize:int = deck.length; 
				var cardsMoved:int = 0; 
				if (event.target == p1Tap) {
					p1Progress.width += progressWidth * deckSize;
				} else if (event.target == p2Tap) {
					p2Progress.width += progressWidth * deckSize; 
					p2Progress.x = stage.stageWidth - p2Progress.width; 
				}
				for (var i:int = 0; i < deckSize; i++) {
					cardsMoved++; 
					if (deck[i] != null && deck[i].getCard().stage) {
						if (event.target == p1Tap) {
							TweenLite.to(deck[i].getCard(), 1, {x:"0", y:stage.stageHeight, onComplete:function(){destroyEverything(deckSize, cardsMoved, 1)}}); 
						} else if (event.target == p2Tap) {
							TweenLite.to(deck[i].getCard(), 1, {x:"0", y:0, onComplete:function(){destroyEverything(deckSize, cardsMoved, 2)}});
						}
					} 
					 
				}
			} 
			if (player2Deck.length <= 1) {
				trace("player 1 wins!"); 
				winner(1); 
			}
		}
		
		/* 
		* Called when player 1 lays down a card. 
		* Moves the card to the deck and determines 
		* if player 1 has lost. 
		*/ 
		function player1(event: TouchEvent) :void {
			trace("player 1!"); 
			
			if (player1Turn == true && player1Deck.length > 0 && animationInProgress == false && jackTimer > JACK_DELAY) {
				var cardPlayed = player1Deck.shift();
				trace(cardPlayed); 
				deck.push(cardPlayed); 
				currentCard = cardPlayed;
				cardPlayed = cardPlayed.getCard(); 
				cardsLayer.addChild(cardPlayed); 
				cardPlayed.x = stage.stageWidth / 2; 
				cardPlayed.y = (stage.stageHeight / 2) + 50; 
				cardPlayed.rotation = Math.random() * 5;
				TweenLite.to(cardPlayed, 1, {y:"-=50"});
				p1Progress.width -= progressWidth; 
				removeCard(); 
				addEventListener(TouchEvent.TOUCH_END, player1EndTouch); 
				//touchLayer.addChild(tap);
				//tap.x = event.stageX; 
				//tap.y = event.stageY; 
				// If this is a jack, set delay timer
				if (currentCard.getValue() == 11) {
					jackTimer = 0; 
				}
				// Check if this is player1's last card (player2 wins) 
				if (player1Turn == true && player1Deck.length == 0) {
					trace("Player 2 wins!"); 
					p1Progress.alpha = 0; 
					winner(2); 
				}
				yourTurn(2); 
			}
			
			
		}
		
		function player1EndTouch(event: TouchEvent) :void {
			//touchLayer.removeChild(tap); 
		}
		
		/* 
		* Called when player 2 lays down a card. 
		* Moves the card to the deck and determines 
		* if player 2 has lost. 
		*/ 
		function player2(event: TouchEvent) :void {
			trace("player 2!"); 
			
			if (player1Turn == false && player2Deck.length > 0 && animationInProgress == false && jackTimer > JACK_DELAY) {
				var cardPlayed = player2Deck.shift(); 
				trace(cardPlayed); 
				deck.push(cardPlayed); 
				currentCard = cardPlayed; 
				cardPlayed = cardPlayed.getCard();  // TODO: This line causes a bug occasionally. Why? 
				cardsLayer.addChild(cardPlayed); 
				cardPlayed.x = stage.stageWidth / 2; 
				cardPlayed.y = (stage.stageHeight / 2) - 50; 
				cardPlayed.rotation = Math.random() * -5; 
				TweenLite.to(cardPlayed, 1, {y:"+=50"});
				p2Progress.width -= progressWidth; 
				p2Progress.x = stage.stageWidth - p2Progress.width; 
				if (deck.length > 10 && deck[0].getCard().stage) {
					cardsLayer.removeChild(deck[0].getCard());
					trace("card removed"); 
				}
				removeCard(); 
				// If this is a jack, set delay timer
				if (currentCard.getValue() == 11) {
					jackTimer = 0; 
				}
				// Check if this is player2's last card (player1 wins) 
				if (player1Turn == false && player2Deck.length == 0) {
					trace("Player 1 wins!"); 
					p2Progress.alpha = 0; 
					winner(1); 
				}
				yourTurn(1);  
			}
			
			
		}
		
		/*
		*Determines whose turn it is. 
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
				touchLayer.removeChild(p2Deck); 
 			} else if (player == 2) {
				winText.y = stage.stageHeight / 4; 
				winText.rotation = 180; 
				touchLayer.removeChild(p1Deck); 
			}
			
			addChild(menuButton); 
			menuButton.x = stage.stageWidth / 4; 
			menuButton.y = stage.stageHeight / 2; 
			menuButton.addEventListener(TouchEvent.TOUCH_BEGIN, menu); 
			addChild(rematchButton); 
			rematchButton.x = 3 * (stage.stageWidth / 4); 
			rematchButton.y = stage.stageHeight / 2; 
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
		* Creates a new deck of cards in order. 
		*/ 
		private function createDeck() :void {
			var i:int; 
			var j:int; 
			for (i = 1; i <= 4; i++) {
				for (j = 1; j <= 13; j++) {
					var card = new Card(i, j); 
					deck.push(card); 
				}
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
		
		/*
		* Splits the deck into two equal decks. 
		*/
		private function splitDeck() :void {
			var deck1:Boolean = true; 
			
			for (var k:Number = 0; k < 52; k++) {
				 
				if (deck1 == true) {
					player1Deck.push(deck.shift()); 
					deck1 = false; 
				} else if (deck1 == false) {
					player2Deck.push(deck.shift()); 
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
			if (deck.length > 5) {
				var found:Boolean; 
				var count:Number = 0; 
				while (found == false) {
					if (deck[count].getCard().stage) {
						cardsLayer.removeChild(deck[count].getCard()); 
						found = true; 
						trace("card removed"); 
					}
					count++; 
				}
			}
		}
		
		/*
		*  Destroys all instances of cards displayed onscreen and adds those cards to 
		*  the respective player's deck. 
		*/ 
		function destroyEverything(deckSize:int, cardsMoved:int, player:int) {
			trace("EXTERMINATE"); 
			trace(deckSize, cardsMoved); 
			animationInProgress = true; 
			if (deckSize == cardsMoved) {
				for (var j:int; j < deckSize; j++) {
					if (deck[0] != null && deck[0].getCard().stage) {
						cardsLayer.removeChild(deck[0].getCard()); 
					}
					if (player == 1) {
						player1Deck.push(deck[0]); 
					} else {
						player2Deck.push(deck[0]); 
					}
					deck.shift(); 
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
			p1Deck.y = stage.stageHeight; 
			p1Deck.addEventListener(TouchEvent.TOUCH_BEGIN, player1);
			
			touchLayer.addChild(p2Deck); 
			p2Deck.x = stage.stageWidth / 2; 
			p2Deck.y = 0; 
			p2Deck.addEventListener(TouchEvent.TOUCH_TAP, player2); 
			trace("setup complete"); 
			
			touchLayer.addChild(p1Progress); 
			p1Progress.x = 0; 
			p1Progress.y = stage.stageHeight - p1Progress.height; 
			p1Progress.width = stage.stageWidth / 2; 
			
			touchLayer.addChild(p2Progress); 
			p2Progress.width = stage.stageWidth / 2; 
			p2Progress.x = stage.stageWidth - p2Progress.width; 
			
			progressWidth = p1Progress.width / 26;
			
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
			
			//touchLayer.addChild(miniMen1); 
			//miniMen1.x = stage.stageWidth / 4; 
			//miniMen1.y = stage.stageHeight / 40; 
			
			//touchLayer.addChild(miniMen2); 
			//miniMen2.x = 1; 
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
