defmodule UpsilonBattle.Player do 
    defstruct user_id: nil, username: nil, player: false, mark: '', hp: 3, mp: 3, ap: 1, position: nil

    def set_position(player, position), do: put_in player.position, position
end