package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Terra extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/ff6-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 242, 1, 30, 20);
		createAnimation('fight', 20, 242, 2, 27, 20, 0.2);
		createAnimation('hurt', 60, 242, 1, 30, 20);
		createAnimation('dead', 80, 242, 1, 30, 30);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}