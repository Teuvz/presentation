package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class MeiLing extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/codec-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 480, 3, 87, 50, 0.2);
		createAnimation('talk', 0, 568, 2, 87, 50, 0.2);
		createAnimation('wink', 100, 568, 1, 87, 50);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}