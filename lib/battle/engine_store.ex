defmodule UpsilonBattle.EngineStore do 
    def start_link() do 
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

    def set(engine) do 
        Agent.update(__MODULE__,
            fn _ -> engine end )
    end

    def forget do 
        Agent.update(__MODULE__,
            fn _ -> 
                engine = %UpsilonBattle.Engine{}
                UpsilonBattle.Engine.init(engine)
            end )
    end
end