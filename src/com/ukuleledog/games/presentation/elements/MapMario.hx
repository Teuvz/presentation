package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.display.Bitmap;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class MapMario extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/map-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 0, 2, 16, 16,0.3);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}