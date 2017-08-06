defmodule UpsilonBattle.Engine do 
    alias UpsilonBattle.Player
    alias UpsilonBattle.Map, as: UMap
    alias UpsilonBattle.Position
    import UpsilonBattle.Position
    alias UpsilonBattle.Engine

    defstruct map_id: UUID.uuid4(), users: [], players: [], map: %UMap{}

    @doc """
        Initialise le moteur.
    """
    def init(context) do 
        %Engine{context| map: UMap.init!(context.map, 15+:rand.uniform(10), 15+:rand.uniform(10)) }
    end

    @doc """
        Prepare des cases de depart autorisé ( et valide ) pour un joueur selon son orientation
        retourne [{x,y},]
    """
    def generate_player_initial_positions(context, orientation) do
        
        seek_position_in = fn border -> 
            Enum.reduce(border, [], fn current, candidates -> 
                if current == '0' 
                    and length(candidates) < 3 
                    and :rand.uniform(1) == 1 do 
                    [current|candidates]
                else 
                    candidates
                end
            end)
        end

        case orientation do 
            1 -> # TOP
                seek_position_in.(for x <- 1..(context.map.width-2), do: UMap.at!(context.map, ~p(x,1)))
            2 -> # LEFT
                seek_position_in.(for y <- 1..(context.map.height-2), do: UMap.at!(context.map, ~p(1,y)))
            3 -> # BOTTOM
                seek_position_in.(for x <- 1..(context.map.width-2), do: UMap.at!(context.map, ~p(x,context.map.height-2)))
            4 -> # RIGHT
                seek_position_in.(for y <- 1..(context.map.height-2), do: UMap.at!(context.map, ~p(context.map.width-2,y)))
            _ ->
                []
        end
    end

    @doc """
        Enregistre un nouvel utilisateur ...
        Peux echouer si y a deja 4 joueurs ... 
        retour: {:ok, context, [positions_depart_dispo] } ou {:ok, context, :observateur}
    """
    def add_user(context, user_id, username) do 

        nplayer = %Player{user_id: user_id, username: username}
        if length(context.players) < 4 do 
            nplayer = %Player{nplayer| player: true}
            context = %Engine{context| players: [nplayer|context.players]}
            {:ok, context, generate_player_initial_positions(context, length(context.players))}
        else
            context = %Engine{context|users: [nplayer|context.users]}
            {:ok, context, :observateur}
        end
    end

    @doc """
        Retourne la map
    """ 
    def get_map(context) do 
        context.map
    end

    @doc """
        Retourne les joueurs
    """
    def get_players(context) do 
        context.players
    end

    @doc """
        Retourne true ou false :)
    """
    def user_known?(_context, _user_id) do 

    end

    @doc """
        Retourne si l'utilisateur est un joueur ou non
    """ 
    def user_is_player?(_context, _user_id) do 

    end

    @doc """
        Stock la socket de communication d'un utilisateur
        Peux echouer si l'utilisateur est inconnu
        retour {:ok, context } ou {:erreur, :inconnu}
    """
    def register_user_socket(_context, _user_id, _socket) do 

    end

    @doc """
        Retourne les positions de depart disponible pour l'utilisateur
    """
    def get_user_start_position(_context, _user_id) do 
        
    end

    @doc """
        Positionne l'utilisateur sur la carte (uniquement lors de la phase de positionnement)
        return {:ok, context} ou {:erreur, :inconnu}, {:erreur, :impossible}, {:erreur, :deja_fait}
    """
    def set_user_initial_position(_context, _user_id, _x, _y) do 

    end

    @doc """
        Dit quel joueurs dois jouer. 
    """
    def get_current_player(_context) do 

    end

    @doc """
        Dit si l'utilisateur est le joueur courant.
    """
    def is_current_player(_context, _user_id) do 

    end

    @doc """
        Indique aux joueurs qu'ils doivent se mettre a jour
    """
    def notify_all_users_refresh(_context) do 
        UpsilonBattle.RefreshChannel.refresh_all_players()
    end

    @doc """
        Retourne: 
        {:erreur, :inconnu}
        {:erreur, :pas_son_tour}
        {:ok, :move}        Si on attend le deplacement du joueur
        {:ok, :attack}      Si on attend l'attaque du joueur
        {:ok, :position}    Si on attend la position du joueur
    """
    def get_player_next_action(_context, _user_id) do 

    end

    @doc """
        move_set = [{x,y}] 
        decrivant toute les cases par lequel va passé le joueur
        Retourne {:ok, context} ou {:erreur, :colision} ou {:erreur, :inconnu}
    """
    def player_moves(_context, _user_id, _move_set) do
        
    end

    @doc """
        Attaque une case
        Retourne {:ok, context} ou  {:erreur, :inconnu}
    """
    def player_attacks(_context, _user_id, _target_x, _target_y) do 

    end

    @doc """
        Note que l'on doit changer de joueur courant
        Retourne {:ok, context}
    """
    def switch_to_next_player(_context) do 

    end
end
