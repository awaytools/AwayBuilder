/**
 * Created with IntelliJ IDEA.
 * User: Mike
 * Date: 14.03.13
 * Time: 21:10
 * To change this template use File | Settings | File Templates.
 */
package awaybuilder.controller.scene {
import away3d.materials.MaterialBase;
import away3d.textures.BitmapTexture;

import awaybuilder.controller.events.SceneEvent;
import awaybuilder.controller.history.HistoryCommandBase;
import awaybuilder.model.IDocumentModel;
import awaybuilder.model.vo.BitmapTextureVO;
import awaybuilder.model.vo.MaterialVO;
import awaybuilder.model.vo.TextureMaterialVO;

public class ChangeMaterialCommand extends HistoryCommandBase
{
    [Inject]
    public var event:SceneEvent;

    [Inject]
    public var document:IDocumentModel;

    override public function execute():void
    {
        var material:TextureMaterialVO = event.newValue as TextureMaterialVO;
        var vo:TextureMaterialVO = document.getMaterial( material.linkedObject ) as TextureMaterialVO;

        vo.name = material.name;
        vo.repeat = material.repeat;
        vo.texture = new BitmapTextureVO( material.texture.linkedObject as BitmapTexture );

        vo.linkedObject.name = material.name;
        vo.linkedObject.repeat = material.repeat;
        vo.linkedObject.texture = material.texture.linkedObject;

        addToHistory( event );
    }
}
}