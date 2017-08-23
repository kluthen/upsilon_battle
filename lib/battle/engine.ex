defmodule UpsilonBattle.Engine do 
    alias UpsilonBattle.Player
    alias UpsilonBattle.Map, as: UMap
    import UpsilonBattle.Position
    alias UpsilonBattle.Engine

    # Available statuses are: 
    # :initialisation Engine creation and waits for players...
    # :position Engine waits for player to set there init positions. 
    # :player_turn Engine waits for a move or an attack or a pass
    # :checks Engine checks for end results and select next player.
    # :end_game Engine declare a victor


    defstruct map_id: UUID.uuid4(), 
              users: [], 
              players: [], 
              map: %UMap{}, 
              sockets: %{},
              status: :initialisation,
              current_player: 0


    

    @doc ~s"""
        Initialise le moteur.
    """
    def init(context) do 
        %Engine{context| map: UMap.init!(context.map, 15+:rand.uniform(10), 15+:rand.uniform(10)) }
    end

    def check_state(context, allowed), do: context.status in allowed

    defp generate_player_initial_positions(context, orientation) do
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

    defp get_mark( 1 ), do: "A"
    defp get_mark( 2 ), do: "B"
    defp get_mark( 3 ), do: "C"
    defp get_mark( 4 ), do: "D"
    defp get_mark( _ ), do: ""

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
    defp update(context, nuser) do 
        put_in context.players, update(context.players, nuser)
    end

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
        socks = put_in context.sockets, [user_id] , socket
        {:ok, put_in(context.sockets, socks) }
    end

    def get_user_socket(context, user_id) do 
        if Map.has_key?(context.sockets, user_id) do 
            Map.fetch(context.sockets, user_id)
        else
            nil
        end
    end

    @doc ~s"""
        Starts the game loop.
        return {:ok, update_context} or {:erreur, reason}
    """
    def begin_game(context) do 
        if check_state(context,[:position,:initialisation]) do 
            # mark engine as being played out.
            context = put_in context.status, :player_turn
            # Decide who is the first player. 
            nb = :rand.uniform(length(context.players))
            context = put_in context.current_player, nb
            # send a notification to all players.
            notify_all_users_refresh(context, 1000)
            {:ok, context}
        else 
            {:erreur, :inappropriate_time}
        end
    end

    @doc ~s"""
        Tell if game has been ended by KO.
    """
    def has_game_ended?(context) do 
        check_end_game(context.players, nil)
    end
    defp check_end_game([player|rest], winner) do 
        if player.hp <= 0 and winner == nil do 
            check_end_game(rest, player)
        else
            false
        end
    end
    defp check_end_game([], _winner), do: true

    @doc ~s""" 
        Test if we wait for some more players or not.
    """
    def should_wait_for_initial_positions?(context) do 
        length(context.players) < 4
    end

    @doc ~s"""
        Note that we're currently waiting for all positions to be set.
        Set current game status to waiting positions.
    """
    def wait_for_initial_positions(context) do
        if check_state(context,[:initialisation]) do 
            put_in context.status, :position
        else
            {:erreur, :inappropriate_time}    
        end
    end

    @doc ~s"""
        Tell wether all player have set a position.
    """
    def has_finished_initial_positions?(context) do 
        check_finished_initial_positions(context.players, length(context.players) == 4)
    end
    defp check_finished_initial_positions([player | rest ], full) do
        if player.position == nil do 
            false
        else
            check_finished_initial_positions(rest, full)
        end
    end
    defp check_finished_initial_positions([], full), do: true and full

    @doc ~s"""
        Positionne l'utilisateur sur la carte (uniquement lors de la phase de positionnement)
        return {:ok, context} ou {:erreur, :inconnu}, {:erreur, :impossible}, {:erreur, :deja_fait}
    """
    def set_user_initial_position(context, user_id, position) do
        if check_state(context,[:position, :initialisation]) do 
            case get_player(context, user_id) do 
                nil -> 
                    {:erreur, :inconnu}
                player ->
                    case player.position do 
                        nil ->
                            case UMap.at(context.map, position) do 
                                {:ok, "0"} ->
                                    apply_user_initial_position(context, position, player)
                                _ -> 
                                    {:erreur, :impossible}
                            end
                        _ -> {:erreur, :deja_fait}
                    end
            end
        else
            {:erreur, :inappropriate_time}
        end
    end
    defp apply_user_initial_position(context, position, player) do 
        ctx = put_in(context.map, UMap.put!(context.map, position, player.mark ))
        ctx = put_in(ctx.players, update(ctx.players, Player.set_position(player, position)))
        if has_finished_initial_positions?(ctx) do 
            begin_game(ctx)
        else
            {:ok, ctx}
        end
    end

    @doc ~s"""
        Dit quel joueurs dois jouer. 
    """
    def get_current_player(context) do
        if check_state(context, [:player_turn]) do 
            Enum.at(context.players, context.current_player)
        else
            {:erreur, :inappropriate_time}
        end
    end

    @doc ~s"""
        Dit si l'utilisateur est le joueur courant.
    """
    def is_current_player?(context, user_id) do 
        if check_state(context, [:player_turn]) do 
            check_is_current_player(context.players, 0, context.current_player, user_id)
        else
            false
        end
    end

    defp check_is_current_player([player|rest], index, target, user_id) do 
        if index == target do
            if user_id == player.user_id do 
                true
            else
                false
            end
        else
            check_is_current_player(rest, index+1 ,target, user_id)
        end    
    end

    @doc ~s"""
        Indique aux joueurs qu'ils doivent se mettre a jour
    """
    def notify_all_users_refresh(_context) do 
        UpsilonBattle.RefreshChannel.refresh_all_players()
    end
    def notify_all_users_refresh(context, delay) do 
        :timer.apply_after(delay,__MODULE__, :notify_all_users_refresh, context)
    end

    @doc ~s"""
        Retourne: 
        {:erreur, :inconnu}
        {:ok, :pas_son_tour}
        {:ok, :player_turn} Si on attend un deplacement / attaque du joueur
        {:ok, :position}    Si on attend la position du joueur
    """
    def get_player_next_action(context, user_id) do
        if check_state(context, [:position,:player_turn]) do 
        case context.status do 
            :position ->
                case get_player(context, user_id) do 
                    nil -> {:erreur, :inconnu}
                    %Player{position: pos}  when pos == nil -> {:ok, :position}
                    _player -> {:ok, :pas_son_tour}
                end
            :player_turn -> 
                if is_current_player?(context,user_id) do 
                    {:ok, :player_turn}
                else 
                    {:ok, :pas_son_tour}
                end
            _ -> {:erreur, :inconnu}
        end
        else
            {:erreur, :inappropriate_time}
        end
    end

    @doc ~s"""
        move_set = [%Position{}] 
        decrivant toute les cases par lequel va passé le joueur
        Note: peux faire des echec partiel (le context est dans ce cas la quand même mis a jour !)
        Retourne {:ok, context} ou {:erreur, context, :collision} ou {:erreur, context, :inconnu}
    """
    def player_moves(context, user_id, move_set) do
        if check_state(context, [:player_turn])  do
            if is_current_player?(context,user_id) do 
                {report, {context,player,_}} = Enum.map_reduce(move_set, {context, get_current_player(context), :continue}, fn 
                    move, {context, %Player{mp: mp} = player, :continue} when mp > 0 ->
                        case UMap.at(context.map, move) do 
                            {:ok, "0"} ->
                                player = put_in player.mp, player.mp -1
                                nmap = UMap.move(context.map, player.position, move)
                                player = Player.set_position(player, move)
                                context = put_in context.map, nmap
                                {{:ok}, {context, player,:continue}}
                            _ ->
                                {{:erreur, :collision}, {context, player, :stop}}
                        end                        
                    _move, {context, player, :continue}  ->
                        {{:erreur, :no_more_mp}, {context,player, :stop}}
                    _move, {context, player, :stop}  ->
                        {{:erreur, :unable}, {context,player, :stop}}
                    _,{_context, player, _state}  ->
                        {{:erreur, :weird}, {context,player, :stop}}
                end)
                case report do 
                    {:ok} ->
                        {:ok, update(context, player)}
                    {:erreur, reason} ->
                        {:erreur, update(context,player), reason}
                    _ ->
                        {:erreur, context, :weird}
                end
            else
                {:ok, :pas_son_tour}
            end        
        else
            {:erreur, context, :inappropriate_time}
        end
    end
    

    @doc ~s"""
        Attaque une case
        Retourne {:ok, context} ou  {:erreur, :pas_son_tour}, :no_more_ap, :same.
    """
    def player_attacks(context, user_id, target) do
        if check_state(context, [:player_turn])  do 
            if is_current_player?(context,user_id) do 
                player = get_current_player(context)
                if player.ap > 0 do 
                    case UMap.at(context.map, target) do 
                        {:ok, mark} when mark == "A" -> 
                            perform_attack(context, player, Enum.at(context.players,0)) 
                        {:ok, mark} when mark == "B" ->
                            perform_attack(context, player, Enum.at(context.players,1))
                        {:ok, mark} when mark == "C" ->
                            perform_attack(context, player, Enum.at(context.players,2))
                        {:ok, mark} when mark == "D" ->
                            perform_attack(context, player, Enum.at(context.players,3))
                        {:ok, "0"} ->
                            {:erreur, :vide}
                        {:ok, _} ->
                            {:erreur, :obstacle}
                        err -> err
                    end 
                else
                    {:erreur, :no_more_ap}
                end
            else
                {:ok, :pas_son_tour}
            end     
        else
            {:erreur, :inappropriate_time}
        end
    end
    
    defp perform_attack(context, player, target) do 
        if player.mark != target.mark do 
            player = put_in player.ap, player.ap -1
            target = put_in target.hp, target.hp -1
            context = context
                |> update(player)
                |> update(target)
            {:ok, context}
        else
            {:erreur, :same}
        end
    end

    @doc ~s"""
        Le joueur courrant passe son tour.
        """
    def player_pass(context, user_id) do  
        if check_state(context, [:player_turn]) do 
            if is_current_player?(context,user_id) do 
                switch_to_next_player(context)
            else
                {:ok, :pas_son_tour}
            end
        else
            {:erreur, :inappropriate_time}
        end
    end
    

    @doc ~s"""
        Note que l'on doit changer de joueur courant
        Retourne {:ok, context}
    """
    def switch_to_next_player(context) do 
        context = put_in context.current_player, context.current_player + 1
        
        notify_all_users_refresh(context, 1000)
        if has_game_ended?(context) do 
            {:ok, put_in( context.status, :end_game)}
        else 
            if context.current_player == length(context.players) do 
                {:ok, put_in( context.current_player, 0)}
            else 
                {:ok, context}
            end
        end
    end
end
