package com.ukuleledog.games.presentation.states;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import com.ukuleledog.games.presentation.elements.Coin;
import com.ukuleledog.games.presentation.elements.ItemBox;
import com.ukuleledog.games.presentation.elements.LanguageText;
import com.ukuleledog.games.presentation.elements.Mario;
import com.ukuleledog.games.presentation.elements.MarioNumber;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.SoundChannel;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.Vector.Vector;
import motion.Actuate;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class MarioState extends State
{
	
	private var keyPressed:Bool = false;
	private var pressedKey:UInt = 0;
	private var inputKeys:Map<Int, Bool>;
	
	private var level:Sprite;
	private var hud:Sprite;
	
	private var mario:Mario;
	private var itemBox:ItemBox;
	private var mushroom:Bitmap;
	private var mushroomActive:Bool;
	private var tube:Bitmap;
	private var coins:Vector<Coin>;
	
	private var coinsCounter:UInt = 0;
	private var number1:MarioNumber;
	private var number2:MarioNumber;
		
	private var brick1:Bitmap;
	private var brick2:Bitmap;
	private var brick3:Bitmap;
	private var brick4:Bitmap;
	
	private var instructionText:Bitmap;
	private var languageText:LanguageText;
	private var languageTextTimer:Timer;
	
	public function new() 
	{
		super();
		inputKeys = new Map();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );	
		
		var tempData:BitmapData = Assets.getBitmapData("img/mario-sprite.png", true);
		
		var backgroundData:BitmapData = new BitmapData(2000,432, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 272, 2000, 432), new Point(0, 0));
		level = new Sprite();
		level.addChild( new Bitmap(backgroundData) );
		addChild(level);
		
		var instructionData:BitmapData = new BitmapData(210, 39, true);
		instructionData.copyPixels( tempData, new Rectangle(0, 773, 210, 39), new Point(0, 0) );
		instructionText = new Bitmap(instructionData);
		instructionText.x = 20;
		instructionText.y = 325;
		level.addChild( instructionText );
		
		var hudData:BitmapData = new BitmapData(224, 28, true);
		hudData.copyPixels(tempData, new Rectangle(0, 706, 224, 28), new Point(0, 0) );
		hud = new Sprite();
		hud.addChild( new Bitmap(hudData) );
		hud.y = 175;
		hud.x = 1;
		hud.scaleX = 1.14;
		hud.scaleY = 1.14;
		addChild(hud);
	
		coins = new Vector<Coin>();
		generatePhp();
		generateJava();
		generateAS3();
		generateCs();
		
		var tempShroom:BitmapData = new BitmapData(16, 16, true);
		tempShroom.copyPixels( tempData, new Rectangle(16, 208, 16, 16), new Point(0, 0) );
		mushroom = new Bitmap(tempShroom);
		mushroom.x = 1700;
		mushroom.y = 353;
		level.addChild(mushroom);
		
		itemBox = new ItemBox();
		itemBox.x = 1700;
		itemBox.y = 353;
		level.addChild(itemBox);
		
		mario = new Mario();
		mario.x = 100;
		mario.y = 402;
		level.addChild(mario);
		
		var tempTube:BitmapData = new BitmapData(32, 48);
		tempTube.copyPixels( tempData, new Rectangle(0, 224, 32, 48), new Point(0, 0) );
		tube = new Bitmap(tempTube);
		tube.y = 369;
		tube.x = 1857;
		level.addChild( tube );
		
		var tempBrick:BitmapData = new BitmapData(16, 16, true);
		tempBrick.copyPixels( tempData, new Rectangle(0, 192, 16, 16), new Point(0, 0) );
		brick1 = new Bitmap( tempBrick );
		brick2 = new Bitmap( tempBrick );
		brick3= new Bitmap( tempBrick );
		brick4 = new Bitmap( tempBrick );
		
		brick1.x = 1857;
		brick1.y = 337;
		level.addChild( brick1 );
		
		brick2.x = 1873;
		brick2.y = 337;
		level.addChild( brick2 );
		
		brick3.x = 1857;
		brick3.y = 353;
		level.addChild( brick3 );
		
		brick4.x = 1873;
		brick4.y = 353;
		level.addChild( brick4 );
		
		number1 = new MarioNumber();
		number1.x = 132;
		number1.y = 7;
		hud.addChild( number1 );
		
		number2 = new MarioNumber();
		number2.x = 140;
		number2.y = 7;
		hud.addChild( number2 );
		
		languageText = new LanguageText();
		languageText.alpha = 0;
		level.addChild( languageText );
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		addEventListener( Event.ENTER_FRAME, loop );
		
		this.scaleX = 2;
		this.scaleY = 2;
		
		languageTextTimer = new Timer(3000);
		languageTextTimer.addEventListener( TimerEvent.TIMER, languageTimerHandle );
		
		musicChannel = Assets.getSound("music/mario.mp3").play();
	}
		
	private function keyDownHandle( e:KeyboardEvent )
	{		
		inputKeys.set( e.keyCode, true );
	}
	
	private function keyUpHandle( e:KeyboardEvent )
	{		
		inputKeys.set( e.keyCode, false );
	}
	
	private function loop( e:Event )
	{	
		
		var moving:Bool = false;
		
		if ( inputKeys.get(Keyboard.RIGHT) == true && mario.x < 2000 )
		{
			mario.moveRight();
			moving = true;
		}
		
		if ( inputKeys.get(Keyboard.LEFT) == true && mario.x > 0 )
		{
			mario.moveLeft();
			moving = true;
		}
			
		if ( inputKeys.get(Keyboard.SPACE) == true )
		{
			mario.jump();
			moving = true;
		}
		
		if ( !moving )
			mario.stopMove();
		
		manageCollisions();
		manageCoins();
		manageShroom();
			
		moveCamera();
		
		if ( mario.scaleX == 1 )
			languageText.x = mario.x - 35;
		else
			languageText.x = mario.x - 51;
		languageText.y = mario.y - 10;
	}
	
	private function manageShroom()
	{
		
		if ( !mushroomActive )
		return;
		
		if ( mushroom.x >= 192 && mushroom.y < 402 )
			mushroom.y += 10;
			
		if ( mushroom.y > 402 )
		mushroom.y = 402;
		
		if ( mushroom.x < 1840 )
			mushroom.x += 5;
			
		if ( mario.hitTestObject(mushroom) )
		{
			Assets.getSound('snd/smb3_power-up.wav', true).play();
			mario.status = 'super';
			level.removeChild( mushroom );
			mushroomActive = false;
			mushroom = null;
		}
		
	}
	
	private function manageCoins()
	{
		
		var num:UInt = coins.length;

		while ( num-- > 0 )
		{
			if ( mario.hitTestObject(coins[num]) )
			{
				level.removeChild( coins[num] );
				coins.splice(num, 1);
				Assets.getSound('snd/coin.mp3', true).play();				
				if ( coinsCounter <= 99 )
				{			
					var coinString:String = '';
					
					if ( coinsCounter < 10 )
						coinString = '0';
						
					coinString += Std.string(coinsCounter);
					
					number1.setAnimation(coinString.charAt(0));
					number2.setAnimation(coinString.charAt(1));
					
				}
				
				if ( coinsCounter == 42 || coinsCounter == 84 || coinsCounter == 126 || coinsCounter == 167 )
				{
					Assets.getSound('snd/1up.mp3', true).play();
										
					if ( brick1 != null )
					{
						level.removeChild( brick1 );
						brick1 = null;
						
					} else if ( brick2 != null )
					{
						level.removeChild( brick2 );
						brick2 = null;
						languageText.setAnimation('java');
					} else if ( brick3 != null )
					{
						level.removeChild( brick3 );
						brick3 = null;
						languageText.setAnimation('as3');
					} else if ( brick4 != null )
					{
						level.removeChild( brick4 );
						brick4 = null;
						languageText.setAnimation('csharp');
					}
					
					languageText.alpha = 1;
					languageTextTimer.start();
					
				}
				
				coinsCounter++;
			}			
		}
	
	}
	
	private function languageTimerHandle( e:TimerEvent )
	{
		languageTextTimer.stop();
		
		languageText.alpha = 0;
	}
	
	private function manageCollisions()
	{
		
		if ( brick1 != null && brick2 != null && brick3 != null && brick4 != null && mario.x > 1842 )
		{
			mario.x = 1842;
			return;
		}
		
		if ( mario.status == 'small' && mario.y < 402 )
		{
			mario.onFloor = false;
			mario.y += 5;
		} else if ( mario.status == 'small' ) {
			mario.y = 402;
			mario.onFloor = true;
		} else if ( mario.status == 'super' && mario.y < 342 && mario.x >= tube.x && brick1 == null && brick2 == null && brick3 == null && brick4 == null ) // end tube
		{
			mario.onFloor = true;
			mario.jumping = false;
			mario.y = 342;
			mario.x = 1865;
			endState();
		}
		else if ( mario.status == 'super' && mario.y < 390 )
		{
			mario.onFloor = false;
			mario.y += 5;
		} else {
			mario.y = 390;
			mario.onFloor = true;
		}
				
		if ( !itemBox.empty() &&  mario.hitTestObject( itemBox ) )
		{
			Assets.getSound("snd/smb3_bump.wav", true).play();
			Assets.getSound("snd/smb3_mushroom_appears.wav",true).play();
			itemBox.hit();
			mario.y = itemBox.y + itemBox.height;
			mario.jumping = false;
			
			Actuate.tween( mushroom, 2, { y:337 } ).onComplete(function() {
				mushroomActive = true;
			});
			
		} else if ( itemBox.empty() &&  mario.hitTestObject( itemBox ) )
		{
			Assets.getSound("snd/smb3_bump.wav", true).play();
			mario.jumping = false;
		}
		
	}
	
	private function endState()
	{		
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		removeEventListener( Event.ENTER_FRAME, loop );
		
		Assets.getSound('snd/smb3_pipe.wav', true).play();
		
		Actuate.tween( mario, 3, { y:390 } ).onComplete(function() {
			if ( musicChannel != null )
			musicChannel.stop();
			dispatchEvent( new Event(Event.COMPLETE) );
		});
	}
	
	private function moveCamera()
	{		
		if ( (-mario.x) < -122 && (-mario.x) > - 1865 )
			level.x = -mario.x + 120;
		
		level.y = -252;
	}
	
	private function generatePhp()
	{
		
		///// P /////
		// P1
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 266;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 282;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		// P2
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 298;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		// P3
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 298;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		// P4
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 266;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 282;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		// P5
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		// P6
		var coin:Coin = new Coin();
		coin.x = 250;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		///// H /////
		// H1
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 330;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		// H2
		var coin:Coin = new Coin();
		coin.x = 346;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 346;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		// H3
		var coin:Coin = new Coin();
		coin.x = 362;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 362;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		// H4
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 380;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		///// P /////
		// P1
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 433;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 449;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		// P2
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 465;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		// P3
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 465;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		// P4
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 433;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 449;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		// P5
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		// P6
		var coin:Coin = new Coin();
		coin.x = 417;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
	}
	
	private function generateJava()
	{
		// J1
		var coin:Coin = new Coin();
		coin.x = 539;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 555;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 571;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 587;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
	
		var coin:Coin = new Coin();
		coin.x = 603;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 571;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 571;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 571;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 571;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 555;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 544;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		///// A /////
		var coin:Coin = new Coin();
		coin.x = 635;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 635;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 635;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 635;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 635;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 699;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 699;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 699;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 699;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 699;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 651;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 667;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 683;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 651;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 667;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 683;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		///// V /////
		
		var coin:Coin = new Coin();
		coin.x = 731;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 731;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 731;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 731;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 747;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 763;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 779;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 795;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 795;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 795;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 795;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		///// A /////
		var coin:Coin = new Coin();
		coin.x = 827;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 827;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 827;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 827;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 827;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 891;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 891;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 891;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 891;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 891;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 843;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 859;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 875;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 843;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 859;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 875;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
	}
	
	private function generateAS3()
	{
		///// A /////
		var coin:Coin = new Coin();
		coin.x = 1027;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1027;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1027;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1027;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1027;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1091;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1091;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1091;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1091;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1091;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1043;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1059;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1075;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1043;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1059;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1075;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		///// S /////
		
		var coin:Coin = new Coin();
		coin.x = 1139;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1155;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1171;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1187;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1123;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1123;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1139;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1155;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1171;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1187;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1187;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1123;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1139;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1155;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1171;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//3
		var coin:Coin = new Coin();
		coin.x = 1219;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1235;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1251;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1267;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1283;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		//
		/*var coin:Coin = new Coin();
		coin.x = 1235;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);*/
		
		var coin:Coin = new Coin();
		coin.x = 1251;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1267;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1283;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1283;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1219;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1235;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1251;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1267;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
	}
	
	private function generateCs()
	{
		
		// C
		var coin:Coin = new Coin();
		coin.x = 1433;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1449;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1465;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1417;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1481;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1417;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1417;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1417;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1481;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1433;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1449;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1465;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		//#
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 305;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1513;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1545;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1577;
		coin.y = 321;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 337;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 353;
		level.addChild(coin);
		coins.push(coin);
		
		//
		var coin:Coin = new Coin();
		coin.x = 1513;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1545;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1577;
		coin.y = 369;
		level.addChild(coin);
		coins.push(coin);
		
		//		
		var coin:Coin = new Coin();
		coin.x = 1529;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
		var coin:Coin = new Coin();
		coin.x = 1561;
		coin.y = 385;
		level.addChild(coin);
		coins.push(coin);
		
	}
	
}