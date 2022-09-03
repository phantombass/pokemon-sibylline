def random_eggs_gym_1
  egg_list = [:SOLOSIS,:SLAKOTH,:WOOBAT]
  eggs = []
  pbEachPokemon { |poke,_box|
    mon = poke.species
    evo = GameData::Species.get(mon).get_baby_species
    evos = GameData::Species.get(evo).get_family_evolutions
    eggs.push(evos)
  }
  eggs.flatten!
  eggs.uniq!
  eggs.each do |e|
    if egg_list.include?(e)
      egg_list.delete(e)
    end
  end
  return egg_list
end

def random_eggs_gym_2
  egg_list = [:HEATMOR,:DUNSPARCE,:PHANTUMP,:SANDILE]
  random_eggs_gym_1.push(egg_list)
  eggs = []
  pbEachPokemon { |poke,_box|
    mon = poke.species
    evo = GameData::Species.get(mon).get_baby_species
    evos = GameData::Species.get(evo).get_family_evolutions
    eggs.push(evos)
  }
  eggs.flatten!
  eggs.uniq!
  eggs.each do |e|
    if egg_list.include?(e)
      egg_list.delete(e)
    end
  end
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
