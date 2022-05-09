import Scenes
import Igis
import Foundation

class Enemy: RenderableEntity {
    let enemyIcon : Image
    let originalSize : Size
    var enemyHitbox : Rect
    var spawned = true
    
    init(startingRect: Rect) {
        guard let enemyIconURL = URL(string:"https://raw.githubusercontent.com/TheDogeDude/SuperAwesomeMegaCooISP/main/Sources/ScenesShell/assets/images/RealEnemy1-removebg-preview%20(1).png") else {
            fatalError("Failed to create URL for the enemy icon")
        }
        enemyIcon = Image(sourceURL:enemyIconURL)
        enemyHitbox = startingRect
        originalSize = startingRect.size
        super.init(name:"Enemy")
    }

    func reSetup() {
        spawned = false
        enemyHitbox.topLeft.y = 0
        enemyHitbox.size = Size(width: 0, height: 0)
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(enemyIcon)
    }
    
    override func calculate(canvasSize: Size) {
        let gameInfo = InteractionLayer.instance?.gamevars

        if gameInfo!.gameActive {
            let randomChance = Int.random(in:0...100)
            let player = InteractionLayer.instance?.player.playerHitbox.rect
            let canvasHitbox = Rect(size:canvasSize)
            let enemyContainment = canvasHitbox.containment(target: enemyHitbox)
            if !enemyContainment.intersection([.overlapsBottom, .beyondBottom]).isEmpty {
                spawned = false
                enemyHitbox.topLeft.y = 0
                enemyHitbox.size = Size(width: 0, height: 0)
            }

            if !spawned && randomChance == 68 {
                spawned = true
                enemyHitbox.topLeft.x = player!.topLeft.x
                enemyHitbox.size = originalSize
            }

            if spawned {
                enemyHitbox.topLeft.y += 20
            }
        } else {
            enemyHitbox.size = Size(width: 0, height: 0)
        }
    }
    
    override func render(canvas: Canvas) {
        if enemyIcon.isReady {
            enemyIcon.renderMode = .destinationRect(enemyHitbox)
            canvas.render(enemyIcon)
        }
    }
}
