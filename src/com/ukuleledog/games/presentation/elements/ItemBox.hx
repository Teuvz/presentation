package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;

import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Matt
 */
class ItemBox extends AnimatedObject
{

	private var status:String = 'full';
	
	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 16, 176, 4, 16, 16, 0.2);
		createAnimation('empty', 0, 176, 1, 16, 16);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public function empty() : Bool
	{
		if ( status == 'full' )
			return false;
		return true;
	}
	
	public function hit()
	{
		status = 'empty';
		setAnimation('empty');
	}
	
}