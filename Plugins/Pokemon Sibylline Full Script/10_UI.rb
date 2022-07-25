class PokemonSummary_Scene
  def drawPageFour
   overlay = @sprites["overlay"].bitmap
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = shadow }
    if !@pokemon.shadowPokemon? || @pokemon.heartStage > 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
        statshadows[change[0]] = Color.new(136,96,72) if change[1] > 0
        statshadows[change[0]] = Color.new(64,120,152) if change[1] < 0
      end
    end
    evtable = Marshal.load(Marshal.dump(@pokemon.ev))
    ivtable = Marshal.load(Marshal.dump(@pokemon.iv))
    evHP = evtable[@pokemon.ev.keys[0]]
    ivHP = ivtable[@pokemon.iv.keys[0]]
    evAt = evtable[@pokemon.ev.keys[1]]
    ivAt = ivtable[@pokemon.iv.keys[1]]
    evDf = evtable[@pokemon.ev.keys[2]]
    ivDf = ivtable[@pokemon.iv.keys[2]]
    evSa = evtable[@pokemon.ev.keys[3]]
    ivSa = ivtable[@pokemon.iv.keys[3]]
    evSd = evtable[@pokemon.ev.keys[4]]
    ivSd = ivtable[@pokemon.iv.keys[4]]
    evSp = evtable[@pokemon.ev.keys[5]]
    ivSp = ivtable[@pokemon.iv.keys[5]]
    textpos = [
       [_INTL("HP"),292,82,2,base,statshadows[:HP]],
       [sprintf("%d/%d",evHP,ivHP),462,82,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Attack"),248,126,0,base,statshadows[:ATTACK]],
       [sprintf("%d/%d",evAt,ivAt),456,126,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Defense"),248,158,0,base,statshadows[:DEFENSE]],
       [sprintf("%d/%d",evDf,ivDf),456,158,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Sp. Atk"),248,190,0,base,statshadows[:SPECIAL_ATTACK]],
       [sprintf("%d/%d",evSa,ivSa),456,190,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Sp. Def"),248,222,0,base,statshadows[:SPECIAL_DEFENSE]],
       [sprintf("%d/%d",evSd,ivSd),456,222,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Speed"),248,254,0,base,statshadows[:SPEED]],
       [sprintf("%d/%d",evSp,ivSp),456,254,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Ability"),224,290,0,base,shadow]
    ]
    ability = @pokemon.ability
    if ability
      textpos.push([ability.name,362,290,0,Color.new(64,64,64),Color.new(176,176,176)])
      drawTextEx(overlay,224,322,282,2,ability.description,Color.new(64,64,64),Color.new(176,176,176))
    end
    pbDrawTextPositions(overlay,textpos)
  end

  def drawPageFive
    overlay = @sprites["overlay"].bitmap
    moveBase   = Color.new(64,64,64)
    moveShadow = Color.new(176,176,176)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(248,192,0),    # 1/2 of total PP or less
                Color.new(248,136,32),   # 1/4 of total PP or less
                Color.new(248,72,72)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(144,104,0),   # 1/2 of total PP or less
                Color.new(144,72,24),   # 1/4 of total PP or less
                Color.new(136,48,48)]   # Zero PP
    @sprites["pokemon"].visible  = true
    @sprites["pokeicon"].visible = false
    @sprites["itemicon"].visible = true
    textpos  = []
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 104
    for i in 0...Pokemon::MAX_MOVES
      move=@pokemon.moves[i]
      if move
        type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
        imagepos.push(["Graphics/Pictures/types", 248, yPos - 4, 0, type_number * 28, 64, 28])
        textpos.push([move.name,316,yPos,0,moveBase,moveShadow])
        if move.total_pp>0
          textpos.push([_INTL("PP"),342,yPos+32,0,moveBase,moveShadow])
          ppfraction = 0
          if move.pp==0;                  ppfraction = 3
          elsif move.pp*4<=move.total_pp; ppfraction = 2
          elsif move.pp*2<=move.total_pp; ppfraction = 1
          end
          textpos.push([sprintf("%d/%d",move.pp,move.total_pp),460,yPos+32,1,ppBase[ppfraction],ppShadow[ppfraction]])
        end
      else
        textpos.push(["-",316,yPos,0,moveBase,moveShadow])
        textpos.push(["--",442,yPos+32,1,moveBase,moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
  end
  def drawPageFiveSelecting(move_to_learn)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    moveBase   = Color.new(64, 64, 64)
    moveShadow = Color.new(176, 176, 176)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(248, 192, 0),    # 1/2 of total PP or less
                Color.new(248, 136, 32),   # 1/4 of total PP or less
                Color.new(248, 72, 72)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(144, 104, 0),   # 1/2 of total PP or less
                Color.new(144, 72, 24),   # 1/4 of total PP or less
                Color.new(136, 48, 48)]   # Zero PP
    # Set background image
    if move_to_learn
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
    else
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
    end
    # Write various bits of text
    textpos = [
      [_INTL("MOVES"), 26, 22, 0, base, shadow],
      [_INTL("CATEGORY"), 20, 128, 0, base, shadow],
      [_INTL("POWER"), 20, 160, 0, base, shadow],
      [_INTL("ACCURACY"), 20, 192, 0, base, shadow]
    ]
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 104
    yPos -= 76 if move_to_learn
    limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
    limit.times do |i|
      move = @pokemon.moves[i]
      if i == Pokemon::MAX_MOVES
        move = move_to_learn
        yPos += 20
      end
      if move
        type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
        imagepos.push(["Graphics/Pictures/types", 248, yPos - 4, 0, type_number * 28, 64, 28])
        textpos.push([move.name, 316, yPos, 0, moveBase, moveShadow])
        if move.total_pp > 0
          textpos.push([_INTL("PP"), 342, yPos + 32, 0, moveBase, moveShadow])
          ppfraction = 0
          if move.pp == 0
            ppfraction = 3
          elsif move.pp * 4 <= move.total_pp
            ppfraction = 2
          elsif move.pp * 2 <= move.total_pp
            ppfraction = 1
          end
          textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 460, yPos + 32, 1, ppBase[ppfraction], ppShadow[ppfraction]])
        end
      else
        textpos.push(["-", 316, yPos, 0, moveBase, moveShadow])
        textpos.push(["--", 442, yPos + 32, 1, moveBase, moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay, textpos)
    pbDrawImagePositions(overlay, imagepos)
    # Draw Pokémon's type icon(s)
    @pokemon.types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      type_x = (@pokemon.types.length == 1) ? 130 : 96 + (70 * i)
      overlay.blt(type_x, 78, @typebitmap.bitmap, type_rect)
    end
  end
  def drawSelectedMove(move_to_learn, selected_move)
    # Draw all of page four, except selected move's details
    drawPageFiveSelecting(move_to_learn)
    # Set various values
    overlay = @sprites["overlay"].bitmap
    base = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    @sprites["pokemon"].visible = false if @sprites["pokemon"]
    @sprites["pokeicon"].pokemon = @pokemon
    @sprites["pokeicon"].visible = true
    @sprites["itemicon"].visible = false if @sprites["itemicon"]
    textpos = []
    # Write power and accuracy values for selected move
    case selected_move.display_damage(@pokemon)
    when 0 then textpos.push(["---", 216, 160, 1, base, shadow])   # Status move
    when 1 then textpos.push(["???", 216, 160, 1, base, shadow])   # Variable power move
    else        textpos.push([selected_move.display_damage(@pokemon).to_s, 216, 160, 1, base, shadow])
    end
    if selected_move.display_accuracy(@pokemon) == 0
      textpos.push(["---", 216, 192, 1, base, shadow])
    else
      textpos.push(["#{selected_move.display_accuracy(@pokemon)}%", 216 + overlay.text_size("%").width, 192, 1, base, shadow])
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw selected move's damage category icon
    imagepos = [["Graphics/Pictures/category", 166, 124, 0, selected_move.display_category(@pokemon) * 28, 64, 28]]
    pbDrawImagePositions(overlay, imagepos)
    # Draw selected move's description
    drawTextEx(overlay, 4, 224, 230, 5, selected_move.description, base, shadow)
  end
  def pbScene
    GameData::Species.play_cry_from_pokemon(@pokemon)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::ACTION)
        pbSEStop
        GameData::Species.play_cry_from_pokemon(@pokemon)
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if @page==5
          pbPlayDecisionSE
          pbMoveSelection
          dorefresh = true
        elsif !@inbattle
          pbPlayDecisionSE
          dorefresh = pbOptions
        end
      elsif Input.trigger?(Input::UP) && @partyindex>0
        oldindex = @partyindex
        pbGoToPrevious
        if @partyindex!=oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN) && @partyindex<@party.length-1
        oldindex = @partyindex
        pbGoToNext
        if @partyindex!=oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT) && !@pokemon.egg?
        oldpage = @page
        @page -= 1
        @page = 5 if @page<1
        @page = 1 if @page>5
        if @page!=oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT) && !@pokemon.egg?
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 5 if @page>5
        if @page!=oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @partyindex
  end
end

class PokemonBag_Scene
  def pbRefresh
    # Set the background image
    @sprites["background"].setBitmap(sprintf("Graphics/Pictures/Bag/bg_#{@bag.last_viewed_pocket}"))
    # Set the bag sprite
    fbagexists = pbResolveBitmap(sprintf("Graphics/Pictures/Bag/bag_#{@bag.last_viewed_pocket}_f"))
    if $player.female? && fbagexists
      @sprites["bagsprite"].setBitmap("Graphics/Pictures/Bag/bag_#{@bag.last_viewed_pocket}_f")
    else
      @sprites["bagsprite"].setBitmap("Graphics/Pictures/Bag/bag_#{@bag.last_viewed_pocket}")
    end
    # Draw the pocket icons
    @sprites["pocketicon"].bitmap.clear
    if @choosing && @filterlist
      (1...@bag.pockets.length).each do |i|
        next if @filterlist[i].length > 0
        @sprites["pocketicon"].bitmap.blt(
          6 + ((i - 1) * 22), 6, @pocketbitmap.bitmap, Rect.new((i - 1) * 20, 28, 20, 20)
        )
      end
    end
    @sprites["pocketicon"].bitmap.blt(
      ((@sprites["itemlist"].pocket - 1) * 20), 2, @pocketbitmap.bitmap,
      Rect.new((@sprites["itemlist"].pocket - 1) * 25, 0, 25, 28)
    )
    # Refresh the item window
    @sprites["itemlist"].refresh
    # Refresh more things
    pbRefreshIndexChanged
  end
end

class EggRelearner_Scene
  VISIBLEMOVES = 4

  def pbDisplay(msg, brief = false)
    UIHelper.pbDisplay(@sprites["msgwindow"], msg, brief) { pbUpdate }
  end

  def pbConfirm(msg)
    UIHelper.pbConfirm(@sprites["msgwindow"], msg) { pbUpdate }
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(pokemon, moves)
    @pokemon = pokemon
    @moves = moves
    moveCommands = []
    moves.each { |m| moveCommands.push(GameData::Move.get(m).name) }
    # Create sprite hash
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundPlane(@sprites, "bg", "reminderbg", @viewport)
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
    @sprites["pokeicon"].setOffset(PictureOrigin::CENTER)
    @sprites["pokeicon"].x = 320
    @sprites["pokeicon"].y = 84
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/reminderSel")
    @sprites["background"].y = 78
    @sprites["background"].src_rect = Rect.new(0, 72, 258, 72)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["commands"] = Window_CommandPokemon.new(moveCommands, 32)
    @sprites["commands"].height = 32 * (VISIBLEMOVES + 1)
    @sprites["commands"].visible = false
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible = false
    @sprites["msgwindow"].viewport = @viewport
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    pbDrawMoveList
    pbDeactivateWindows(@sprites)
    # Fade in all sprites
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawMoveList
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    @pokemon.types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      type_x = (@pokemon.types.length == 1) ? 400 : 366 + (70 * i)
      overlay.blt(type_x, 70, @typebitmap.bitmap, type_rect)
    end
    textpos = [
      [_INTL("Teach which move?"), 16, 14, 0, Color.new(88, 88, 80), Color.new(168, 184, 184)]
    ]
    imagepos = []
    yPos = 88
    VISIBLEMOVES.times do |i|
      moveobject = @moves[@sprites["commands"].top_item + i]
      if moveobject
        moveData = GameData::Move.get(moveobject)
        type_number = GameData::Type.get(moveData.display_type(@pokemon)).icon_position
        imagepos.push(["Graphics/Pictures/types", 12, yPos - 4, 0, type_number * 28, 64, 28])
        textpos.push([moveData.name, 80, yPos, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)])
        textpos.push([_INTL("PP"), 112, yPos + 32, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        if moveData.total_pp > 0
          textpos.push([_INTL("{1}/{1}", moveData.total_pp), 230, yPos + 32, 1,
                        Color.new(64, 64, 64), Color.new(176, 176, 176)])
        else
          textpos.push(["--", 230, yPos + 32, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        end
      end
      yPos += 64
    end
    imagepos.push(["Graphics/Pictures/reminderSel",
                   0, 78 + ((@sprites["commands"].index - @sprites["commands"].top_item) * 64),
                   0, 0, 258, 72])
    selMoveData = GameData::Move.get(@moves[@sprites["commands"].index])
    basedamage = selMoveData.display_damage(@pokemon)
    category = selMoveData.display_category(@pokemon)
    accuracy = selMoveData.display_accuracy(@pokemon)
    textpos.push([_INTL("CATEGORY"), 272, 120, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)])
    textpos.push([_INTL("POWER"), 272, 152, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)])
    textpos.push([basedamage <= 1 ? basedamage == 1 ? "???" : "---" : sprintf("%d", basedamage),
                  468, 152, 2, Color.new(64, 64, 64), Color.new(176, 176, 176)])
    textpos.push([_INTL("ACCURACY"), 272, 184, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)])
    textpos.push([accuracy == 0 ? "---" : "#{accuracy}%",
                  468, 184, 2, Color.new(64, 64, 64), Color.new(176, 176, 176)])
    pbDrawTextPositions(overlay, textpos)
    imagepos.push(["Graphics/Pictures/category", 436, 116, 0, category * 28, 64, 28])
    if @sprites["commands"].index < @moves.length - 1
      imagepos.push(["Graphics/Pictures/reminderButtons", 48, 350, 0, 0, 76, 32])
    end
    if @sprites["commands"].index > 0
      imagepos.push(["Graphics/Pictures/reminderButtons", 134, 350, 76, 0, 76, 32])
    end
    pbDrawImagePositions(overlay, imagepos)
    drawTextEx(overlay, 272, 216, 230, 5, selMoveData.description,
               Color.new(64, 64, 64), Color.new(176, 176, 176))
  end

  # Processes the scene
  def pbChooseMove
    oldcmd=-1
    pbActivateWindow(@sprites,"commands") {
      loop do
        oldcmd=@sprites["commands"].index
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["commands"].index!=oldcmd
          @sprites["background"].x=0
          @sprites["background"].y=78+(@sprites["commands"].index-@sprites["commands"].top_item)*64
          pbDrawMoveList
        end
        if Input.trigger?(Input::BACK)
          return nil
        elsif Input.trigger?(Input::USE)
          return @moves[@sprites["commands"].index]
        end
      end
    }
  end

  # End the scene here
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @typebitmap.dispose
    @viewport.dispose
  end
end

#===============================================================================
# Screen class for handling game logic
#===============================================================================
class EggRelearnerScreen
  def initialize(scene)
    @scene = scene
  end

  def pbGetEggMoves(pkmn)
    return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
    moves = []
    pkmn.getEggMovesList.each do |m|
      next if pkmn.hasMove?(m)
      moves.push(m) if !moves.include?(m)
    end
    egg = moves
    return egg | []  # remove duplicates
  end

  def pbStartScreen(pkmn)
    moves = pbGetEggMoves(pkmn)
    @scene.pbStartScene(pkmn, moves)
    loop do
      move = @scene.pbChooseMove
      if move
        if @scene.pbConfirm(_INTL("Teach {1}?", GameData::Move.get(move).name))
          if pbLearnMove(pkmn, move)
            @scene.pbEndScene
            return true
          end
        end
      elsif @scene.pbConfirm(_INTL("Give up trying to teach a new move to {1}?", pkmn.name))
        @scene.pbEndScene
        return false
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
def pbEggMoveScreen(pkmn)
  retval = true
  pbFadeOutIn {
    scene = EggRelearner_Scene.new
    screen = EggRelearnerScreen.new(scene)
    retval = screen.pbStartScreen(pkmn)
  }
  return retval
end

class Pokemon
  def getEggMovesList
    baby = GameData::Species.get(species).get_baby_species
    egg = GameData::Species.get_species_form(baby,@form).egg_moves
    return egg
  end
  def has_egg_move?
    return false if egg? || shadowPokemon?
    getEggMovesList.each { |m| return true if !hasMove?(m[1]) }
    return false
  end
end

MenuHandlers.add(:party_menu, :relearn, {
  "name"      => _INTL("Relearn Moves"),
  "order"     => 31,
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    if pkmn.can_relearn_move?
      pbRelearnMoveScreen(pkmn)
    else
      screen.pbDisplay(_INTL("This Pokémon cannot relearn any moves."))
    end
  }
})

