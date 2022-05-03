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
        platform.rect.topLeft.y = id * 180
    }
    
    func spawnPlatform(reset: Bool = false) {
        let currentHeight = InteractionLayer.instance?.gamevars.gameHeight
        platformType = Int.random(in: (currentHeight! - 2000) / 500 ... currentHeight! / 500)
        let position = Int.random(in: 0 ... windowSize.width - platform.rect.size.width)

        if platformType > 1 {
            platformType = 1
        } else if platformType < 0 {
            platformType = 0
        }
        
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
            platform.rect.topLeft.y = 0
        }
    }

    func despawnPlatform() {
        if !debounce {
            InteractionLayer.instance?.gamevars.platformQueue.append(id)
            debounce = true
        }
    }
    
    override func calculate(canvasSize: Size) {
        let canvasHitbox = Rect(size:canvasSize)
        let platformContainment = canvasHitbox.containment(target: platform.rect)
        
        switch (platformType) {
        case 1:
            if !platformContainment.intersection([.overlapsRight, .beyondRight]).isEmpty ||
                 !platformContainment.intersection([.overlapsLeft, .beyondLeft]).isEmpty  {
                velocity = -velocity
            }
            
            platform.rect.topLeft.x += velocity
        default: break
        }

        if !platformContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
            despawnPlatform()
        }
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        windowSize = canvasSize
        
        spawnPlatform()
    }

    override func render(canvas: Canvas) {
        canvas.render(outline, platformColor, platform)
    }
}
