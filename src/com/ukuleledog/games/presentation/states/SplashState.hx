package com.ukuleledog.games.presentation.states;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import com.ukuleledog.games.presentation.elements.SplashThree;
import flash.display.Bitmap;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Timer;
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
	private var pressSpace:Bitmap;
	
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
		
		var spaceData:BitmapData = new BitmapData(84, 8, true);
		spaceData.copyPixels(tempData, new Rectangle(0, 265, 84, 8), new Point(0, 0) );
		pressSpace = new Bitmap( spaceData );
		pressSpace.x = 90;
		pressSpace.y = 160;
		pressSpace.alpha = 1;
		addChild( pressSpace );
		
		spaceHandle();
				
		Actuate.tween (curtain, 5, { y: -170 } );
		
		this.scaleX = 2;
		this.scaleY = 2;
	}
	
	private function spaceHandle()
	{
		if ( pressSpace.alpha == 0 )
		Actuate.tween(pressSpace, 2, { alpha:1 } ).onComplete(spaceHandle);
		else
		Actuate.tween(pressSpace, 2, { alpha:0 } ).onComplete(spaceHandle);
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		
		if ( e.keyCode != Keyboard.SPACE )
		return;
		
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