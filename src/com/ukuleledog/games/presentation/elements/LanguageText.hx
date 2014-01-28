package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class LanguageText extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 741, 1, 8, 108);
		createAnimation('java', 0, 749, 1, 8, 108);
		createAnimation('as3', 0, 757, 1, 8, 108);
		createAnimation('csharp', 0, 765, 1, 8, 108);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}