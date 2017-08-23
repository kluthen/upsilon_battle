defmodule UpsilonBattle.Position do 
    defstruct x: 0, y: 0

    @doc ~s"""
        Distance entre deux positions
    """
    def distance(pos_1, pos_2) do 
        abs(pos_1.x - pos_2.x) + abs(pos_1.y - pos_2.y)
    end

    def create(x,y), do: %UpsilonBattle.Position{x: x, y: y}

    @doc ~s"""
        Defines sigil that create a position ( way quicker than UpsilonBattle.create(x,y))
        uses: 
        ~p(1,2) #=> %UpsilonBattle.Position{}
        Doesn't work well with other things ... use Position.create instead.
    """
    def sigil_p(terms,[]) do
         [str_x,str_y] = String.split(terms,",")
         %UpsilonBattle.Position{x: String.to_integer(str_x),y: String.to_integer(str_y)}
    end

    def to_string(position) do 
        "Position: x: #{position.x}, y: #{position.y}"
    end
end