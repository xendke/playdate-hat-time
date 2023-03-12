import 'libraries/noble/Noble'
import 'libraries/PlaydateLDtkImporter/LDtk'

import 'utilities/Utilities'

import 'scenes/MenuScene'
import 'scenes/GameScene'

LDtk.load( "assets/levels/SmallerWorld.ldtk" )

Noble.Settings.setup({
})

Noble.GameData.setup({
	Level = "Level_0",
	EntranceDirection = Utilities.DEFAULT_DIRECTION,
	GemCount = 0
}, 4, true)

Noble.showFPS = false

Noble.new(MenuScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)
