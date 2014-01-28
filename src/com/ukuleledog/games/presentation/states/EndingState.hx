package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Bowser;
import com.ukuleledog.games.presentation.elements.Frog;
import com.ukuleledog.games.presentation.elements.Mario;
import flash.display.BitmapData;
import flash.display.Sprite;
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
import motion.easing.Bounce;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class EndingState extends State
{
	
	private var background:Sprite;
	private var mario:Mario;
	private var tube:Bitmap;
	private var bowser:Bowser;
	private var octo:Bitmap;
	private var octo2:Bitmap;
	private var tentacles:Bitmap;
	private var cameraFollow:Bool = true;
	private var cameraOffset:UInt = 120;
	private var step:UInt = 0;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
				
		var tempData:BitmapData = Assets.getBitmapData("img/ending-sprite.png",true);
		
		var backgroundData:BitmapData = new BitmapData(1235, 434, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 0, 1235, 434), new Point(0, 0));
		background = new Sprite();
		background.addChild( new Bitmap(backgroundData) );
		background.y = -200;
		addChild(background);
	
		mario = new Mario();
		mario.y = 340;
		background.addChild( mario );
		mario.setAnimation('super-walk');
		
		var tubeData:BitmapData = new BitmapData(207, 33, true);
		tubeData.copyPixels( tempData, new Rectangle(0, 659, 207, 33), new Point(0, 0) );
		tube = new Bitmap(tubeData);
		tube.x = 356;
		tube.y = 336;		
		background.addChild( tube );
		
		var tempOcto:BitmapData = new BitmapData(64, 47, true);
		tempOcto.copyPixels( tempData, new Rectangle(0, 692, 64, 47), new Point(0, 0) );
		octo = new Bitmap(tempOcto);
		octo.y = 340;
		octo.x = mario.x - 60;
		background.addChild( octo );
		
		tempOcto = new BitmapData(54, 32, true);
		tempOcto.copyPixels( tempData, new Rectangle(64, 692, 54, 32), new Point(0, 0) );
		octo2 = new Bitmap(tempOcto);
		octo2.y = 430;
		octo2.x = 1080;
		background.addChild( octo2 );
		
		bowser = new Bowser();
		bowser.x = 1150;
		bowser.y = 100;
		background.addChild( bowser );
		
		tempOcto = new BitmapData(62, 65, true);
		tempOcto.copyPixels( tempData, new Rectangle(118, 692, 62, 65), new Point(0, 0) );
		tentacles = new Bitmap(tempOcto);
		tentacles.x = 1080;
		tentacles.y = 350;
		tentacles.alpha = 0;
		background.addChild(tentacles);
			
		this.scaleX = 2;
		this.scaleY = 2;
		
		addEventListener( Event.ENTER_FRAME, loop );
		Assets.getSound('snd/ff6/4EDeathSpell.mp3',true).play();
	}
	
	private function loop( e:Event )
	{
		
		if ( step < 1 )
			octo.x += 10;
		
		if ( step < 2 || step == 3 )
			mario.x += 10;
			
		if ( step == 0 && mario.x == 350 )
			step = 1;
		else if ( step == 1 && mario.x == 360 )
		{
			step = 2;
			Assets.getSound('snd/smb3_pipe.wav',true).play();
		}
			
		if ( step == 2 && mario.x == 360 )
			haxe.Timer.delay(function() { step = 3; }, 3000);
			
		if ( mario.x == 500 )
		{
			Assets.getSound('snd/smb3_pipe.wav', true).play();
			musicChannel = Assets.getSound('music/castle.mp3',true).play();
		}
			
		if ( step == 3 && mario.x == 1000 )
		{
			step = 4;
			mario.setAnimation('super-idle');
			
			return;
		}
		
		if ( step == 4 && cameraOffset > 20 )
			cameraOffset--;
		
		if ( step == 4 && cameraOffset == 20 && bowser.y == 100 )
		{
			Actuate.tween( bowser, 3, { y:326 } ).ease(Bounce.easeOut).onComplete(function() {
				step = 5;
			});
		}
		
		if ( step == 5 && bowser.x > 1100 )
			bowser.x--;
		else if ( step == 5 )
			step = 6;
					
		if ( step == 6 && octo2.y > 390 )
			octo2.y--;
		else if ( step == 6 )
		{
			Assets.getSound('snd/ff6/4EDeathSpell.mp3',true).play();
			step = 7;
		}
			
		if ( step == 7 && tentacles.alpha == 0 )
		{
			Actuate.tween( tentacles, 2, { alpha:1 } ).onComplete(function() {
				
				musicChannel.stop();
				bowser.setAnimation('surprised');
				
				Actuate.tween( tentacles, 2, { y: 320 } ).onComplete(function() {
					Actuate.tween(tentacles, 2, { y: 350 } );
					Actuate.tween(bowser, 2, { y: 356 } ).onComplete(function() {
						Assets.getSound('snd/koopa.mp3',true).play();
						bowser.setAnimation('falling');
						Actuate.tween(octo2, 2, { y:450 } );
						Actuate.tween(tentacles, 2, { y:450 } );
						Actuate.tween(bowser, 2, { y:450 } ).onComplete(function() {
							step = 9;
							mario.setAnimation('super-walk');
							cameraFollow = false;
						});
					});
				});
				step = 8;
			});
		}
		
		if ( step == 9 && mario.x < 1210 )
			mario.x += 5;
		else if ( step == 9 )
		{
			mario.setAnimation('super-idle');
			Actuate.tween( mario, 2, { alpha:0 } ).onComplete(function() {
				Actuate.tween( background, 2, {alpha:0} ).onComplete(function() {
					step = 10;
					removeEventListener( Event.ENTER_FRAME, loop );
					dispatchEvent( new Event(Event.COMPLETE) );
				});
			});
		}
			
		moveCamera();
	}
	
	private function moveCamera()
	{
		if ( !cameraFollow )
			return;
			
		background.x = -mario.x + cameraOffset;
	}
	
}