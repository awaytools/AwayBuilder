/**
 * Created with IntelliJ IDEA.
 * User: Mike
 * Date: 14.03.13
 * Time: 21:10
 * To change this template use File | Settings | File Templates.
 */
package awaybuilder.controller.scene {
import away3d.materials.MaterialBase;

import awaybuilder.controller.events.SceneEvent;
import awaybuilder.controller.history.HistoryCommandBase;
import awaybuilder.model.IDocumentModel;
import awaybuilder.model.vo.MaterialItemVO;

public class ChangeMaterialCommand extends HistoryCommandBase
{
    [Inject]
    public var event:SceneEvent;

    [Inject]
    public var document:IDocumentModel;

    override public function execute():void
    {
        var material:MaterialItemVO = event.newValue as MaterialItemVO;
        var vo:MaterialItemVO = document.getScenegraphItem( material.item ) as MaterialItemVO;

        vo.name = material.name;
        vo.repeat = material.repeat;

        vo.item.name = material.name;
        vo.item.repeat = material.repeat;

        addToHistory( event );
    }
}
}