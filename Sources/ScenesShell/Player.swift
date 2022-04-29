import Scenes
import Igis

class Player: RenderableEntity, MouseMoveHandler {
    var playerHitbox : Rectangle
    var cursorLocation = Point(x: 0, y: 0)
    var canvasSize : Size
    var playerVelocity = 0
   
    init(startingRect: Rect) {
        playerHitbox = Rectangle(rect: startingRect, fillMode:.fill)
        canvasSize = Size(width: 0, height: 0)
        
        super.init(name:"Player")
    }

    func onMouseMove(globalLocation: Point, movement: Point) {
        cursorLocation = globalLocation
    }

    override func calculate(canvasSize: Size) {
        let canvasHitbox = Rect(size:canvasSize)
        let playerContainment = canvasHitbox.containment(target: playerHitbox.rect)
        if !playerContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
            playerVelocity = -15
        } else if playerVelocity < 10 {
            playerVelocity += 1
        }
        
        var playerPosition = playerHitbox.rect.topLeft
        let playerCenter = playerPosition.x + Int(playerHitbox.rect.size.width / 2)

        if playerCenter - 10 > cursorLocation.x {
            playerPosition.x -= 10
        } else if playerCenter + 10 < cursorLocation.x {
            playerPosition.x += 10
        }

        playerPosition.y += playerVelocity
        playerHitbox.rect.topLeft = playerPosition
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        InteractionLayer.instance?.game.helloWorld()
        playerHitbox.rect.topLeft = canvasSize.center
        self.canvasSize = canvasSize
        
        dispatcher.registerMouseMoveHandler(handler:self)
    }
    
    override func render(canvas: Canvas) {
        let collisionColor = FillStyle(color: Color(.red))
        let screenColor = FillStyle(color: Color(.white))
        let screenClear = Rectangle(rect: Rect(topLeft: Point(x: 0, y: 0), size: canvasSize), fillMode:.fill)
        
        canvas.render(screenColor, screenClear, collisionColor, playerHitbox)

    }

    override func teardown() {
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }
}