MenuHandlers.add(:party_menu, :egg_moves, {
  "name"      => _INTL("Teach Egg Moves"),
  "order"     => 32,
  "condition"   => proc { next ($PokemonSystem.min_grinding == 1 && $PokemonSystem.difficulty > 1) },
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    if pkmn.has_egg_move?
      pbEggMoveScreen(pkmn)
    else
      screen.pbDisplay(_INTL("This Pokémon cannot relearn any moves."))
    end
  }
})

MenuHandlers.add(:party_menu, :min_grinding, {
  "name"      => _INTL("Minimal Grinding..."),
  "order"     => 33,
  "condition"   => proc { next ($PokemonSystem.min_grinding == 1 && $PokemonSystem.difficulty > 1) },
  "effect"    => proc { |screen, party, party_idx|
    @viewport1 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport1.z = 99999
    $viewport_min = @viewport1
    pkmn = party[party_idx]
    @sprites = {}
    pkmn_info = "Nature: #{pkmn.nature.name}\nAbility: #{pkmn.ability.name}\nEVs: #{pkmn.ev[:HP]},#{pkmn.ev[:ATTACK]},#{pkmn.ev[:DEFENSE]},#{pkmn.ev[:SPECIAL_ATTACK]},#{pkmn.ev[:SPECIAL_DEFENSE]},#{pkmn.ev[:SPEED]}\nIVs: #{pkmn.iv[:HP]},#{pkmn.iv[:ATTACK]},#{pkmn.iv[:DEFENSE]},#{pkmn.iv[:SPECIAL_ATTACK]},#{pkmn.iv[:SPECIAL_DEFENSE]},#{pkmn.iv[:SPEED]}"
    $pkmn_data = pkmn_info
    @sprites["scene"] = Window_AdvancedTextPokemon.newWithSize($pkmn_data,250,5,255,220,@viewport1)
    pbSetSmallFont(@sprites["scene"].contents)
    @sprites["scene"].resizeToFit2($pkmn_data,255,220)
    @sprites["scene"].visible = true
    $pkmn_info = @sprites["scene"]
    command_list = []
    commands = []
    MenuHandlers.each_available(:min_grinding_options, screen, party, party_idx) do |option, hash, name|
      command_list.push(name)
      commands.push(hash)
    end
    command_list.push(_INTL("Cancel"))
    choice = screen.scene.pbShowCommands(_INTL("Change what?"), command_list)
    if choice < 0 || choice >= commands.length
      @viewport1.dispose
      next
    end
    commands[choice]["effect"].call(screen, party, party_idx)
  }
})

