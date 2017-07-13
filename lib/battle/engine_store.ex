defmodule UpsilonBattle.EngineStore do 
    def start_link do 
        Agent.start_link(fn -> 
            engine = %UpsilonBattle.Engine{}
            UpsilonBattle.Engine.init(engine)
        end, name: __MODULE__)
    end

    def get do 
        Agent.get(__MODULE__, 
            fn engine -> engine end
        )
    end
end