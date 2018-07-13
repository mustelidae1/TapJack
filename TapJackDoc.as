package  {
	
	import flash.display.MovieClip; 
	import flash.events.Event;

	import flash.ui.Multitouch; 
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;	
	
	import TapJack1; 
	
	/*
	* Driver class for TapJack. 
	* @author Olivia Thomas 
	*/ 
	public class TapJackDoc extends MovieClip {

		var playButton:MovieClip = new PlayButton(); 
		var instructionsButton:MovieClip = new InstructionsButton(); 
		var game:TapJack1; 
		
		/*
		*  Main method. 
		*/ 
		public function TapJackDoc() {
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			addEventListener(Event.ENTER_FRAME, update); 
			
			displayMenu(); 
			
		}
		
		/*
		* Displays the menu. 
		*/ 
		public function displayMenu() :void {
			addChild(playButton); 
			playButton.x = stage.stageWidth / 2; 
			playButton.y = stage.stageHeight / 2; 
			playButton.addEventListener(TouchEvent.TOUCH_BEGIN, playGame); 
			
			addChild(instructionsButton); 
			instructionsButton.x = stage.stageWidth / 2; 
			instructionsButton.y = stage.stageHeight / 3; 
			instructionsButton.addEventListener(TouchEvent.TOUCH_BEGIN, instructions); 
		}
		
		/*
		* Displays the instructions. 
		*/ 
		public function instructions(event:TouchEvent) :void {
			
		}
		
		/*
		* Initializes a new game. 
		*/ 
		public function playGame(event:TouchEvent) :void {
			playButton.removeEventListener(TouchEvent.TOUCH_BEGIN, playGame); 
			removeChild(playButton); 
			playButton.removeEventListener(TouchEvent.TOUCH_BEGIN, instructions); 
			removeChild(instructionsButton); 
			
			game = new TapJack1(this); 
			addChild(game); 
		}
		
		/*
		* Ends the current game. 
		*/ 
		public function endGame() :void {
			game.clear(); 
			removeChild(game); 
			displayMenu(); 
		}
		
		/*
		* Ends the current game and starts a new one. 
		*/ 
		public function rematch() :void {
			game.clear(); 
			removeChild(game); 
			game = new TapJack1(this); 
			addChild(game); 
		}
		
		/*
		* Update function - handles jack delay timer. 
		*/ 
		public function update(e:Event) :void {
			if (game != null) {
				game.jackTimer++; 
				//trace(game.jackTimer); 
				if (game.jackTimer < 10) {
					//trace("****JACK JACK JACK****");
				}
			}
		}

	}
	
}
