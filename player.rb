class Player
  def play_turn(warrior)
    #The warrior feels if there is an enemy near him
    enemy = feel_enemy(warrior)
    # If there is an enemy the warrior attacks him
    if enemy
      warrior.attack!(enemy)
    # If the warrior is hurt he rests to restore his health
    elsif warrior.health < 20
      warrior.rest!
    # If he is healthy he goes to the stairs to finish the level
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
  end

  def feel_enemy(warrior)
    # Checks if there is an enemy and where it is to attack it
    enemy = false;
    if warrior.feel(:forward).enemy?
      enemy = :forward;
    elsif warrior.feel(:backward).enemy?
      enemy = :backward;
    elsif warrior.feel(:left).enemy?
      enemy = :left;
    elsif warrior.feel(:right).enemy?
      enemy = :right;
    end
  end
end
