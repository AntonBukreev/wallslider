package code.view.components {
    import flash.display.Sprite;
    import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilterType;
    import flash.filters.GlowFilter;

    public class GradientGlowFilterClass extends Sprite {

        private static var color:uint = 0x4b6f9e;
        private static var alpha:uint = 1;
        private static var blurX:Number = 10;
        private static var blurY:Number = 10;
        private static var strength:Number = 2;
        private static var quality:Number = 1;
        private static var inner:Boolean = false;
        private static var knockout:Boolean = false;

        public static function getFilter():Array {
            var filter:BitmapFilter = getBitmapFilter();
            var myFilters:Array = new Array();
            myFilters.push(filter);
            return myFilters;  
        }

        private static function getBitmapFilter():BitmapFilter {
             return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
        }

    }
}