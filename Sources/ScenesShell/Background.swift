import Scenes
import Igis
import Foundation

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    let backgroundImage : Image
    
    init() {
        // Initialize image url and image
        guard let imageURL = URL(string:"https://raw.githubusercontent.com/TheDogeDude/SuperAwesomeMegaCooISP/main/Sources/ScenesShell/assets/images/background.png") else {
            fatalError("Failed to create URL for background")
        }
        backgroundImage = Image(sourceURL: imageURL)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        // Setup image and strech it to fill the whole screen
        canvas.setup(backgroundImage)
        backgroundImage.renderMode = .destinationRect(Rect(size:canvasSize))
    }

    override func render(canvas: Canvas) {
        // If the background is ready, then render it
        if backgroundImage.isReady {
            canvas.render(backgroundImage)
        }
    }
}