MenuHandlers.add(:min_grinding_options, :set_level, {
  "name"   => _INTL("Set level"),
  "order"  => 1,
  "effect" => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    params = ChooseNumberParams.new
    params.setRange(1, LEVEL_CAP[$game_system.level_cap])
    params.setDefaultValue(pkmn.level)
    if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
      screen.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
      $viewport_min.dispose
      next false
    end
    level = pbMessageChooseNumber(
      _INTL("Set the Pokémon's level (Level Cap is {1}).", params.maxNumber), params
    ) { screen.pbUpdate }
    if level != pkmn.level
      pkmn.level = level
      pkmn.calc_stats
      screen.pbRefreshSingle(party_idx)
    end
    $viewport_min.dispose
    next false
  }
})

MenuHandlers.add(:min_grinding_options, :evs_ivs, {
  "name"   => _INTL("EVs/IVs"),
  "order"  => 2,
  "effect" => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
      screen.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
      $viewport_min.dispose
      next false
    end
    cmd = 0
    loop do
      persid = sprintf("0x%08X", pkmn.personalID)
      cmd = screen.pbShowCommands(_INTL("Change which?"),
                                  [_INTL("Set EVs"),
                                   _INTL("Set IVs")], cmd)
      break if cmd < 0
      case cmd
      when 0   # Set EVs
        cmd2 = 0
        loop do
          totalev = 0
          evcommands = []
          ev_id = []
          GameData::Stat.each_main do |s|
            evcommands.push(s.name + " (#{pkmn.ev[s.id]})")
            ev_id.push(s.id)
            totalev += pkmn.ev[s.id]
          end
          cmd2 = screen.pbShowCommands(_INTL("Change which EV?\nTotal: {1}/{2} ({3}%)",
                                             totalev, Pokemon::EV_LIMIT,
                                             100 * totalev / Pokemon::EV_LIMIT), evcommands, cmd2)
          break if cmd2 < 0
          if cmd2 < ev_id.length
            params = ChooseNumberParams.new
            upperLimit = 0
            GameData::Stat.each_main { |s| upperLimit += pkmn.ev[s.id] if s.id != ev_id[cmd2] }
            upperLimit = Pokemon::EV_LIMIT - upperLimit
            upperLimit = [upperLimit, Pokemon::EV_STAT_LIMIT].min
            thisValue = [pkmn.ev[ev_id[cmd2]], upperLimit].min
            params.setRange(0, upperLimit)
            params.setDefaultValue(thisValue)
            params.setCancelValue(thisValue)
            f = pbMessageChooseNumber(_INTL("Set the EV for {1} (max. {2}).",
                                            GameData::Stat.get(ev_id[cmd2]).name, upperLimit), params) { screen.pbUpdate }
            if f != pkmn.ev[ev_id[cmd2]]
              pkmn.ev[ev_id[cmd2]] = f
              pkmn.calc_stats
              screen.pbRefreshSingle(party_idx)
              $pkmn_info.text = "Nature: #{pkmn.nature.name}\nAbility: #{pkmn.ability.name}\nEVs: #{pkmn.ev[:HP]},#{pkmn.ev[:ATTACK]},#{pkmn.ev[:DEFENSE]},#{pkmn.ev[:SPECIAL_ATTACK]},#{pkmn.ev[:SPECIAL_DEFENSE]},#{pkmn.ev[:SPEED]}\nIVs: #{pkmn.iv[:HP]},#{pkmn.iv[:ATTACK]},#{pkmn.iv[:DEFENSE]},#{pkmn.iv[:SPECIAL_ATTACK]},#{pkmn.iv[:SPECIAL_DEFENSE]},#{pkmn.iv[:SPEED]}"
              $pkmn_info.resizeToFit2($pkmn_info.text,255,220)
            end
          end
        end
      when 1   # Set IVs
        cmd2 = 0
        loop do
          hiddenpower = pbHiddenPower(pkmn)
          totaliv = 0
          ivcommands = []
          iv_id = []
          GameData::Stat.each_main do |s|
            ivcommands.push(s.name + " (#{pkmn.iv[s.id]})")
            iv_id.push(s.id)
            totaliv += pkmn.iv[s.id]
          end
          msg = _INTL("Change which IV?\nHidden Power:\n{1}, power {2}\nTotal: {3}/{4} ({5}%)",
                      GameData::Type.get(hiddenpower[0]).name, hiddenpower[1], totaliv,
                      iv_id.length * Pokemon::IV_STAT_LIMIT, 100 * totaliv / (iv_id.length * Pokemon::IV_STAT_LIMIT))
          cmd2 = screen.pbShowCommands(msg, ivcommands, cmd2)
          break if cmd2 < 0
          if cmd2 < iv_id.length
            params = ChooseNumberParams.new
            params.setRange(0, Pokemon::IV_STAT_LIMIT)
            params.setDefaultValue(pkmn.iv[iv_id[cmd2]])
            params.setCancelValue(pkmn.iv[iv_id[cmd2]])
            f = pbMessageChooseNumber(_INTL("Set the IV for {1} (max. 31).",
                                            GameData::Stat.get(iv_id[cmd2]).name), params) { screen.pbUpdate }
            if f != pkmn.iv[iv_id[cmd2]]
              pkmn.iv[iv_id[cmd2]] = f
              pkmn.calc_stats
              screen.pbRefreshSingle(party_idx)
              $pkmn_info.text = "Nature: #{pkmn.nature.name}\nAbility: #{pkmn.ability.name}\nEVs: #{pkmn.ev[:HP]},#{pkmn.ev[:ATTACK]},#{pkmn.ev[:DEFENSE]},#{pkmn.ev[:SPECIAL_ATTACK]},#{pkmn.ev[:SPECIAL_DEFENSE]},#{pkmn.ev[:SPEED]}\nIVs: #{pkmn.iv[:HP]},#{pkmn.iv[:ATTACK]},#{pkmn.iv[:DEFENSE]},#{pkmn.iv[:SPECIAL_ATTACK]},#{pkmn.iv[:SPECIAL_DEFENSE]},#{pkmn.iv[:SPEED]}"
              $pkmn_info.resizeToFit2($pkmn_info.text,255,220)
            end
          end
        end
      end
    end
    $viewport_min.dispose
    next false
  }
})
MenuHandlers.add(:min_grinding_options, :ability, {
  "name"   => _INTL("Change ability"),
  "order"  => 3,
  "effect" => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    loop do
      if pkmn.ability
        msg = _INTL("Ability is {1} (index {2}).", pkmn.ability.name, pkmn.ability_index)
      else
        msg = _INTL("No ability (index {1}).", pkmn.ability_index)
      end
# Set possible ability
      abils = pkmn.getAbilityList
      ability_commands = []
      abil_cmd = 0
      abils.each do |i|
        ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
        abil_cmd = ability_commands.length - 1 if pkmn.ability_id == i[0]
      end
      abil_cmd = screen.pbShowCommands(_INTL("Choose an ability."), ability_commands, abil_cmd)
      break if abil_cmd < 0
      pkmn.ability_index = abils[abil_cmd][1]
      pkmn.ability = nil
      screen.pbRefreshSingle(party_idx)
      $pkmn_info.text = "Nature: #{pkmn.nature.name}\nAbility: #{pkmn.ability.name}\nEVs: #{pkmn.ev[:HP]},#{pkmn.ev[:ATTACK]},#{pkmn.ev[:DEFENSE]},#{pkmn.ev[:SPECIAL_ATTACK]},#{pkmn.ev[:SPECIAL_DEFENSE]},#{pkmn.ev[:SPEED]}\nIVs: #{pkmn.iv[:HP]},#{pkmn.iv[:ATTACK]},#{pkmn.iv[:DEFENSE]},#{pkmn.iv[:SPECIAL_ATTACK]},#{pkmn.iv[:SPECIAL_DEFENSE]},#{pkmn.iv[:SPEED]}"
      $pkmn_info.resizeToFit2($pkmn_info.text,255,220)
    end
    $viewport_min.dispose
    next false
  }
})

