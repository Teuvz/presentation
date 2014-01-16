package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Celes;
import com.ukuleledog.games.presentation.elements.Edgar;
import com.ukuleledog.games.presentation.elements.Locke;
import com.ukuleledog.games.presentation.elements.Mario;
import com.ukuleledog.games.presentation.elements.Terra;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import com.ukuleledog.games.presentation.elements.SplashThree;
import flash.display.Bitmap;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;
import motion.Actuate;
import motion.easing.Bounce;
import motion.easing.Elastic;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class FightState extends State
{
	
	private var introTimer:Timer;
	
	private var background:Bitmap;
	
	private var hud:Bitmap;
	private var ennemyName:Bitmap;
	
	private var mario:Mario;
	private var tube:Bitmap;
	private var octo:Bitmap;
	private var terra:Terra;
	private var edgar:Edgar;
	private var locke:Locke;
	private var celes:Celes;
	
	private var cursorPosition:UInt = 0;
	private var cursor:Bitmap;
	private var menuMain:Bitmap;
	private var menuPrizee:Bitmap;
	private var menuF4:Bitmap;
	private var menuUbi:Bitmap;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		
		var backgroundData:BitmapData = new BitmapData(240, 147, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 0, 240, 147), new Point(0, 0));
		background = new Bitmap(backgroundData);
		background.x = 7;
		background.y = 10;
		addChild(background);
		
		var tempOctoData:BitmapData = new BitmapData(64, 47, true);
		tempOctoData.copyPixels( tempData, new Rectangle(0, 195, 64, 47), new Point(0, 0) );
		octo = new Bitmap(tempOctoData);
		octo.y = 120;
		octo.x = 30;
		addChild(octo);
		
		mario = new Mario();
		addChild(mario);
		mario.setAnimation('super-jump');
		mario.x = 42;
		mario.y = 0;
				
		terra = new Terra();
		terra.x = 190;
		terra.y = 70;
		addChild( terra );
		
		edgar = new Edgar();
		edgar.x = 195;
		edgar.y = 90;
		addChild( edgar );
		
		locke = new Locke();
		locke.x = 200;
		locke.y = 110;
		addChild( locke );
		
		celes = new Celes();
		celes.x = 205;
		celes.y = 130;
		addChild( celes );
		
		var tempTubeData:BitmapData = new BitmapData(32, 48, true);
		tempTubeData.copyPixels( tempData, new Rectangle(0, 147,32,48), new Point(0,0) );
		tube = new Bitmap(tempTubeData);
		tube.scaleY = -1;
		tube.x = 35;
		tube.y = 26;
		addChild( tube );
		
		var tempHudData:BitmapData = new BitmapData(240, 55, false);
		tempHudData.copyPixels( tempData, new Rectangle(0, 360, 240, 55), new Point(0, 0));
		hud = new Bitmap(tempHudData);
		hud.x = 7;
		hud.y = 160;
		addChild(hud);
		
		var tempEnnemy:BitmapData = new BitmapData(31, 8, true);
		tempEnnemy.copyPixels( tempData, new Rectangle(0, 420, 31, 8), new Point(0, 0) );
		ennemyName = new Bitmap(tempEnnemy);
		ennemyName.x = 15;
		ennemyName.y = 170;
		addChild(ennemyName);
		
		var tempMenuMain:BitmapData = new BitmapData(80, 55, true);
		tempMenuMain.copyPixels( tempData, new Rectangle(0, 460, 80, 55), new Point(0, 0) );
		menuMain = new Bitmap(tempMenuMain);
		menuMain.x = 20;
		menuMain.y = 165;
		addChild(menuMain);
		
		var tempMenuPrizee:BitmapData = new BitmapData(80, 55, true);
		tempMenuPrizee.copyPixels( tempData, new Rectangle(80, 460, 80, 55), new Point(0, 0) );
		menuPrizee = new Bitmap(tempMenuPrizee);
		menuPrizee.x = 25;
		menuPrizee.y = 170;
		addChild(menuPrizee);
		
		var tempMenuF4:BitmapData = new BitmapData(80, 55, true);
		tempMenuF4.copyPixels( tempData, new Rectangle(160, 460, 80, 55), new Point(0, 0) );
		menuF4 = new Bitmap(tempMenuF4);
		menuF4.x = 25;
		menuF4.y = 170;
		addChild(menuF4);
		
		var tempCursor:BitmapData = new BitmapData(16, 16, true);
		tempCursor.copyPixels( tempData, new Rectangle(0, 430, 16, 16), new Point(0, 0) );
		cursor = new Bitmap(tempCursor);
		addChild(cursor);
		
		this.scaleX = 2;
		this.scaleY = 2;
		
		musicChannel = Assets.getSound("snd/smb3_pipe.wav",true).play();
		musicChannel.addEventListener( Event.SOUND_COMPLETE, introTwo );
		Actuate.tween( mario, 1.5, {y : 25} );
	}
	
	private function introTwo( e:Event )
	{
		musicChannel.removeEventListener( Event.SOUND_COMPLETE, introTwo );
		
		introTimer = new Timer(1000);
		introTimer.addEventListener( TimerEvent.TIMER, introThree );
		introTimer.start();
						
		Actuate.tween( mario, 1.5, { y : 120 } ).ease(Bounce.easeOut);
		Assets.getSound("snd/smb3_stomp.wav", true).play();
	}
	
	private function introThree( e:TimerEvent )
	{
		introTimer.removeEventListener( TimerEvent.TIMER, introThree );
		introTimer.stop();
		introTimer = null;
		
		Actuate.tween( octo, 0.5, { alpha: 0 } ).onComplete(introFour);
		Actuate.tween( ennemyName, 0.5, { alpha: 0 } );
		
		mario.setAnimation('super-idle');		
		
	}
	
	private function introFour()
	{
		Actuate.tween( tube, 2, { y:0 } );
		//musicChannel = Assets.getMusic("music/ff6.mp3").play();
		
		removeChild(ennemyName);
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		var tempEnnemy:BitmapData = new BitmapData(54, 8, true);
		tempEnnemy.copyPixels( tempData, new Rectangle(40, 420, 54, 8), new Point(0, 0) );
		ennemyName = new Bitmap(tempEnnemy);
		ennemyName.x = 15;
		ennemyName.y = 170;
		ennemyName.alpha = 0;
		addChild(ennemyName);
		Actuate.tween( ennemyName, 0.5, { alpha: 1 } );
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
	
		
	
	
	}
	
}