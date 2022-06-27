package aseprite;

typedef AsepriteData =
{
	frames:Dynamic,
	meta:{
		app:String,
		version:String,
		image:String,
		format:String,
		size:{
			w:Float,
			h:Float
		},
		scale:String,
		frameTags:Array<AsepriteFrameTag>,
		layers:Array<AsepriteLayers>,
		slices:Array<AsepriteSlices>
	}
}

typedef AsepriteFrame = {
	var frame:{
		x:Float,
		y:Float,
		w:Float,
		h:Float
	}
	var rotated:Bool;
	var trimmed:Bool;
	var spriteSourceSize:{
		x:Float,
		y:Float,
		w:Float,
		h:Float
	}
	var sourceSize:{
		w:Float,
		h:Float
	}
	var duration:Float;
}

typedef AsepriteFrameTag = {
	var name:String;
	var from:Float;
	var to:Float;
	var direction:String;
}

typedef AsepriteLayers = {
	var name:String;
	var opacity:Float;
	var blendMode:String;
}

typedef AsepriteSlices = {
	var name:String;
	var color:String;
	var keys:Array<AsepriteSlicesKeys>;
}

typedef AsepriteSlicesKeys = {
	var frame:Float;
	var bounds:{
		x:Float,
		y:Float,
		w:Float,
		h:Float
	}
	var center:{
		x:Float,
		y:Float,
		w:Float,
		h:Float
	}
}