MenuHandlers.add(:min_grinding_options, :nature, {
  "name"   => _INTL("Set nature"),
  "order"  => 4,
  "effect" => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    commands = []
    ids = []
    GameData::Nature.each do |nature|
      if nature.stat_changes.length == 0
        commands.push(_INTL("{1} (---)", nature.real_name))
      else
        plus_text = ""
        minus_text = ""
        nature.stat_changes.each do |change|
          if change[1] > 0
            plus_text += "/" if !plus_text.empty?
            plus_text += GameData::Stat.get(change[0]).name_brief
          elsif change[1] < 0
            minus_text += "/" if !minus_text.empty?
            minus_text += GameData::Stat.get(change[0]).name_brief
          end
        end
        commands.push(_INTL("{1} (+{2}, -{3})", nature.real_name, plus_text, minus_text))
      end
      ids.push(nature.id)
    end
    commands.push(_INTL("[Reset]"))
    cmd = ids.index(pkmn.nature_id || ids[0])
    loop do
      msg = _INTL("Nature is {1}.", pkmn.nature.name)
      cmd = screen.pbShowCommands(msg, commands, cmd)
      break if cmd < 0
      if cmd >= 0 && cmd < commands.length - 1   # Set nature
        pkmn.nature = ids[cmd]
      elsif cmd == commands.length - 1   # Reset
        pkmn.nature = nil
      end
      screen.pbRefreshSingle(party_idx)
      $pkmn_info.text = "Nature: #{pkmn.nature.name}\nAbility: #{pkmn.ability.name}\nEVs: #{pkmn.ev[:HP]},#{pkmn.ev[:ATTACK]},#{pkmn.ev[:DEFENSE]},#{pkmn.ev[:SPECIAL_ATTACK]},#{pkmn.ev[:SPECIAL_DEFENSE]},#{pkmn.ev[:SPEED]}\nIVs: #{pkmn.iv[:HP]},#{pkmn.iv[:ATTACK]},#{pkmn.iv[:DEFENSE]},#{pkmn.iv[:SPECIAL_ATTACK]},#{pkmn.iv[:SPECIAL_DEFENSE]},#{pkmn.iv[:SPEED]}"
      $pkmn_info.resizeToFit2($pkmn_info.text,255,220)
    end
    $viewport_min.dispose
    next false
  }
})

