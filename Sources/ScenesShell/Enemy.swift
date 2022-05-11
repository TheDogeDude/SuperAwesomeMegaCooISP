import Scenes
import Igis
import Foundation

class Enemy: RenderableEntity {
    let enemyIcon : Image
    let originalSize : Size
    var enemyHitbox : Rect
    var spawned = true
    
    init(startingRect: Rect) {
        // Initialize enemy icon URL and image
        guard let enemyIconURL = URL(string:"https://raw.githubusercontent.com/TheDogeDude/SuperAwesomeMegaCooISP/main/Sources/ScenesShell/assets/images/RealEnemy1-removebg-preview%20(1).png") else {
            fatalError("Failed to create URL for the enemy icon")
        }
        enemyIcon = Image(sourceURL:enemyIconURL)

        // Initialize enemy hitbox
        enemyHitbox = startingRect
        originalSize = startingRect.size
        super.init(name:"Enemy")
    }

    func reSetup() {
        // Respawn enemy
        spawned = false
        enemyHitbox.topLeft.y = 0
        enemyHitbox.size = Size(width: 0, height: 0)
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        // Initialize enemy icon
        canvas.setup(enemyIcon)
    }
    
    override func calculate(canvasSize: Size) {
        let gameInfo = InteractionLayer.instance?.gamevars

        // If the game is active
        if gameInfo!.gameActive {
            let randomChance = Int.random(in:0...100)
            let player = InteractionLayer.instance?.player.playerHitbox.rect
            let canvasHitbox = Rect(size:canvasSize)
            let enemyContainment = canvasHitbox.containment(target: enemyHitbox)

            // If hitbox collides with the bottom of the screen
            if !enemyContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
                spawned = false
                enemyHitbox.topLeft.y = 0
                enemyHitbox.size = Size(width: 0, height: 0)
            }

            // Spawn if randomChance is 68 (1 out of 100 chance)
            if !spawned && randomChance == 68 {
                spawned = true
                enemyHitbox.topLeft.x = player!.topLeft.x
                enemyHitbox.size = originalSize
            }

            // If the enemy is alive, then force them to fall
            if spawned {
                enemyHitbox.topLeft.y += 20
            }
        } else {
            // If the enemy is dead, then hide their hitbox
            enemyHitbox.size = Size(width: 0, height: 0)
        }
    }
    
    override func render(canvas: Canvas) {
        // If the image is ready, then set it to the hitbox location and render it
        if enemyIcon.isReady {
            enemyIcon.renderMode = .destinationRect(enemyHitbox)
            canvas.render(enemyIcon)
        }
    }
}
