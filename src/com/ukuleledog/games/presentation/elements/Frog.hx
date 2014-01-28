package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Frog extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/splash-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 273, 1, 32, 32);
		createAnimation('jump', 32, 273, 1, 32, 32);
		createAnimation('high', 64, 273, 1, 32, 32);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}