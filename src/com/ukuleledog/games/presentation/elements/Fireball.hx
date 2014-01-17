package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Fireball extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/ff6-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 113, 515, 3, 16, 14, 0.1);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}