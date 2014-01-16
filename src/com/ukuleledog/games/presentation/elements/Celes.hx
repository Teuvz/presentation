package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Celes extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/ff6-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 330, 1, 30, 20);
		createAnimation('fight', 20, 330, 2, 30, 20, 0.2);
		createAnimation('hurt', 60, 330, 1, 30, 20);
		createAnimation('dead', 80, 330, 1, 30, 30);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}