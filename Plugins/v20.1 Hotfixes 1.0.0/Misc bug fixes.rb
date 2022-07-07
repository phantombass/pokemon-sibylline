#===============================================================================
# "v20.1 Hotfixes" plugin
# This file contains fixes for bugs in Essentials v20.1.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#===============================================================================

Essentials::ERROR_TEXT += "[v20.1 Hotfixes 1.0.0]\r\n"

#===============================================================================
# Fixed Heavy Ball's catch rate calculation being inaccurate.
#===============================================================================
Battle::PokeBallEffects::ModifyCatchRate.add(:HEAVYBALL, proc { |ball, catchRate, battle, battler|
  next 0 if catchRate == 0
  weight = battler.pbWeight
  if Settings::NEW_POKE_BALL_CATCH_RATES
    if weight >= 3000
      catchRate += 30
    elsif weight >= 2000
      catchRate += 20
    elsif weight < 1000
      catchRate -= 20
    end
  else
    if weight >= 4096
      catchRate += 40
    elsif weight >= 3072
      catchRate += 30
    elsif weight >= 2048
      catchRate += 20
    else
      catchRate -= 20
    end
  end
  next catchRate.clamp(1, 255)
})

#===============================================================================
# Added Obstruct to the blacklists of Assist and Copycat.
#===============================================================================
class Battle::Move::UseRandomMoveFromUserParty < Battle::Move
  alias __hotfixes__initialize initialize
  def initialize(battle, move)
    __hotfixes__initialize(battle, move)
    @moveBlacklist.push("ProtectUserFromDamagingMovesObstruct")
  end
end

class Battle::Move::UseLastMoveUsed < Battle::Move
  alias __hotfixes__initialize initialize
  def initialize(battle, move)
    __hotfixes__initialize(battle, move)
    @moveBlacklist.push("ProtectUserFromDamagingMovesObstruct")
  end
end

#===============================================================================
# Fixed mispositioning of text in Debug features that edit Game Switches and
# Game Variables.
#===============================================================================
class SpriteWindow_DebugVariables < Window_DrawableCommand
  def shadowtext(x, y, w, h, t, align = 0, colors = 0)
    width = self.contents.text_size(t).width
    case align
    when 1   # Right aligned
      x += (w - width)
    when 2   # Centre aligned
      x += (w / 2) - (width / 2)
    end
    y += 8   # TEXT OFFSET
    base = Color.new(12 * 8, 12 * 8, 12 * 8)
    case colors
    when 1   # Red
      base = Color.new(168, 48, 56)
    when 2   # Green
      base = Color.new(0, 144, 0)
    end
    pbDrawShadowText(self.contents, x, y, [width, w].max, h, t, base, Color.new(26 * 8, 26 * 8, 25 * 8))
  end
end

#===============================================================================
# Fixed the "See ya!" option in the PC menu not working properly.
#===============================================================================
MenuHandlers.add(:pc_menu, :pokemon_storage, {
  "name"      => proc {
    next ($player.seen_storage_creator) ? _INTL("{1}'s PC", pbGetStorageCreator) : _INTL("Someone's PC")
  },
  "order"     => 10,
  "effect"    => proc { |menu|
    pbMessage(_INTL("\\se[PC access]The Pokémon Storage System was opened."))
    command = 0
    loop do
      command = pbShowCommandsWithHelp(nil,
         [_INTL("Organize Boxes"),
          _INTL("Withdraw Pokémon"),
          _INTL("Deposit Pokémon"),
          _INTL("See ya!")],
         [_INTL("Organize the Pokémon in Boxes and in your party."),
          _INTL("Move Pokémon stored in Boxes to your party."),
          _INTL("Store Pokémon in your party in Boxes."),
          _INTL("Return to the previous menu.")], -1, command)
      break if command < 0
      case command
      when 0   # Organize
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene, $PokemonStorage)
          screen.pbStartScreen(command)
        }
      when 1   # Withdraw
        if $PokemonStorage.party_full?
          pbMessage(_INTL("Your party is full!"))
          next
        end
      when 2   # Deposit
        count = 0
        $PokemonStorage.party.each do |p|
          count += 1 if p && !p.egg? && p.hp > 0
        end
        if count <= 1
          pbMessage(_INTL("Can't deposit the last Pokémon!"))
          next
        end
      else
        break
      end
    end
    next false
  }
})

#===============================================================================
# Fixed Pokémon icons sometimes disappearing in Pokémon storage screen.
#===============================================================================
class PokemonBoxPartySprite < Sprite
  alias __hotfixes__refresh refresh
  def refresh
    __hotfixes__refresh
    Settings::MAX_PARTY_SIZE.times do |j|
      sprite = @pokemonsprites[j]
      sprite.z = 1 if sprite && !sprite.disposed?
    end
  end
end

class PokemonBoxSprite < Sprite
  alias __hotfixes__refresh refresh
  def refresh
    __hotfixes__refresh
    PokemonBox::BOX_HEIGHT.times do |j|
      PokemonBox::BOX_WIDTH.times do |k|
        sprite = @pokemonsprites[(j * PokemonBox::BOX_WIDTH) + k]
        sprite.z = 1 if sprite && !sprite.disposed?
      end
    end
  end
end

#===============================================================================
# Fixed playing the credits/changing $scene leaving a ghost image of the old map
# behind.
#===============================================================================
class Scene_Map
  def dispose
    disposeSpritesets
    @map_renderer.dispose
    @map_renderer = nil
    @spritesetGlobal.dispose
    @spritesetGlobal = nil
  end

  def main
    createSpritesets
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    Graphics.freeze
    dispose
    if $game_temp.title_screen_calling
      Graphics.transition
      Graphics.freeze
    end
  end
end

def pbLoadRpgxpScene(scene)
  return if !$scene.is_a?(Scene_Map)
  oldscene = $scene
  $scene = scene
  Graphics.freeze
  oldscene.dispose
  visibleObjects = pbHideVisibleObjects
  Graphics.transition
  Graphics.freeze
  while $scene && !$scene.is_a?(Scene_Map)
    $scene.main
  end
  Graphics.transition
  Graphics.freeze
  $scene = oldscene
  $scene.createSpritesets
  pbShowObjects(visibleObjects)
  Graphics.transition
end
