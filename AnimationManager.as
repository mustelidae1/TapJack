package  {
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	import fl.transitions.TweenEvent; 
	import fl.transitions.Tween; 	
	import flash.display.MovieClip;
	
	/* 
	 * Handles all game animations using greensock.  
	 *   @author Olivia Thomas 
	 */ 
	public class AnimationManager extends MovieClip {
		
		/* 
		 * Zoom in animation
		 */
		public static function ZoomIn(mc:MovieClip) {
			var targetWidth:int = mc.width; 
			var targetHeight:int = mc.height; 
			mc.width = targetWidth / 5; 
			mc.height = targetWidth / 5; 
			TweenLite.to(mc, 0.4, {width: targetWidth + 10, height:targetHeight + 10, 
				onComplete:function(){TweenLite.to(mc, 0.2, {width: targetWidth, height: targetHeight})}}); 
		}
		
		/*
		 * Zoom out animation
		 */ 
		public static function ZoomOut(mc:MovieClip) {
			var origWidth:int = mc.width; 
			var origHeight:int = mc.height; 
			TweenLite.to(mc, 0.2, {width: origWidth + 10, height: origHeight + 10, 
				onComplete:function(){TweenLite.to(mc, 0.4, {width: 0, height: 0})}}); 
		}
		
		/*
		 * Horizontal translation to specified x position
		 */ 
		public static function MoveCardHorizontal(mc:MovieClip, xValue:int, callback:Function) {
			TweenLite.to(mc, 1, {x:xValue, y:"0", onComplete:callback}); 
		}
		
		/*
		 * Vertical translation to specified y position
		 */ 
		public static function moveCard(mc:MovieClip, yValue:int, callback:Function) {
			TweenLite.to(mc, 1, {x:"0", y:yValue, onComplete:callback}); // y was stage.stageHeight
		}
		
		/*
		 * Translation down relative 50 units 
		 */
		public static function layCardDown(mc:MovieClip) {
			TweenLite.to(mc, 1, {y:"-=50"}); 
		}
		
		/* 
		 * Translation up relative 50 units 
		 */ 
		public static function layCardUp(mc:MovieClip) {
			TweenLite.to(mc, 1, {y:"+=50"});
		}
		
		/* 
		 * Increase width by the specified value
		 */ 
		public static function IncreaseWidth(mc:MovieClip, amount:int) {
			TweenLite.to(mc, 1, {width: amount});
		}
	}
}
