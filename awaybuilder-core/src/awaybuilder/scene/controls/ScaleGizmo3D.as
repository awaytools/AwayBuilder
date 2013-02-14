package awaybuilder.scene.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.primitives.CubeGeometry;
	
	public class ScaleGizmo3D extends ObjectContainer3D
	{
		public function ScaleGizmo3D()
		{
			this.visible = false;
			
			var cube:Mesh = new Mesh(new CubeGeometry());
			this.addChild(cube);
		}
	}
}