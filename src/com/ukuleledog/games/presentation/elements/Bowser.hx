package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Bowser extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/ending-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 757, 1, 42, 34);
		createAnimation('surprised', 68, 757, 1, 42, 34);
		createAnimation('falling', 98, 757, 1, 41, 34);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}