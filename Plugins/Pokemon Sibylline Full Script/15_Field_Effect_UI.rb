class Player < Trainer
  attr_accessor :has_field_effects
  alias initialize_field_effects initialize
  def initialize(name, trainer_type)
    initialize_field_effects(name,trainer_type)
    @has_field_effects = false
  end
end

class FieldEffectScreen
  def initialize(scene)
    @scene = scene
  end
  def pbStartScreen
    # Get all commands
    command_list = []
    commands = []
    MenuHandlers.each_available(:field_effect_data) do |option, hash, name|
      command_list.push(name)
      commands.push(hash)
    end
    @scene.pbStartScene(command_list)
    # Main loop
    end_scene = false
    loop do
      choice = @scene.pbScene
      if choice < 0
        pbPlayCloseMenuSE
        end_scene = true
        break
      end
      break if commands[choice]["effect"].call(@scene)
    end
    @scene.pbEndScene if end_scene == true
  end
end

class FieldEffect_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(commands)
    @commands = commands
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Pokegear/bg")
    @sprites["header"] = Window_UnformattedTextPokemon.newWithSize(
       _INTL("Field Effect Data"),2,-18,256,64,@viewport)
    @sprites["header"].baseColor   = Color.new(248,248,248)
    @sprites["header"].shadowColor = Color.new(0,0,0)
    @sprites["header"].windowskin  = nil
    @sprites["commands"] = Window_CommandPokemon.newWithSize(@commands,
       14,92,324,224,@viewport)
    @sprites["commands"].baseColor   = Color.new(248,248,248)
    @sprites["commands"].shadowColor = Color.new(0,0,0)
    @sprites["commands"].windowskin = nil
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbScene
    ret = -1
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        break
      elsif Input.trigger?(Input::USE)
        ret = @sprites["commands"].index
        break
      end
    end
    return ret
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbRefresh; end
end

MenuHandlers.add(:pause_menu, :field_effect, {
  "name"      => _INTL("Field Effects"),
  "order"     => 46,
  "condition" => proc { next $player.has_field_effects },
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    pbFadeOutIn {
      scene = FieldEffect_Scene.new
      screen = FieldEffectScreen.new(scene)
      screen.pbStartScreen
    }
  }
}
)

MenuHandlers.add(:field_effect_data, :ruins, {
  "name"      => _INTL("Ruins"),
  "order"     => 1,
  "condition" => proc { next $player.has_field_effects },
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    pbMessage(_INTL("+ Fire, Water, Grass, Dragon, Ghost"))
    pbMessage(_INTL("Ghosts take half damage from full."))
    pbMessage(_INTL("Dragons avoid status."))
    pbMessage(_INTL("Ghosts take 1/4 recoil from Curse."))
    pbMessage(_INTL("Fire, Water, Grass, Dragon, and Ghost recover HP every turn"))
    next false
  }
}
)

MenuHandlers.add(:field_effect_data, :garden, {
  "name"      => _INTL("Garden"),
  "order"     => 2,
  "condition" => proc { next $game_switches[501] },
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    pbMessage(_INTL("+ Bug, Grass, Fairy"))
    pbMessage(_INTL("Fire moves cause Wildfire."))
    pbMessage(_INTL("Flying moves scatter random spores."))
    pbMessage(_INTL("Bugs get boosted defenses."))
    pbMessage(_INTL("Sap Sipper, Flower Veil, Leaf Guard and Grass Pelt activate."))
    pbMessage(_INTL("Bug, Grass, and Fairy recover HP every turn."))
    next false
  }
}
)
