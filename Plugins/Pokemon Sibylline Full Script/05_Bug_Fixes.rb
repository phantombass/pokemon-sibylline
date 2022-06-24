MultipleForms.register(:ZACIAN, {
  "getForm" => proc { |pkmn, wild|
    next 1 if pkmn.hasItem?(:RUSTEDSWORD)
    next 0
  },
  "changePokemonOnEnteringBattle" => proc { |battler, pkmn, battle|
    if GameData::Move.exists?(:BEHEMOTHBLADE) && pkmn.hasItem?(:RUSTEDSWORD)
      pkmn.moves.each do |move|
        next if move.id != :IRONHEAD
        move.id = :BEHEMOTHBLADE
        battler.moves.each_with_index do |b_move, i|
          next if b_move.id != :IRONHEAD
          battler.moves[i] = Battle::Move.from_pokemon_move(battle, move)
        end
      end
    end
  },
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    next (pkmn.hasItem?(:RUSTEDSWORD)) ? 1 : 0
  },
  "changePokemonOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    pkmn.moves.each { |move| move.id = :IRONHEAD if move.id == :BEHEMOTHBLADE }
  }
})

MultipleForms.register(:ZAMAZENTA, {
  "getForm" => proc { |pkmn, wild|
    next 1 if pkmn.hasItem?(:RUSTEDSHIELD)
    next 0
  },
  "changePokemonOnEnteringBattle" => proc { |battler, pkmn, battle|
    if GameData::Move.exists?(:BEHEMOTHBASH) && pkmn.hasItem?(:RUSTEDSHIELD)
      pkmn.moves.each do |move|
        next if move.id != :IRONHEAD
        move.id = :BEHEMOTHBASH
        battler.moves.each_with_index do |b_move, i|
          next if b_move.id != :IRONHEAD
          battler.moves[i] = Battle::Move.from_pokemon_move(battle, move)
        end
      end
    end
  },
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    next (pkmn.hasItem?(:RUSTEDSHIELD)) ? 1 : 0
  },
  "changePokemonOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    pkmn.moves.each { |move| move.id = :IRONHEAD if move.id == :BEHEMOTHBASH }
  }
})

class PokemonBag
  def can_add?(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    return ItemStorageHelper.can_add?(
      @pockets[pocket], max_size, Settings::BAG_MAX_PER_SLOT, item_data.id, qty
    )
  end

  def add(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    ret = ItemStorageHelper.add(@pockets[pocket],
                                max_size, Settings::BAG_MAX_PER_SLOT, item_data.id, qty)
    if ret && Settings::BAG_POCKET_AUTO_SORT[pocket]
      @pockets[pocket].sort! { |a, b| GameData::Item.keys.index(a[0]) <=> GameData::Item.keys.index(b[0]) }
    end
    return ret
  end
end
