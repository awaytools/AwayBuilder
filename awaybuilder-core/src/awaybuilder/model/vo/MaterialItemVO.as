/**
 * Created with IntelliJ IDEA.
 * User: Mike
 * Date: 14.03.13
 * Time: 17:13
 * To change this template use File | Settings | File Templates.
 */
package awaybuilder.model.vo
{
    import away3d.materials.MaterialBase;

    [Bindable]
    public class MaterialItemVO extends ScenegraphItemVO
    {
        public function MaterialItemVO( item:MaterialBase )
        {
            super( item.name, item );

            repeat = item.repeat;
            name = item.name;

        }

        public var name:String;

        public var repeat:Boolean;

        public function clone():MaterialItemVO
        {
            var vo:MaterialItemVO = new MaterialItemVO( this.item as MaterialBase );
            return vo;
        }
    }
}
