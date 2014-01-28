package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Frog;
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
	
	private var frog:Frog;
	private var frogTimer:Timer;
	private var frogCounter:UInt = 0;
	
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
		
		frog = new Frog();
		frog.y = 153;
		frog.x = -60;
		addChild( frog );
		
		frogTimer = new Timer(1000);
		frogTimer.addEventListener( TimerEvent.TIMER, frogHandle );
		frogTimer.start();
		
		var spaceData:BitmapData = new BitmapData(84, 8, true);
		spaceData.copyPixels(tempData, new Rectangle(0, 265, 84, 8), new Point(0, 0) );
		pressSpace = new Bitmap( spaceData );
		pressSpace.x = 90;
		pressSpace.y = 160;
		pressSpace.alpha = 0;
		addChild( pressSpace );
		
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
	
	private function frogHandle( e:TimerEvent )
	{
		switch( frog.currentAnimation )
		{
			case 'idle':
				frog.setAnimation('jump');
				frogTimer.delay = 100;
				frog.x += 5;
			case 'jump':
				frog.setAnimation('high');
				frogTimer.delay = 100;
				frog.x += 5;
			case 'high':
				frog.setAnimation('idle');
				frogTimer.delay = 1000;
		}
		
		if ( frog.x == 270 )
			frog.x = -60;
			
		if ( ++frogCounter == 15 )
		{
			spaceHandle();
		}
	}
	
	private function spaceHandle()
	{
		if ( pressSpace.alpha == 0 )
		Actuate.tween(pressSpace, 1, { alpha:1 } ).onComplete(spaceHandle);
		else
		Actuate.tween(pressSpace, 1, { alpha:0 } ).onComplete(spaceHandle);
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