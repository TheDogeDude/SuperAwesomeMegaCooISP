import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {
    let player = Player(startingRect: Rect(size: Size(width:128, height: 128)))
    let gamevars = GameVariables()
    var platforms = [Platform]()
    
    for _ in 0..<10 {
        platforms.append(Platform())
    }
    
    static var instance: InteractionLayer? = nil
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        
        InteractionLayer.instance = self

        // We insert our RenderableEntities in the constructor
        insert(entity: player, at: .front)

        for platform in platforms {
            insert(entity: platform, at: .front)
            platform.spawnPlatform()
        }
      }
}
