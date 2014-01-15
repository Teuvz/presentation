package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Snake extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/codec-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 656, 1, 87, 50, 1);
		createAnimation('talk', 50, 656, 2, 87, 50, 0.2);
		createAnimation('angry', 150, 656, 2, 87, 50, 0.2);
		createAnimation('angry-idle', 250, 656, 1, 87, 50, 0.2);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}