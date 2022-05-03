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
        var gameInfo = InteractionLayer.instance?.gamevars
        let canvasHitbox = Rect(size:canvasSize)
        let playerContainment = canvasHitbox.containment(target: playerHitbox.rect)
        if !playerContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
            if InteractionLayer.instance?.gamevars.gameHeight == 0 {
                playerVelocity = -20
            } else {
                print("YOU LOSER LOLOLOLOLOLOLOL")
                playerVelocity = -20
            }
        } else if playerVelocity < 10 {
            playerVelocity += 1
        }
        
        var playerPosition = playerHitbox.rect.topLeft
        let playerCenter = playerPosition.x + Int(playerHitbox.rect.size.width / 2)

        if playerCenter - 10 > cursorLocation.x {
            playerPosition.x -= 20
        } else if playerCenter + 20 < cursorLocation.x {
            playerPosition.x += 20
        }
        
        let platforms = InteractionLayer.instance?.platforms
        for selection in platforms! {
            let platformContainment = selection.platform.rect.containment(target: playerHitbox.rect)

            if !platformContainment.intersection([.contact]).isEmpty &&
                 !platformContainment.intersection([.overlapsTop]).isEmpty {
                playerVelocity = -20
            }
        }

        if playerPosition.y > canvasSize.height / 2 || playerVelocity > 0 {
            playerPosition.y += playerVelocity
        } else {
            for selection in platforms! {
                selection.platform.rect.topLeft.y -= playerVelocity
            }
            InteractionLayer.instance?.gamevars.gameHeight -= playerVelocity
        }

        if gameInfo!.platformQueue.isEmpty != true{
            InteractionLayer.instance?.platforms[gameInfo!.platformQueue[0]].spawnPlatform(reset: true)
            InteractionLayer.instance?.platforms[gameInfo!.platformQueue[0]].debounce = false
            InteractionLayer.instance?.gamevars.platformQueue.removeFirst()
        }
        playerHitbox.rect.topLeft = playerPosition
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        playerHitbox.rect.topLeft.x = canvasSize.center.x
        playerHitbox.rect.topLeft.y = canvasSize.height
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
