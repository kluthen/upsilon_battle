defmodule UpsilonBattle.Engine do 
    defstruct map_id: UUID.uuid4()

    # Initialise le moteur.
    def init(_context) do 

    end

    # Enregistre un nouvel utilisateur ...
    # Peux echouer si y a deja 4 joueurs ... 
    # retour: {:ok, [positions_depart_dispo] } ou {:ok, :observateur}
    def add_user(_context, _user_id, _username) do 

    end

    # Retourne true ou false :)
    def user_known?(_context, _user_id) do 

    end

    # Retourne si l'utilisateur est un joueur ou non
    def user_is_player?(_context, _user_id) do 

    end

    # Stock la socket de communication d'un utilisateur
    # Peux echouer si l'utilisateur est inconnu
    # retour :ok ou {:erreur, :inconnu}
    def register_user_socket(_context, _user_id, _socket) do 

    end


    # Retourne les positions de depart disponible pour l'utilisateur
    def get_user_start_position(_context, _user_id) do 
        
    end

    # Positionne l'utilisateur sur la carte (uniquement lors de la phase de positionnement)
    # return :ok ou {:erreur, :inconnu}, {:erreur, :impossible}, {:erreur, :deja_fait}
    def set_user_initial_position(_context, _user_id, _x, _y) do 

    end

    # Dit quel joueurs dois jouer. 
    def get_current_player(_context) do 

    end

    # Indique aux joueurs qu'ils doivent se mettre a jour
    def notify_all_users_refresh(_context) do 
        UpsilonBattle.RefreshChannel.refresh_all_players()
    end

    # Retourne: 
    #  {:erreur, :inconnu}
    #  {:erreur, :pas_son_tour}
    #  {:ok, :move}        Si on attend le deplacement du joueur
    #  {:ok, :attack}      Si on attend l'attaque du joueur
    #  {:ok, :position}    Si on attend la position du joueur
    def get_player_next_action(_context, _user_id) do 

    end

    # move_set = [{x,y}] 
    # decrivant toute les cases par lequel va passé le joueur
    # Retourne :ok ou {:erreur, :colision} ou {:erreur, :inconnu}
    def player_moves(_context, _user_id, _move_set) do
        
    end

    # Attaque une case
    # Retourne :ok ou  {:erreur, :inconnu}
    def player_attacks(_context, _user_id, _target_x, _target_y) do 

    end

    # Note que l'on doit changer de joueur courant
    def switch_to_next_player(_context) do 

    end

end