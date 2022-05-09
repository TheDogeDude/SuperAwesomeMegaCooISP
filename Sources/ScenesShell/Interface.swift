import Scenes
import Igis

class Interface: RenderableEntity, EntityMouseClickHandler {
    var canvasSize = Size(width: 0, height: 0)
    let textColor = FillStyle(color: Color(.white))
    
    init() {
        super.init(name: "Interface")
    }

    func onEntityMouseClick(globalLocation: Point) {
        let gameInfo = InteractionLayer.instance?.gamevars
        if !gameInfo!.gameActive {
            InteractionLayer.instance?.gamevars.gameHeight = 0
            InteractionLayer.instance?.gamevars.gameActive = true
            InteractionLayer.instance?.gamevars.gameStarted = true

            InteractionLayer.instance?.player.reSetup()
            InteractionLayer.instance?.fallingEnemy.reSetup()
        }
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }

    func displayScore(to canvas: Canvas) {
        let gameInfo = InteractionLayer.instance?.gamevars

        let scoreText = Text(location:Point(x:canvasSize.center.x, y: 50), text:String(gameInfo!.gameHeight))
        scoreText.font = "30pt Arial"
        canvas.render(textColor, scoreText)
    }

    func displayMenu(to canvas: Canvas) {
        let gameInfo = InteractionLayer.instance?.gamevars
        
        if !gameInfo!.gameStarted {
            let line1 = Text(location:Point(x:canvasSize.center.x-200, y:canvasSize.center.y + 50), text:"Click to start the game!")
            line1.font = "30pt Arial"
            
            canvas.render(textColor, line1)
        } else {
            let line1 = Text(location:Point(x:canvasSize.center.x-200, y:canvasSize.center.y), text:"You died...")
            line1.font = "30pt Arial"
            let line2 = Text(location:Point(x:canvasSize.center.x-200, y:canvasSize.center.y + 50), text:"Click to try again!")
            line2.font = "30pt Arial"
            let line3 = Text(location:Point(x:canvasSize.center.x-200, y:canvasSize.center.y + 100), text:"Final Score was: " + String(gameInfo!.gameHeight))
            line3.font = "30pt Arial"
            canvas.render(textColor, line1, line2, line3)
        }
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        self.canvasSize = canvasSize
        displayMenu(to: canvas)
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }
    
    override func render(canvas: Canvas) {
        let gameInfo = InteractionLayer.instance?.gamevars
        if gameInfo!.gameActive {
            displayScore(to: canvas)
        } else {
            displayMenu(to: canvas)
        }
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }
}
