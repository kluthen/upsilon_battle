defmodule UpsilonBattle.Map do 
    alias UpsilonBattle.Map, as: UMap
    alias UpsilonBattle.Position 
    defstruct content: nil, height: 0, width: 0

    def init!(map, lignes, colones) do 
        case init(map,lignes,colones) do 
            {:ok, map} -> map
            {:erreur, reason} -> raise reason
            _ -> raise "Failed to create map"
        end
    end

    def init( map, lignes, colones ) when lignes > 3 and colones > 3 do 
        map = %UMap{map | content: for ligne <- 1..lignes do 
            for colone <- 1..colones do 
                case ligne do 
                    1 -> "X" 
                    ^lignes -> "X"
                    _ ->
                        case colone do 
                            1 -> "X" 
                            ^colones -> "X" 
                            _ -> "0" 
                        end 
                end
            end
        end, height: lignes, width: colones }
        {:ok, map}
    end

    def init(_map, lignes, _) when lignes <= 3, do: {:erreur, :lignes}
    def init(_map, _, colones) when colones <= 3, do: {:erreur, :colones}

    def at!(map, position) do 
        case at(map,position) do
            {:ok, res} -> res
            {:error, reason} -> raise reason
            _ -> raise "Failure to find something at requested #{Position.to_string(position)}"
        end
    end

    def at(map, position) do 
        case Enum.at(map.content, position.y, {:erreur,:y_invalide}) do
            {:erreur, _ } = err -> err 
            ligne -> 
                {:ok, Enum.at(ligne, position.x, {:erreur, :x_invalide} )}
        end
    end

    def put!(map, position, stuff) do 
        case put(map, position, stuff) do 
            {:ok, res} -> res
            {:erreur, reason} -> raise reason
            _ -> raise "Failed to put data in map."
        end
    end

    def put(map, position, stuff) do 
        case at(map, position) do
            {:ok, _} ->
                map = %UMap{map | content: for cy <- 0..(map.height-1) do 
                    ligne = Enum.at(map.content, cy)
                    for cx <- 0..(map.width-1) do 
                        if cx == position.x and cy == position.y do 
                            stuff
                        else
                            Enum.at(ligne, cx)
                        end 
                    end
                end }
                {:ok, map}
            err -> err
        end
    end

    def insert!(map, position, mark) do 
        case insert(map, position, mark) do 
            {:ok, res} -> res
            {:erreur, reason} -> raise reason
            _ -> raise "Failed to insert data in map."
        end
    end

    def insert(map, position, mark) when mark == "A" 
                            or mark == "B" 
                            or mark == "C" 
                            or mark == "D" do 
        case at(map, position) do 
            "0" -> put(map,position, mark)
            _ -> {:erreur, :position_invalide}
        end
    end

    def insert(_map, _position, _mark), do: {:erreur, :marqueur_invalide} 

    def move!(map, position_from, position_to) do 
        case move(map,position_from,position_to) do 
            {:ok, res} -> res
            {:erreur, reason} -> reason 
            _ -> raise "Failed to move item in map."
        end
    end

    def move(map, position_from, position_to) do 
        case at(map, position_from) do
            {:erreur, _ } -> {:erreur, :position_invalide }
            contenu when contenu == "A" 
                        or contenu == "B" 
                        or contenu == "C" 
                        or contenu == "D" -> 
                case insert(map, position_to, contenu ) do
                    {:ok, tab }  -> 
                        put(tab, position_from, "0")
                    _ -> {:erreur, :cible_invalide}
                end
            _ -> {:erreur, :origine_invalide}
        end
    end

    def print(map) do 
         Enum.join(
            for ligne <- map.content do 
                IO.puts Enum.join(ligne)
            end
        )
    end

end