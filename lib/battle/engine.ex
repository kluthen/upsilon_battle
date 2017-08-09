defmodule UpsilonBattle.Engine do 
    alias UpsilonBattle.Player
    alias UpsilonBattle.Map, as: UMap
    alias UpsilonBattle.Position
    import UpsilonBattle.Position
    alias UpsilonBattle.Engine

    defstruct map_id: UUID.uuid4(), users: [], players: [], map: %UMap{}, sockets: {}

    @doc ~s"""
        Initialise le moteur.
    """
    def init(context) do 
        %Engine{context| map: UMap.init!(context.map, 15+:rand.uniform(10), 15+:rand.uniform(10)) }
    end

    @doc ~s"""
        Prepare des cases de depart autorisé ( et valide ) pour un joueur selon son orientation
        retourne [{x,y},]
    """
    def generate_player_initial_positions(context, orientation) do
        
        seek_position_in = fn border -> 
            Enum.reduce(border, [], fn 
                {"0", pos}, candidates when length(candidates) < 3 -> 
                    case :rand.uniform(2) do
                        2 -> [pos|candidates]
                        _ -> candidates
                    end 
                _, candidates -> candidates    
            end)
        end
        
        case orientation do 
            1 -> # TOP
                seek_position_in.(for x <- 1..(context.map.width-2), do: {UMap.at!(context.map, ~p(#{x},1)),~p(#{x},1) })
            2 -> # LEFT
                seek_position_in.(for y <- 1..(context.map.height-2), do: {UMap.at!(context.map, ~p(1,#{y})), ~p(1,#{y})})
            3 -> # BOTTOM
                seek_position_in.(for x <- 1..(context.map.width-2), do: {UMap.at!(context.map, ~p(#{x},#{context.map.height-2})),  ~p(#{x},#{context.map.height-2})})
            4 -> # RIGHT
                seek_position_in.(for y <- 1..(context.map.height-2), do: {UMap.at!(context.map, ~p(#{context.map.width-2},#{y})), ~p(#{context.map.width-2},#{y})})
            _ ->
                {:erreur, :orientation_invalide}
        end
        
    end

    @doc ~s"""
        Donne la marque pour le joueur
    """
    def get_mark( 1 ), do: 'A'
    def get_mark( 2 ), do: 'B'
    def get_mark( 3 ), do: 'C'
    def get_mark( 4 ), do: 'D'
    def get_mark( _ ), do: ''

    @doc ~s"""
        Enregistre un nouvel utilisateur ...
        Peux echouer si y a deja 4 joueurs ... 
        retour: {:ok, context, [positions_depart_dispo] } ou {:ok, context, :observateur}
    """
    def add_user(context, user_id, username) do 

        nplayer = %Player{user_id: user_id, username: username}
        if length(context.players) < 4 do 

            nplayer = %Player{nplayer| player: true, mark: get_mark(length(context.players) +1)}
            context = %Engine{context| players: [nplayer|context.players]}
            {:ok, context, generate_player_initial_positions(context, length(context.players))}
        else
            context = %Engine{context|users: [nplayer|context.users]}
            {:ok, context, :observateur}
        end
    end

    @doc ~s"""
        Retourne la map
    """ 
    def get_map(context) do 
        context.map
    end

    @doc ~s"""
        Retourne les joueurs
    """
    def get_players(context) do 
        context.players
    end

    defp search [user|rest], user_id do
        if user.user_id == user_id do
            true
        else
            search(rest, user_id)
        end
    end
    defp search( [], _), do: false 

    defp retrieve [user|rest], user_id do
        if user.user_id == user_id do
            user
        else
            retrieve(rest, user_id)
        end
    end
    defp retrieve( [], _), do: nil

    
    defp update [user|rest], nuser do
        if user.user_id == nuser.user_id do
            [nuser|rest]
        else
            [user|update(rest, nuser)]
        end
    end
    defp update( [], _), do: []

    @doc ~s"""
        Retourne true ou false :)
    """
    def user_known?(context, user_id) do 
        if search(context.players, user_id) do 
            true
        else 
            if search(context.users, user_id) do 
                true
            else 
                false
            end
        end
    end

    @doc ~s"""
        Retourne si l'utilisateur est un joueur ou non
    """ 
    def user_is_player?(context, user_id) do 
        if search(context.players, user_id) do 
            true
        else
            false
        end
    end

    def get_player(context, user_id) do 
        retrieve(context.players, user_id)
    end

    @doc ~s"""
        Stock la socket de communication d'un utilisateur
        Peux echouer si l'utilisateur est inconnu
        retour {:ok, context } ou {:erreur, :inconnu}
    """
    def register_user_socket(context, user_id, socket) do 
        if Map.has_key?(context.sockets, user_id) do 
            put_in context, [:socket, user_id], socket 
        else 
            put_in context, [:sockets, user_id], socket 
        end
    end

    @doc ~s"""
        Positionne l'utilisateur sur la carte (uniquement lors de la phase de positionnement)
        return {:ok, context} ou {:erreur, :inconnu}, {:erreur, :impossible}, {:erreur, :deja_fait}
    """
    def set_user_initial_position(context, user_id, position) do 
        case get_player(context, user_id) do 
            nil -> 
                {:erreur, :inconnu}
            player ->
                case player.position do 
                    nil ->
                        case UMap.at(context.map, position) do 
                            {:ok, "0"} ->
                                context = put_in(context.map, UMap.put!(context.map, position, player.mark ))
                                context = put_in(context.players, update(context.players, Player.set_position(player, position)))
                                {:ok, context}
                            _ -> 
                                {:erreur, :impossible}
                        end
                    _ -> {:erreur, :deja_fait}
                end
        end
    end

    @doc ~s"""
        Dit quel joueurs dois jouer. 
    """
    def get_current_player(_context) do 

    end

    @doc ~s"""
        Dit si l'utilisateur est le joueur courant.
    """
    def is_current_player(_context, _user_id) do 

    end

    @doc ~s"""
        Indique aux joueurs qu'ils doivent se mettre a jour
    """
    def notify_all_users_refresh(_context) do 
        UpsilonBattle.RefreshChannel.refresh_all_players()
    end

    @doc ~s"""
        Retourne: 
        {:erreur, :inconnu}
        {:erreur, :pas_son_tour}
        {:ok, :move}        Si on attend le deplacement du joueur
        {:ok, :attack}      Si on attend l'attaque du joueur
        {:ok, :position}    Si on attend la position du joueur
    """
    def get_player_next_action(_context, _user_id) do 

    end

    @doc ~s"""
        move_set = [{x,y}] 
        decrivant toute les cases par lequel va passé le joueur
        Retourne {:ok, context} ou {:erreur, :colision} ou {:erreur, :inconnu}
    """
    def player_moves(_context, _user_id, _move_set) do
        
    end

    @doc ~s"""
        Attaque une case
        Retourne {:ok, context} ou  {:erreur, :inconnu}
    """
    def player_attacks(_context, _user_id, _target_x, _target_y) do 

    end

    @doc ~s"""
        Note que l'on doit changer de joueur courant
        Retourne {:ok, context}
    """
    def switch_to_next_player(_context) do 

    end
end
