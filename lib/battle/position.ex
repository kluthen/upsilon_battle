defmodule UpsilonBattle.Position do 
    defstruct x: 0, y: 0

    @doc """
        Distance entre deux positions
    """
    def distance(pos_1, pos_2) do 
        abs(pos_1.x - pos_2.x) + abs(pos_1.y - pos_2.y)
    end

    @doc """
        Defines sigil that create a position ( way quicker than UpsilonBattle.create(x,y))
        uses: 
        ~p(x,y) #=> %UpsilonBattle.Position{}
    """
    def sigil_p(terms,[]) do
         [str_x,str_y] = String.split(terms,",")
         %UpsilonBattle.Position{x: String.to_integer(str_x),y: String.to_integer(str_y)}
    end
end