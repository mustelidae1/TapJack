package  {
	
	import flash.display.MovieClip; 
	import flash.events.Event;

	import flash.ui.Multitouch; 
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;	

	import AnimationManager; 
	
	import TapJack1; 
	
	/*
	 * Driver class for TapJack. 
	 * @author Olivia Thomas 
	 */ 
	public class TapJackDoc extends MovieClip {

		var playButton:MovieClip = new PlayButton(); 
		var instructionsButton:MovieClip = new HelpButton(); 
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
			playButton.addEventListener(TouchEvent.TOUCH_BEGIN, playPressed); 
			
			addChild(instructionsButton); 
			instructionsButton.x = stage.stageWidth / 2; 
			instructionsButton.y = stage.stageHeight - instructionsButton.height; 
			instructionsButton.addEventListener(TouchEvent.TOUCH_BEGIN, instructions); 
		}
		
		/*
		 * Displays the instructions. 
		 */ 
		public function instructions(event:TouchEvent) :void {
			
		}
		 
		/*
		 * Called when the play button is pressed; initiates animations 
		 */ 
		public function playPressed(event:TouchEvent) :void {
			playButton.removeEventListener(TouchEvent.TOUCH_BEGIN, playGame); 
			instructionsButton.removeEventListener(TouchEvent.TOUCH_BEGIN, instructions); 
			AnimationManager.ZoomOut(instructionsButton);
			
			AnimationManager.MoveCardHorizontal(playButton, stage.stageWidth + playButton.width, function(){playGame()}); 
			
		}
		
		/*
		 * Initializes a new game. 
		 */ 
		private function playGame() :void {
			removeChild(playButton); 
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
