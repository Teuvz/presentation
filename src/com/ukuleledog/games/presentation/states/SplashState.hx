package com.ukuleledog.games.presentation.states;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import com.ukuleledog.games.presentation.elements.SplashThree;
import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;
import motion.Actuate;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class SplashState extends State
{
	
	private var background:Bitmap;
	private var curtain:Bitmap;
	private var three:SplashThree;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		
		var tempData:BitmapData = Assets.getBitmapData("img/splash-sprite.png",true);
		
		var backgroundData:BitmapData = new BitmapData(256, 224, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 0, 256, 224), new Point(0, 0));
		background = new Bitmap(backgroundData);
		//background.x = 75;
		//background.y = 35;
		addChild(background);
		
		three = new SplashThree();
		three.x = 115;
		three.y = 95;
		addChild( three );
		
		var curtainData:BitmapData = new BitmapData(256, 184, true);
		curtainData.copyPixels(tempData, new Rectangle(264, 0, 256, 184), new Point(0,0));
		curtain = new Bitmap(curtainData);
		//curtain.x = 75;
		//curtain.y = 35;
		addChild(curtain);
		
		Actuate.tween (curtain, 5, { y: -170 } );
		
		this.scaleX = 2;
		this.scaleY = 2;
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		
		removeChild(curtain);
		removeChild(three);
		removeChild(background);
		curtain = null;
		three = null;
		background = null;		
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
}