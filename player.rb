class Player
  def play_turn(warrior)
    #The warrior moves to the stairs to finish the level
    warrior.walk!(warrior.direction_of_stairs)
  end
end
