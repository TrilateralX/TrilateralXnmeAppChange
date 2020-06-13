package trilateralXnmeAppChange;
import nme.app.NmeApplication;
import nme.app.Window;
import nme.gl.GL;
import nme.gl.GLProgram;
import nme.gl.GLBuffer;
//import nme.gl.Utils;
import kitGL.nme.BufferGL;
import kitGL.nme.ColorPositions;
import kitGL.nme.HelpGL;
import kitGL.nme.Shaders;
import trilateral3.Trilateral;
import trilateral3.drawing.Pen;
import trilateral3.geom.FlatColorTriangles;
import trilateral3.nodule.PenNodule;
import trilateral3.shape.Shaper;
import trilateral3.drawing.TriangleAbstract;
import trilateral3.drawing.Color3Abstract;
import trilateral3.shape.IndexRange;
import trilateral3.shape.Regular;
import trilateral3.color.ColorInt;
import trilateral3.structure.ARGB;

class AppGL extends NmeApplication {
   var valid:Bool;
   var program: GLProgram;
   public var pen: Pen;
   public var currentTriangle: TriangleAbstract;
   public var currentColor:    Color3Abstract; // can only use with interleave.
   public var penNodule = new PenNodule();
   public var regular: Regular;
   public var buf:    GLBuffer;
   public
   function new( window: Window ){
      super( window );
      pen             = penNodule.pen;
      currentTriangle = pen.triangleCurrent;
      currentColor    = pen.color3Current;
      regular         = new Regular( pen );
      valid = false;
   }
   override public
   function onRender(_): Void {
      if( !valid ){
          // TODO: check what happens when loose context to see if correct.
         program = programSetup( vertexString0, fragmentString0 );
         draw( penNodule.pen );
         buf = interleaveXYZ_RGBA( program
                                 , cast penNodule.data
                                 , 'vertexPosition', 'vertexColor' );
      }
      clearAll( width, height );
      renderDraw( penNodule.pen );
      GL.bindBuffer( GL.ARRAY_BUFFER, buf );
      GL.bufferSubData( GL.ARRAY_BUFFER, 0, cast penNodule.data );
      GL.useProgram( program );
      // need to consider bind / unbind VertexAttrib see nme.gl.Buffer
      // especially if you mix it with normal nme?
      GL.drawArrays( GL.TRIANGLES, 0, penNodule.size );
   }
   // override this for drawing the first frame
   public
   function draw( pen: Pen ){
   }
   // override this for drawing every frame or changing the data.
   public
   function renderDraw( pen: Pen ){
   }
   override public 
   function onContextLost(): Void valid = false;
   // may need optimizing
   public
   function clearPen(){
       penNodule = new PenNodule();
       pen = penNodule.pen;
       //adjustTransform( window.width, window.height ); // may add later.
       currentTriangle = pen.triangleCurrent;
       currentColor    = pen.color3Current;
       regular = new Regular( pen );
   }
}