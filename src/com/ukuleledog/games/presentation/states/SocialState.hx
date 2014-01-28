package com.ukuleledog.games.presentation.states;
import com.ukuleledog.games.presentation.elements.Bowser;
import com.ukuleledog.games.presentation.elements.Frog;
import com.ukuleledog.games.presentation.elements.Mario;
import com.ukuleledog.games.presentation.elements.Toad;
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
class SocialState extends State
{
	
	private var background:Bitmap;
	private var mario:Mario;
	private var toad:Toad;
	private var text:Bitmap;
	
	public function new() 
	{
		super();
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
		
		this.alpha = 0;
		
		var tempData:BitmapData = Assets.getBitmapData("img/ending-sprite.png",true);
		
		var backgroundData:BitmapData = new BitmapData(258, 194, false);
		backgroundData.copyPixels(tempData, new Rectangle(0, 434, 258, 194), new Point(0, 0));
		background = new Bitmap(backgroundData);
		addChild(background);
	
		var textData:BitmapData = new BitmapData(101, 35, true);
		textData.copyPixels( tempData, new Rectangle(0, 832, 101, 35), new Point(0, 0) );
		text = new Bitmap(textData);
		text.x = 40;
		text.y = 80;
		
		mario = new Mario();
		mario.x = 33;
		mario.y = 135;
		addChild( mario );
		mario.setAnimation('super-idle');
		
		toad = new Toad();
		toad.x = 120;
		toad.y = 139;
		addChild( toad );
					
		this.scaleX = 2;
		this.scaleY = 2;
		
		Actuate.tween( this, 2, { alpha:1 } ).onComplete(function() {
			mario.setAnimation('super-walk');
			Actuate.tween( mario, 2, { x:80 } ).onComplete(function() {
				mario.setAnimation('super-crouch');
				addChild(text);
			});
		});
	}
	
}