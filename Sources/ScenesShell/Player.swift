import Scenes
import Igis
import Foundation

class Player: RenderableEntity, MouseMoveHandler {
    var playerHitbox : Rectangle
    var cursorLocation = Point(x: 0, y: 0)
    var canvasSize : Size
    var playerVelocity = 0
    var highestPlatform = 0
    let playerIcon : Image
   
    init(startingRect: Rect) {
        // Initialize the URL for the icon
        guard let playerIconURL = URL(string:"https://raw.githubusercontent.com/TheDogeDude/SuperAwesomeMegaCooISP/main/Sources/ScenesShell/assets/images/RealLinuxPenguin.png") else {
            fatalError("Failed to create URL for the player icon")
        }
        
        playerIcon = Image(sourceURL:playerIconURL)
        playerHitbox = Rectangle(rect: startingRect, fillMode:.fill)
        canvasSize = Size(width: 0, height: 0)
        
        super.init(name:"Player")
    }

    func onMouseMove(globalLocation: Point, movement: Point) {
        cursorLocation = globalLocation
    }

    override func calculate(canvasSize: Size) {
        var gameInfo = InteractionLayer.instance?.gamevars

        // If the game is active
        if gameInfo!.gameActive {
            let canvasHitbox = Rect(size:canvasSize)
            let playerContainment = canvasHitbox.containment(target: playerHitbox.rect)

            // If the player reaches the bottom of the screen
            if !playerContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
                if gameInfo!.gameHeight < 50 {
                    playerVelocity = -20
                } else {
                    InteractionLayer.instance?.gamevars.gameActive = false
                }
            } else if playerVelocity < 10 {
                playerVelocity += 1
            }

            // Move player 25 pixels towards the cursor
            var playerPosition = playerHitbox.rect.topLeft
            let playerCenter = playerPosition.x + Int(playerHitbox.rect.size.width / 2)

            if playerCenter - 10 > cursorLocation.x {
                playerPosition.x -= 25
            } else if playerCenter + 20 < cursorLocation.x {
                playerPosition.x += 25
            }

            // If player collides with the top of a platform, then bounce
            let platforms = InteractionLayer.instance?.platforms
            for selection in platforms! {
                let platformContainment = selection.platform.rect.containment(target: playerHitbox.rect)

                if !platformContainment.intersection([.contact]).isEmpty &&
                     !platformContainment.intersection([.overlapsTop]).isEmpty {
                    playerVelocity = -20
                }
            }

            let enemy = InteractionLayer.instance?.fallingEnemy.enemyHitbox
            let enemyContainment = enemy!.containment(target: playerHitbox.rect)

            // If the enemy collides with the player, then end the game
            if !enemyContainment.intersection([.contact]).isEmpty {
                InteractionLayer.instance?.gamevars.gameActive = false
            }

            // If the player's y value is higher than half the screen, then scroll the screen
            if playerPosition.y > canvasSize.height / 2 || playerVelocity > 0 {
                playerPosition.y += playerVelocity
            } else {
                for selection in platforms! {
                    selection.platform.rect.topLeft.y -= playerVelocity
                }
                InteractionLayer.instance?.gamevars.gameHeight -= playerVelocity
            }

            // Update the player hitbox's location
            playerHitbox.rect.topLeft = playerPosition
        }
    }

    func reSetup() {
        // Respawn the player
        playerHitbox.rect.topLeft.x = canvasSize.center.x
        playerHitbox.rect.topLeft.y = canvasSize.height
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        // Initialize player and player icon
        canvas.setup(playerIcon)
        
        playerHitbox.rect.topLeft.x = canvasSize.center.x
        playerHitbox.rect.topLeft.y = canvasSize.height
        
        self.canvasSize = canvasSize
        highestPlatform = canvasSize.height
        
        dispatcher.registerMouseMoveHandler(handler:self)
    }
    
    override func render(canvas: Canvas) {
        let info = InteractionLayer.instance?.gamevars

        // If the image can be loaded and the game is active, then render the player icon
        if playerIcon.isReady && info!.gameActive {
            playerIcon.renderMode = .destinationRect(Rect(topLeft:playerHitbox.rect.topLeft, size:Size(width:64, height:64)))
            canvas.render(playerIcon)
        }

    }

    override func teardown() {
        // Clean up mouse handler once finished
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }
}