MenuHandlers.add(:party_menu, :evolve, {
  "name"      => _INTL("Evolve"),
  "order"     => 34,
  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    if pkmn.fainted? && $PokemonSystem.nuzlocke == 1
      screen.pbDisplay(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
      $viewport_min.dispose
      next false
    end
    evoreqs = {}
      GameData::Species.get_species_form(pkmn.species,pkmn.form).get_evolutions(true).each do |evo|   # [new_species, method, parameter, boolean]
        if evo[1].to_s.start_with?('Item')
          evoreqs[evo[0]] = evo[2] if $PokemonBag.pbHasItem?(evo[2]) && pkmn.check_evolution_on_use_item(evo[2])
        elsif evo[1].to_s.start_with?('Location')
          evoreqs[evo[0]] = nil if $game_map.map_id == evo[2]
        elsif evo[1].to_s.start_with?('Trade')
          evoreqs[evo[0]] = evo[2] if $Trainer.has_species?(evo[2]) || pkmn.check_evolution_on_trade(evo[2])
        elsif evo[1].to_s.start_with?('Happiness')
          evoreqs[evo[0]] = nil
        elsif pkmn.check_evolution_on_level_up
          evoreqs[evo[0]] = nil
        end
      end
      case evoreqs.length
      when 0
        screen.pbDisplay(_INTL("This Pokémon can't evolve."))
        next
      when 1
        newspecies = evoreqs.keys[0]
      else
        newspecies = evoreqs.keys[@scene.pbShowCommands(
          _INTL("Which species would you like to evolve into?"),
          evoreqs.keys.map { |id| _INTL(GameData::Species.get(id).real_name) }
        )]
      end
      if evoreqs[newspecies] # requires an item
        next unless @scene.pbConfirmMessage(_INTL(
          "This will consume a {1}. Do you want to continue?",
          GameData::Item.get(evoreqs[newspecies]).name
        ))
        $PokemonBag.pbDeleteItem(evoreqs[newspecies])
      end
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn,newspecies)
        evo.pbEvolution
        evo.pbEndScreen
        screen.pbRefresh
      }
  }
})
def pbPokemonMart(stock, speech = nil, cantsell = false)
  $repel_toggle = false
  stock.delete_if { |item| GameData::Item.get(item).is_important? && $bag.has?(item) }
  commands = []
  cmdBuy  = -1
  cmdSell = -1
  cmdQuit = -1
  commands[cmdBuy = commands.length]  = _INTL("I'm here to buy")
  commands[cmdSell = commands.length] = _INTL("I'm here to sell") if !cantsell
  commands[cmdQuit = commands.length] = _INTL("No, thanks")
  pbCallBub(2,@event_id)
  cmd = pbMessage(speech || _INTL("\\[7fe00000]Welcome! How may I help you?"), commands, cmdQuit + 1)
  loop do
    if cmdBuy >= 0 && cmd == cmdBuy
      scene = PokemonMart_Scene.new
      screen = PokemonMartScreen.new(scene, stock)
      screen.pbBuyScreen
    elsif cmdSell >= 0 && cmd == cmdSell
      scene = PokemonMart_Scene.new
      screen = PokemonMartScreen.new(scene, stock)
      screen.pbSellScreen
    else
      pbCallBub(2,@event_id)
      pbMessage(_INTL("\\[7fe00000]Do come again!"))
      $repel_toggle = true
      break
    end
    pbCallBub(2,@event_id)
    cmd = pbMessage(_INTL("\\[7fe00000]Is there anything else I can do for you?"), commands, cmdQuit + 1)
  end
  $game_temp.clear_mart_prices
