def random_eggs
  egg_list = [:SOLOSIS,:SLAKOTH,:WOOBAT]
  return egg_list
end

def generate_random_egg
  rand = rand(random_eggs.length)
  egg = random_eggs[rand]
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
