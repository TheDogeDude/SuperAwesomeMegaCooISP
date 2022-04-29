import Scenes
import Igis

class Platform: RenderableEntity {
    let platformType : String
    
    init(platformType: String) {
        super.init(name: "Platform")
        self.platformType = platformType
    }

    func staticBrick() {
        
    }

    func movingBrick() {

    }
    
    func spawnPlatform() {
        let currentHeight = InteractionLayer.instance?.gamevars.height
        let platformType = Int.random(in: 0 ... currentHeight / 500)

        switch (platformType) {
        case 0:
            // Static brick
            staticBrick()
        case 1:
            // Moving brick
            movingBrick()
        case 2:
            // Broken brick
            
        default:
            fatalError("Unknown platform type requested")
        }
    }

    func despawnPlatform() {

    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        
    }

    override func render(canvas: Canvas) {
        canvas.render(platformolor, platformProperties.outline, platform)
    }
}
