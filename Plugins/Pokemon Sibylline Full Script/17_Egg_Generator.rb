def random_eggs_gym_1
  egg_list = [:SOLOSIS,:SLAKOTH,:WOOBAT]
  pbEachPokemon { |poke,_box|
    mon = poke.species
    evo = GameData::Species.get(mon).get_evolutions
    if egg_list.include?(mon) || egg_list.include?(evo)
      egg_list.delete(mon)
    end
  }
  return egg_list
end

def random_eggs_gym_2
  egg_list = [:HEATMOR,:DUNSPARCE,:PHANTUMP]
  random_eggs_gym_1.push(egg_list)
  mon = poke.species
  evo = GameData::Species.get(mon).get_evolutions
  pbEachPokemon { |poke,_box|
    if egg_list.include?(mon) || egg_list.include?(evo)
      egg_list.delete(mon)
    end
  }
  return egg_list
end

def generate_random_egg
  rand = rand(random_eggs_gym_1.length)
  egg = random_eggs_gym_1[rand]
  if pbGenerateEgg(egg,_I("Random Hiker"))
    pbMessage(_INTL("\\me[Egg get]\\PN received an Egg!"))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Take good care of it!"))
    egg = $Trainer.last_party
    species = egg.species
    move = GameData::Species.get(species).egg_moves
    egg.ability_index = 2
    egg.form = 1
    egg.iv[:HP] = 31
    egg.iv[:DEFENSE] = 31
    egg.iv[:SPECIAL_DEFENSE] = 31
    egg.learn_move(move[rand(move.length)])
    egg.steps_to_hatch = 100
    egg.calc_stats
    pbSetSelfSwitch(@event_id,"A",true)
    $RepelToggle = true
  else
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Oh, you can't carry it with you."))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Make some space in your party and come back."))
    $RepelToggle = true
  end
end

def generate_random_egg_2
  rand = rand(random_eggs_gym_2.length)
  egg = random_eggs_gym_2[rand]
  if pbGenerateEgg(egg,_I("Random Hiker"))
    pbMessage(_INTL("\\me[Egg get]\\PN received an Egg!"))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Take good care of it!"))
    egg = $Trainer.last_party
    species = egg.species
    move = GameData::Species.get(species).egg_moves
    egg.ability_index = 2
    egg.form = 1
    egg.iv[:HP] = 31
    egg.iv[:DEFENSE] = 31
    egg.iv[:SPECIAL_DEFENSE] = 31
    egg.learn_move(move[rand(move.length)])
    egg.steps_to_hatch = 100
    egg.calc_stats
    pbSetSelfSwitch(@event_id,"A",true)
    $RepelToggle = true
  else
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Oh, you can't carry it with you."))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("\\[7fe00000]Make some space in your party and come back."))
    $RepelToggle = true
  end
end
