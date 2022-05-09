import Scenes
import Igis
import Foundation

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    let backgroundImage : Image
    
    init() {
        guard let imageURL = URL(string:"https://raw.githubusercontent.com/TheDogeDude/SuperAwesomeMegaCooISP/main/Sources/ScenesShell/assets/images/background.png") else {
            fatalError("Failed to create URL for background")
        }
        backgroundImage = Image(sourceURL: imageURL)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(backgroundImage)
        backgroundImage.renderMode = .destinationRect(Rect(size:canvasSize))
    }

    override func render(canvas: Canvas) {
        if backgroundImage.isReady {
            canvas.render(backgroundImage)
        }
    }
}
