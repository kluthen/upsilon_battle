defmodule BattleTest do 
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
    end
    
    test "add an observer to a context" do 
        engine = %Engine{}
        engine = Engine.init(engine)
        {:ok, engine, pos} = Engine.add_user(engine, 1, "user_1")
        {:ok, engine, pos} = Engine.add_user(engine, 2, "user_2")
        {:ok, engine, pos} = Engine.add_user(engine, 3, "user_3")
        {:ok, engine, pos} = Engine.add_user(engine, 4, "user_4")
        {:ok, engine, :observer} = Engine.add_user(engine, 5, "observer")
    end

end