package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Cactus;
import com.ukuleledog.games.presentation.elements.Hammer;
import com.ukuleledog.games.presentation.elements.HelpCry;
import com.ukuleledog.games.presentation.elements.MapMario;
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
		
	private var background:Sprite;
	
	private var textField:TextField;
	private var textFormat:TextFormat;	
	private var textTimer:Timer;
	private var textToDisplay:String;
	private var latestChar:Int;
	private var displayingText:Bool = false;
	
	private var displayingSave:Bool = false;
	private var cursorPosition:UInt = 0;
	
	private var step:UInt = 0;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		musicChannel = Assets.getMusic("music/codec.mp3").play();
		
		var tempData:BitmapData = Assets.getBitmapData("img/codec-sprite.png", true);
		
		var tempBackground = new BitmapData(640, 480, false);
		tempBackground.copyPixels( tempData, new Rectangle(0, 0, 640, 480), new Point(0, 0) );
		background = new Sprite();
		background.addChild( new Bitmap( tempBackground ) );
		background.width = 512;
		background.height = 384;
		background.y = 32;
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
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		
		displayText("Hello Snake! Do you want to save?");
	}
	
	private function displayText( str:String )
	{
		textField.text = "";
		displayingText = true;
		textToDisplay = str;
		latestChar = 0;
		textTimer = new Timer(100);
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
				displayText("Are you sure?");
				displayingSave = false;
			} else if ( cursorPosition == 0 && e.keyCode == Keyboard.SPACE )
			{
				displayText("Your progress was saved.");
				displayingSave = false;
				step = 1;
			}
		}
		else
		{
			switch (step){
				case 0:
					displaySave();
				case 1:
					displayText("Snake, have you ever heard about Matthew Charlton?");
					step = 2;
				case 2:
					displayText("He's not only a great computer programmer, he's done loads of other things too!");
					step = 3;
				case 3:
					displayText("He's written video game reviews for several french magazines and has been published in Flash&Flex in the US, talking about the HAXE programming language.");
					step = 4;
				case 4:
					displayText("But he doesn't only work on video games, he helped out the symphonic metal band Adrana write their first album and help direct a short film that was presented to Quentin Tarantino himself.");
					step = 5;
				case 5:
					displayText("He's also not only co-writter but a recuring character in the online comic 'Hola Tavernier!'");
					step = 6;
				case 6:
					displayText("Mei Ling, why are you telling me all this?");
					step = 7;
				case 7:
					displayText("I don't care about having another geek friend, I already have Hideo and Otacon.");
					step = 8;
				case 8:
					displayText("Sorry Snake... I kind of have a crush on this guy and can't stop talking about him.");
					step = 9;
				case 9:
					displayText("Oh look! Here he comes!");
					trace("mario animation");
					step = 10;
			}
		}
		
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
	
}