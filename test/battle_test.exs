defmodule UpsilonBattle.BattleTest do 
    use ExUnit.Case, async: true
    alias UpsilonBattle.Engine
    alias UpsilonBattle.EngineStore
    alias UpsilonBattle.Map, as: UMap
    import UpsilonBattle.Position
    use UpsilonBattle.ChannelCase
    alias UpsilonBattle.RefreshChannel

    test "create a new map" do 
        map = %UMap{}
        {:ok,map} = UMap.init(map, 10,10,0)
        10 = map.width
        10 = map.height
        10 = length(map.content)
        10 = length(Enum.at(map.content,0))
    end

    test "edit map" do 
        map = %UMap{}
        {:ok,map} = UMap.init(map, 10,10,0)
        
        {:ok, map} = UMap.put(map,~p(3,3),'K')
        {:ok, 'K'} = UMap.at(map, ~p(3,3))
    end

    test "add player on map" do 
        map = %UMap{}
        {:ok,map} = UMap.init(map, 10,10,0)
        
        {:erreur, _} = UMap.insert(map,~p(3,3),"K")
        {:ok, "0"} = UMap.at(map, ~p(3,3))
        {:ok, map} = UMap.insert(map,~p(3,3),"A")
        {:ok, "A"} = UMap.at(map, ~p(3,3))
    end

    
    test "move player on map" do 
        map = %UMap{}
        {:ok,map} = UMap.init(map, 10,10,0)
        
        {:ok, "0"} = UMap.at(map, ~p(3,3))
        {:ok, map} = UMap.insert(map,~p(3,3),"A")
        {:ok, "A"} = UMap.at(map, ~p(3,3))
        {:ok, map} = UMap.move(map, ~p(3,3), ~p(3,4))
        {:ok, "A"} = UMap.at(map, ~p(3,4))
        {:ok, "0"} = UMap.at(map, ~p(3,3))
    end

    test "initiate a new context" do 
        engine = %Engine{}
        _engine = Engine.init(engine)
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

    test "User can bind it's socket" do 
        EngineStore.forget()
        engine = EngineStore.get()


        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 1, "user_1")
        {:ok, engine} = Engine.set_user_initial_position(engine, 1, pos1)

        EngineStore.set(engine)
        
        {:ok, _, _socket} =
            socket("refresh", %{"user_id" => "1"})
            |> subscribe_and_join(RefreshChannel, "refresh:lobby", %{"user_id" => "1"})

        # Test that socket got itself connected. 
        # Fetch updated engine here. 

        
        engine = EngineStore.get()
        {:ok, _socket} = Engine.get_user_socket(engine, 1)
    end

    test "Ensure we can't call inappropriate function at inappropriate time" do 
        EngineStore.forget()
        engine = EngineStore.get()
        # State is at :initialisation right now.
        true = Engine.check_state(engine, [:initialisation])
        false = Engine.check_state(engine, [:position])

        engine = %Engine{engine| status: :position}
        true = Engine.check_state(engine, [:position])
    end

    test "Begin game" do 

        EngineStore.forget()
        engine = EngineStore.get()


        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 1, "user_1")
        {:ok, engine} = Engine.set_user_initial_position(engine, 1, pos1)

        EngineStore.set(engine)
        
        {:ok, _, _socket} =
            socket("refresh",  %{"user_id" => "1"})
            |> subscribe_and_join(RefreshChannel, "refresh:lobby", %{"user_id" => "1"})

        # Test that socket got itself connected. 
        # Fetch updated engine here. 

        
        engine = EngineStore.get()

        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 2, "user_2")
        {:ok, engine} = Engine.set_user_initial_position(engine, 2, pos1)
        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 3, "user_3")
        {:ok, engine} = Engine.set_user_initial_position(engine, 3, pos1)
        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 4, "user_4")
        {:ok, _engine} = Engine.set_user_initial_position(engine, 4, pos1)
    end

    test "Game may begin without all 4 players" do 

    end

    test "First player is able to move it's pawn" do
        EngineStore.forget()
        engine = EngineStore.get()


        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 1, "user_1")
        {:ok, engine} = Engine.set_user_initial_position(engine, 1, pos1)

        EngineStore.set(engine)
        
        {:ok, _, _socket} =
            socket("refresh",  %{"user_id" => "1"})
            |> subscribe_and_join(RefreshChannel, "refresh:lobby", %{"user_id" => "1"})

        # Test that socket got itself connected. 
        # Fetch updated engine here. 

        
        engine = EngineStore.get()

        {:ok, engine, [pos1|_rest]} = Engine.add_user(engine, 2, "user_2")
        {:ok, engine} = Engine.set_user_initial_position(engine, 2, pos1)
        {:ok, engine} = Engine.begin_game(engine)
    end

    test "First player (moved right next to an opponent) can attack said opponent" do 

    end

    test "When a player has its hp reaching 0, it's excluded from the game" do 

    end

    test "When all players are dead but one, victory to the survivor" do 

    end
end