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
    let fallingEnemy = Enemy(startingRect: Rect(size: Size(width:128, height: 128)))
    let interface = Interface()

    // Allow children of Interactionlayer access to other children within Interactionlayer
    static var instance: InteractionLayer? = nil
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        
        InteractionLayer.instance = self

        // We insert our RenderableEntities in the constructor
        insert(entity: interface, at: .front)
        insert(entity: player, at: .front)

        // Insert 10 platforms and assign them IDs
        for index in 0..<10 {
            let platform = Platform(id: index)
            platforms.append(platform)
            insert(entity: platform, at: .front)
        }

        insert(entity: fallingEnemy, at: .front)
    }
}
