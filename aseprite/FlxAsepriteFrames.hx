package aseprite;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.util.typeLimit.OneOfTwo;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.Assets;
import haxe.Json;

typedef AsepriteData =
{
	var frames:Dynamic;
	var meta:
		{
			app:String;
			version:String;
			image:String;
			format:String;
			size:
				{
					w:Float;
					h:Float;
				};
			scale:String;
			frameTags:Array<AsepriteFrameTag>;
			layers:Array<AsepriteLayers>;
			slices:Array<AsepriteSlices>;
		};
}

typedef AsepriteFrame =
{
	var frame:
		{
			x:Float;
			y:Float;
			w:Float;
			h:Float;
		};
	var rotated:Bool;
	var trimmed:Bool;
	var spriteSourceSize:
		{
			x:Float;
			y:Float;
			w:Float;
			h:Float;
		};
	var sourceSize:
		{
			x:Float;
			y:Float;
		};
	var duration:Float;
}

typedef AsepriteFrameTag =
{
	var name:String;
	var from:Float;
	var to:Float;
	var direction:String;
}

typedef AsepriteLayers =
{
	var name:String;
	var opacity:Float;
	var blendMode:String;
}

typedef AsepriteSlices =
{
	var name:String;
	var color:String;
	var keys:Array<AsepriteSlicesKeys>;
}

typedef AsepriteSlicesKeys =
{
	var frame:Float,
	var bounds:
		{
			x:Float;
			y:Float;
			w:Float;
			h:Float;
		};
	var center:
		{
			x:Float;
			y:Float;
			w:Float;
			h:Float;
		};
}

typedef FlxAsepriteSource = OneOfTwo<String, AsepriteData>;

class FlxAsepriteFrames extends FlxAtlasFrames
{
	public function new(parent:FlxGraphic, ?border:FlxPoint)
	{
		super(parent, border);
	}

	/**
	 * Parsing method for Aseprite atlases in JSON format.
	 *
	 * @param   Source        The image source (can be `FlxGraphic`, `String`, or `BitmapData`).
	 * @param   Description   Contents of JSON file with atlas description.
	 *                        You can get it with `Assets.getText(path/to/description.json)`.
	 *                        Or you can just a pass path to the JSON file in the assets directory.
	 *                        You can also directly pass in the parsed object.
	 * @return  Newly created `FlxAtlasFrames` collection.
	 */
	public static function fromAseprite(Source:FlxGraphicAsset, Description:FlxAsepriteSource):FlxAtlasFrames
	{
		var graphic:FlxGraphic = FlxG.bitmap.add(Source, false);
		if (graphic == null)
			return null;

		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || Description == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		var data:AsepriteData;

		if (Description is String)
		{
			var json:String = Description;

			if (Assets.exists(json))
				json = Assets.getText(json);

			data = Json.parse(json);
		}
		else
			data = Description;

		for (frameName in Reflect.fields(data.frames))
			asepriteHelper(frameName, Reflect.field(data.frames, frameName), frames);

		return frames;
	}

	/**
	 * Parsing method for Aseprite Array in JSON format.
	 *
	 * @param   FrameArray    The image array source (can be `Array<FlxGraphic>`, `Array<String>`, or `Array<BitmapData>`).
	 * @param   Description   Contents of JSON file with atlas description.
	 *                        You can get it with `Assets.getText(path/to/description.json)`.
	 *                        Or you can just a pass path to the JSON file in the assets directory.
	 *                        You can also directly pass in the parsed object.
	 * @return  Newly created `FlxAtlasFrames` collection.
	 */
	public static function fromAsepriteArray(FrameArray:Array<FlxGraphicAsset>, Description:AsepriteData):FlxAtlasFrames
	{
		var asepriteFrames:Array<FlxAtlasFrames> = [];

		for (i in 0...FrameArray.length)
			asepriteFrames.push(fromAseprite(FrameArray[i], Description));

		var parent:FlxAtlasFrames = asepriteFrames[0];
		asepriteFrames.shift();

		for (i in asepriteFrames)
			for (j in i.frames)
				parent.pushFrame(j);

		return parent;
	}

	/**
	 * Internal method for Aseprite parsing. Parses the actual frame data.
	 *
	 * @param   FrameName   Name of the frame (file name of the original source image).
	 * @param   FrameData   The Aseprite data excluding "filename".
	 * @param   Frames      The `FlxAtlasFrames` to add this frame to.
	 */
	static function asepriteHelper(FrameName:String, FrameData:Dynamic, Frames:FlxAtlasFrames):Void
	{
		var frameRect:FlxRect = FlxRect.get(FrameData.frame.x, FrameData.frame.y, FrameData.frame.w, FrameData.frame.h);
		var sourceSize:FlxPoint = FlxPoint.get(FrameData.sourceSize.w, FrameData.sourceSize.h);
		var offset:FlxPoint = FlxPoint.get(FrameData.spriteSourceSize.x, FrameData.spriteSourceSize.y);

		Frames.addAtlasFrame(frameRect, sourceSize, offset, FrameName, FlxFrameAngle.ANGLE_0, false, false);
	}
}
