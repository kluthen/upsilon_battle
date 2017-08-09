defmodule UpsilonBattle.BattleTest do 
    use ExUnit.Case, async: true
    alias UpsilonBattle.Engine

    test "initiate a new context" do 
        engine = %Engine{}
        engine = Engine.init(engine)
    end

    test "add an user to a context" do 
        engine = %Engine{}
        engine = Engine.init(engine)
        {:ok, engine, pos} = Engine.add_user(engine, 1, "user_1")
        3 = length(pos)
        for cell <- pos do 
            "0" = UpsilonBattle.Map.at!(engine.map,cell)
        end
        1 = length engine.players
    end
    
    test "add an observer to a context" do 
        engine = %Engine{}
        engine = Engine.init(engine)
        {:ok, engine, pos} = Engine.add_user(engine, 1, "user_1")
        for cell <- pos do 
            "0" = UpsilonBattle.Map.at!(engine.map,cell)
        end
        {:ok, engine, pos} = Engine.add_user(engine, 2, "user_2")
        for cell <- pos do 
            "0" = UpsilonBattle.Map.at!(engine.map,cell)
        end
        {:ok, engine, pos} = Engine.add_user(engine, 3, "user_3")
        for cell <- pos do 
            "0" = UpsilonBattle.Map.at!(engine.map,cell)
        end
        {:ok, engine, pos} = Engine.add_user(engine, 4, "user_4")
        for cell <- pos do 
            "0" = UpsilonBattle.Map.at!(engine.map,cell)
        end
        {:ok, engine, :observateur} = Engine.add_user(engine, 5, "observer")
        
        4 = length engine.players
        1 = length engine.users
    end

    test "Set player initial position" do 
        engine = %Engine{}
        engine = Engine.init(engine)
        {:ok, engine, [pos1,pos2|_rest]} = Engine.add_user(engine, 1, "user_1")
        player = Engine.get_player(engine,1)
        nil = player.position

        {:ok, engine} = Engine.set_user_initial_position(engine, 1, pos1)

        {:erreur, :deja_fait} = Engine.set_user_initial_position(engine, 1, pos2)  
    end
end