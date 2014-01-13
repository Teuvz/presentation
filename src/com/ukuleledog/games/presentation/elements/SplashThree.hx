package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.display.Bitmap;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class SplashThree extends AnimatedObject
{
	
	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/splash-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 224, 4, 40, 48, 0.07);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}