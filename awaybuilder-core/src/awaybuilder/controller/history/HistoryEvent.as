package awaybuilder.controller.history
{
    import flash.events.Event;

    public class HistoryEvent extends Event
    {
        public function HistoryEvent( type:String, oldValue:Object, newValue:Object ) {
            super( type, false, false);
            this.oldValue = oldValue;
            this.newValue = newValue;
        }

        public var oldValue:Object;
        public var newValue:Object;

        public var isHistoryAction:Boolean = false;

        public var canBeCombined:Boolean = false;

        override public function clone():Event
        {
            return new HistoryEvent(this.type, this.oldValue, this.newValue);
        }
    }
}
