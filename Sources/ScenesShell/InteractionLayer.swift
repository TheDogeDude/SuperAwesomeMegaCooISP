import Scenes
import Igis

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class InteractionLayer : Layer {
    let player = Player(startingRect: Rect(size: Size(width:64, height: 64)))
    var gamevars = GameVariables()
    var platforms = [Platform]()
    
    static var instance: InteractionLayer? = nil
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        
        InteractionLayer.instance = self

        // We insert our RenderableEntities in the constructor
        insert(entity: player, at: .front)

        for index in 0..<5 {
            let platform = Platform(id: index)
            platforms.append(platform)
            insert(entity: platform, at: .front)
        }
    }
}