end

class PokemonLoadScreen
  def pbStartLoadScreen
    commands = []
    cmd_continue     = -1
    cmd_new_game     = -1
    cmd_options      = -1
    cmd_language     = -1
    cmd_mystery_gift = -1
    cmd_debug        = -1
    cmd_quit         = -1
    show_continue = !@save_data.empty?
    if show_continue
      commands[cmd_continue = commands.length] = _INTL("Continue")
      if @save_data[:player].mystery_gift_unlocked
        commands[cmd_mystery_gift = commands.length] = _INTL("Mystery Gift")
      end
    end
    commands[cmd_new_game = commands.length]  = _INTL("New Game")
    commands[cmd_options = commands.length]   = _INTL("Options")
    commands[cmd_language = commands.length]  = _INTL("Language") if Settings::LANGUAGES.length >= 2
    commands[cmd_debug = commands.length]     = _INTL("Debug") if $DEBUG
    commands[cmd_quit = commands.length]      = _INTL("Quit Game")
    map_id = show_continue ? @save_data[:map_factory].map.map_id : 0
    @scene.pbStartScene(commands, show_continue, @save_data[:player],
                        @save_data[:frame_count] || 0, @save_data[:stats], map_id)
    @scene.pbSetParty(@save_data[:player]) if show_continue
    @scene.pbStartScene2
    loop do
      command = @scene.pbChoose(commands)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_continue
        @scene.pbEndScene
        Game.load(@save_data)
        $repel_toggle = true
        return
      when cmd_new_game
        @scene.pbEndScene
        Game.start_new
        $repel_toggle = true
        return
      when cmd_mystery_gift
        pbFadeOutIn { pbDownloadMysteryGift(@save_data[:player]) }
      when cmd_options
        pbFadeOutIn do
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        end
      when cmd_language
        @scene.pbEndScene
        $PokemonSystem.language = pbChooseLanguage
        pbLoadMessages("Data/" + Settings::LANGUAGES[$PokemonSystem.language][1])
        if show_continue
          @save_data[:pokemon_system] = $PokemonSystem
          File.open(SaveData::FILE_PATH, "wb") { |file| Marshal.dump(@save_data, file) }
        end
        $scene = pbCallTitle
        return
      when cmd_debug
        pbFadeOutIn { pbDebugMenu(false) }
      when cmd_quit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      else
        pbPlayBuzzerSE
      end
    end
  end
end
