package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.core.AnimatedObject;
import com.ukuleledog.games.presentation.elements.Cactus;
import com.ukuleledog.games.presentation.elements.CodecBlock;
import com.ukuleledog.games.presentation.elements.Hammer;
import com.ukuleledog.games.presentation.elements.HelpCry;
import com.ukuleledog.games.presentation.elements.MapMario;
import com.ukuleledog.games.presentation.elements.Mario;
import com.ukuleledog.games.presentation.elements.MeiLing;
import com.ukuleledog.games.presentation.elements.Snake;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.utils.Timer;
import motion.Actuate;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class CodecState extends State
{
	
	private var soundChannel:SoundChannel;
	private var startTimer:Timer;
	private var codecTimer:Timer;
	
	private var background:Sprite;
	
	private var meiLing:MeiLing;
	private var snake:Snake;
	private var snakeMask:Sprite;
	private var meiLingMask:Sprite;
	
	private var codecBlock:CodecBlock;
	private var codecBlockAnimation:UInt = 6;
	
	private var textField:TextField;
	private var textFormat:TextFormat;	
	private var textTimer:Timer;
	private var textToDisplay:String;
	private var latestChar:Int;
	private var displayingText:Bool = false;
	
	private var displayingSave:Bool = false;
	private var cursorPosition:UInt = 0;
	
	private var step:UInt = 0;
	private var stupidCount:UInt = 0;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		soundChannel = Assets.getSound("snd/codec.mp3").play();
		soundChannel.addEventListener( Event.SOUND_COMPLETE, codecOpen );
				
		var tempData:BitmapData = Assets.getBitmapData("img/codec-sprite.png", true);
		
		var tempBackground = new BitmapData(640, 480, false);
		tempBackground.copyPixels( tempData, new Rectangle(0, 0, 640, 480), new Point(0, 0) );
		background = new Sprite();
		background.addChild( new Bitmap( tempBackground ) );
		background.width = 512;
		background.height = 384;
		background.y = 32;
		background.alpha = 0;
		addChild( background );
		
		textFormat = new TextFormat("arial", 20, 0xFFFFFF);
		
		textField = new TextField();
		textField.wordWrap = true;
		textField.setTextFormat( textFormat );
		textField.selectable = false;
		textField.width = 350;
		textField.height = 150;
		textField.x = 75;
		textField.y = 250;
		textField.backgroundColor = 0x000000;
		addChild( textField );
		
		meiLing = new MeiLing();
		meiLing.x = 62;
		meiLing.y = 56;
		meiLing.scaleX = 2.1;
		meiLing.scaleY = 2.1;
		meiLing.alpha = 0;
		background.addChild( meiLing );		
		
		snake = new Snake();
		snake.y = 59;
		snake.x = 475;
		snake.scaleX = 2.1;
		snake.scaleY = 2.1;
		snake.alpha = 0;
		background.addChild( snake );
		
		snakeMask = new Sprite();
		snakeMask.graphics.beginFill( 0x294539, 0.2 );
		snakeMask.graphics.drawRect(0, 0, 50, 15);
		snakeMask.graphics.endFill();
		snakeMask.scaleY = 0;
		snake.addChild(snakeMask);
		
		meiLingMask = new Sprite();
		meiLingMask.graphics.beginFill( 0x294539, 0.2 );
		meiLingMask.graphics.drawRect(0, 0, 50, 15);
		meiLingMask.graphics.endFill();
		meiLingMask.scaleY = 0;
		meiLing.addChild(meiLingMask);
		
		codecBlock = new CodecBlock();
		codecBlock.x = 240;
		codecBlock.y = 100;
		codecTimer = new Timer(500);
		codecTimer.addEventListener( TimerEvent.TIMER, handleCodecBlock );

	}
	
	private function loop( e:Event )
	{
		if ( snakeMask.y == 0 && snakeMask.scaleY < 1 )
			snakeMask.scaleY += 0.05;
		else if ( snakeMask.y >= 75 && snakeMask.scaleY > 0  )
		{
			snakeMask.y += 0.5;
			snakeMask.scaleY -= 0.05;
		}
		else if ( snakeMask.y < 86 )
			snakeMask.y += 0.5;
		else
		{
			snakeMask.y = 0;
		}
		
		if ( meiLingMask.y == 0 && meiLingMask.scaleY < 1 )
			meiLingMask.scaleY += 0.05;
		else if ( meiLingMask.y >= 75 && meiLingMask.scaleY > 0  )
		{
			meiLingMask.y += 0.5;
			meiLingMask.scaleY -= 0.05;
		}
		else if ( snakeMask.y < 86 )
			meiLingMask.y += 0.5;
		else
		{
			meiLingMask.y = 0;
		}
	}
	
	private function codecOpen( e:Event )
	{
		soundChannel.removeEventListener( Event.SOUND_COMPLETE, codecOpen );
		soundChannel = Assets.getSound("snd/codecopen.wav").play();
		soundChannel.addEventListener( Event.SOUND_COMPLETE, start );
		
		Actuate.tween( background, 0.5, {alpha: 1} );
	}
	
	private function start(e:Event)
	{
		soundChannel.removeEventListener( Event.SOUND_COMPLETE, start );
		
		musicChannel = Assets.getSound("music/codec.mp3").play();
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		
		background.addChild( codecBlock );
		codecTimer.start();
		addEventListener( Event.ENTER_FRAME, loop );
		
		Actuate.tween( meiLing, 1, {alpha: 1} );
		Actuate.tween( snake, 1, {alpha: 1} );
		
		startTimer = new Timer(2000);
		startTimer.addEventListener( TimerEvent.TIMER, displayFirstText );
		startTimer.start();
		
	}
	
	private function displayFirstText( e:TimerEvent )
	{
		startTimer.removeEventListener( TimerEvent.TIMER, displayFirstText );
		startTimer.stop();
		startTimer = null;
		
		meiLing.setAnimation('talk');
		displayText("You called, Snake?");
	}
	
	private function displayText( str:String )
	{
		textField.text = "";
		displayingText = true;
		textToDisplay = str;
		latestChar = 0;
		textTimer = new Timer(50);
		textTimer.addEventListener( TimerEvent.TIMER, displayChar );
		textTimer.start();
	}
	
	private function displayChar( e:TimerEvent )
	{		
		textField.appendText( textToDisplay.charAt(latestChar) );
		textField.setTextFormat( textFormat );
		latestChar++;
		
		if ( latestChar > textToDisplay.length )
		{
			displayingText = false;
			textTimer.stop();
			textTimer.removeEventListener( TimerEvent.TIMER, displayChar );
		}
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		
		if ( displayingText && e.keyCode == Keyboard.SPACE )
		{
			displayingText = false;
			textTimer.stop();
			textTimer.removeEventListener( TimerEvent.TIMER, displayChar );
			textField.text = textToDisplay;
		}
		else if ( displayingSave )
		{
			
			if ( cursorPosition == 0 && e.keyCode == Keyboard.DOWN )
			{
				cursorPosition = 1;
				displaySave();
			} else if ( cursorPosition == 1 && e.keyCode == Keyboard.UP )
			{
				cursorPosition = 0;
				displaySave();
			} else if ( cursorPosition == 1 && e.keyCode == Keyboard.SPACE )
			{
				if ( stupidCount == 0 )
				{
					meiLing.setAnimation('talk');
					displayText("Are you sure?");
					displayingSave = false;
				} else if ( stupidCount == 1 )
				{
					meiLing.setAnimation('talk');
					displayText("C'mon Snake, you didn't call me for no reason.");
					displayingSave = false;
				} else if ( stupidCount == 2 )
				{
					meiLing.setAnimation('serious');
					displayText("........");
					displayingSave = false;
				} else if ( stupidCount == 3 )
				{
					meiLing.setAnimation('pissed');
					displayText("........");
					displayingSave = false;
				} else
				{
					meiLing.setAnimation('tongue');
					displayText("");
					displayingSave = false;
				}
				stupidCount++;
			} else if ( cursorPosition == 0 && e.keyCode == Keyboard.SPACE )
			{
				meiLing.setAnimation('talk');
				displayText("Your progress was saved.");
				displayingSave = false;
				step = 1;
			}
		}
		else
		{
			switch (step){
				case 0:
					meiLing.setAnimation('idle');
					displaySave();
				case 1:
					meiLing.setAnimation('talk');
					displayText("Snake, have you ever heard about Matthew Charlton?");
					step = 2;
				case 2:
					displayText("He's not only a great computer programmer, he's done loads of other things too!");
					step = 3;
				case 3:
					displayText("He's written video game reviews for several french magazines and has been published in Flash&Flex in the US, talking about the HAXE programming language.");
					step = 4;
				case 4:
					displayText("But he doesn't only work on video games, he helped out the symphonic metal band Adrana write their first album and help create a short film that was presented to Quentin Tarantino himself.");
					step = 5;
				case 5:
					displayText("He's also not only co-writter but a recuring character in the online comic 'Hola Tavernier!'");
					step = 6;
				case 6:
					meiLing.setAnimation('idle');
					snake.setAnimation('talk');
					displayText("Mei Ling, why are you telling me all this?");
					step = 7;
				case 7:
					snake.setAnimation('angry');
					displayText("I don't care about having another geek friend, I already have Hideo and Otacon.");
					step = 8;
				case 8:
					snake.setAnimation('angry-idle');
					meiLing.setAnimation('wink');
					displayText("Sorry Snake... I kind of have a crush on this guy and can't stop talking about him.");
					step = 9;
				case 9:
					meiLing.setAnimation('talk');
					snake.setAnimation('idle');
					displayText("Oh look! Here he is!");
					step = 10;
				case 10:
					marioAnimation();
					step = 11;
				case 11:
					endAnimation();
					step = 12;
			}
		}
		
	}
	
	private function marioAnimation()
	{
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		meiLing.setAnimation('idle');
		
		var tempData:BitmapData = Assets.getBitmapData("img/ff6-sprite.png", true);
		var tempOctoData:BitmapData = new BitmapData(64, 47, true);
		tempOctoData.copyPixels( tempData, new Rectangle(0, 195, 64, 47), new Point(0, 0) );
		var octo:Bitmap = new Bitmap(tempOctoData);
		octo.y = 300;
		octo.x = -130;
		octo.scaleX = 2;
		octo.scaleY = 2;
		addChild(octo);
		
		var mario:Mario = new Mario();
		mario.y = 300;
		mario.x = -30;
		mario.scaleX = 2;
		mario.scaleY = 2;
		addChild(mario);
		mario.setAnimation('super-walk');
		
		displayText("");
		Assets.getSound('snd/ff6/4EDeathSpell.mp3').play();
		Actuate.tween(mario, 6, { x:720 } );
		Actuate.tween(octo, 6, { x:570 } ).onComplete(function() {
			displayText("........");
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		});
		
	}
	
	private function endAnimation()
	{
		removeEventListener( Event.ENTER_FRAME, loop );
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		
		Actuate.tween(textField, 0.2, { alpha:0 } );
			Actuate.tween(meiLing, 1, { alpha:0 } );
			Actuate.tween(snake, 1, { alpha:0 } ).onComplete(function() {
				Actuate.tween( background, 1, { alpha:0 } ).onComplete(function() {
					if ( musicChannel != null)
						musicChannel.stop();
					dispatchEvent(new Event(Event.COMPLETE));
				});
			});
	}
	
	private function displaySave()
	{
		displayingSave = true;
		
		var textFormat:TextFormat = new TextFormat("arial", 20, 0x21CF80);
		textField.text = "\t\t\tSAVE\n\t\t\tDO NOT SAVE";
		
		if ( cursorPosition == 0 )
		textField.setTextFormat(textFormat, 3, 7);
		else
		textField.setTextFormat(textFormat, 11, 22);
	}
	
	private function handleCodecBlock( e:TimerEvent ) 
	{		
		var rand:Int = Math.ceil( Math.random() * 3 );
	
		if ( rand == 1 && codecBlockAnimation > 1 )
			codecBlock.setAnimation( Std.string(--codecBlockAnimation) );
		else if ( rand == 3 && codecBlockAnimation < 8 )
			codecBlock.setAnimation( Std.string(++codecBlockAnimation) );
		
	}
	
}