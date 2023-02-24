import 'libraries/noble/Noble'
import 'libraries/PlaydateLDtkImporter/LDtk'

import 'utilities/Utilities'

import 'scenes/MenuScene'
import 'scenes/GameScene'

LDtk.load( "assets/levels/SmallerWorld.ldtk" )

Noble.Settings.setup({
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

Noble.new(GameScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)
