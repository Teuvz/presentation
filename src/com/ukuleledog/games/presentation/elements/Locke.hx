package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Locke extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/ff6-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 300, 1, 30, 20);
		createAnimation('fight', 20, 300, 2, 30, 20);
		createAnimation('hurt', 60, 300, 1, 30, 20);
		createAnimation('dead', 80, 300, 1, 30, 30);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}