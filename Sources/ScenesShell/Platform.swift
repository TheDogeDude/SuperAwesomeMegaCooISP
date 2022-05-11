import Scenes
import Igis

class Platform: RenderableEntity {
    var platformType = 0
    var platformColor = FillStyle(color:Color(.white))
    var outline = StrokeStyle(color:Color(.white))
    var platform = Rectangle(rect:Rect(size:Size(width:50, height:25)), fillMode:.fillAndStroke)
    var windowSize = Size(width:0, height:0)
    var velocity = 5
    var id = 0
    var debounce = false
    
    init(id: Int) {
        super.init(name: "Platform")
        self.id = id
    }
    
    func spawnPlatform(reset: Bool = false) {
        let currentHeight = InteractionLayer.instance?.gamevars.gameHeight

        // Determine the platform type based off of the current height
        if currentHeight! < 3000 {
            platformType = 0
        } else if currentHeight! < 6000 {
            platformType = Int.random(in: -1 ... 1)
        } else if currentHeight! < 9000 {
            platformType = Int.random(in: 0 ... 1)
        } else if currentHeight! < 12000 {
            platformType = Int.random(in: 0 ... 2)
        } else {
            platformType = 1
        }

        // Choose a random position within range to spawn the platform
        let position = Int.random(in: windowSize.center.x - 400 ... windowSize.center.x + 400)

        // Prevent overflow
        if platformType > 1 {
            platformType = 1
        } else if platformType < 0 {
            platformType = 0
        }

        // Set brick color depending on type
        switch (platformType) {
        case 1:
            // Moving brick
            platformColor = FillStyle(color:Color(.green))
            outline = StrokeStyle(color:Color(.darkgreen))
        default:
            // Static brick
            platformColor = FillStyle(color:Color(.white))
            outline = StrokeStyle(color:Color(.black))
        }

        platform.rect.topLeft.x = position

        if reset {
            platform.rect.topLeft.y = -300
        }
    }
    
    override func calculate(canvasSize: Size) {
        // Create a rect around canvas and create a containment for the platform
        let canvasHitbox = Rect(size:canvasSize)
        let platformContainment = canvasHitbox.containment(target: platform.rect)

        switch (platformType) {
        case 1: // If the platform type is moving
            // If platform collides with the wall, then bounce
            if !platformContainment.intersection([.overlapsRight, .beyondRight]).isEmpty ||
                 !platformContainment.intersection([.overlapsLeft, .beyondLeft]).isEmpty  {
                velocity = -velocity
            }

            // Move the platform
            platform.rect.topLeft.x += velocity
        default: break
        }

        // If the platform reaches the bottom of the screen, reset the platform
        if !platformContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
            spawnPlatform(reset: true)
        }
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        // Initialize the platform
        platform.rect.topLeft.y = canvasSize.height - (id * 150)
        windowSize = canvasSize
        
        spawnPlatform()
    }

    override func render(canvas: Canvas) {
        canvas.render(outline, platformColor, platform)
    }
}
