package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.PhysicObject;
import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;

/**
 * ...
 * @author Matt
 */
class Mario extends PhysicObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('small-idle', 0, 0, 1, 16, 16);
		createAnimation('small-walk', 0, 0, 2, 16, 16);
		createAnimation('small-jump', 16, 0, 1, 16, 16);
		createAnimation('small-crouch', 0, 0, 1, 16, 16);
		animate('small-idle');
		
		initPhysics();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}