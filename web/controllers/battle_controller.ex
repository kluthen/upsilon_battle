defmodule UpsilonBattle.BattleController do
  use UpsilonBattle.Web, :controller

  # Notes

  # Acces au données en session: 
  # conn = put_session(conn, :message, "new stuff we just set in the session")
  # message = get_session(conn, :message)

  # S'assure qu'un user_id existe ! sinon en créer un.
  plug :check_user

  # Permet de recuperer l'user id
  defp get_user_id(conn) do 
    get_session(conn, :user_id)
  end

  # Recupere l'etat du jeu
  defp get_engine() do 
    UpsilonBattle.EngineStore.get()
  end

  # Stock l'etat du jeu.
  defp set_engine(engine) do 
    UpsilonBattle.EngineStore.set(engine)
  end

  # GET Permet au joueurs de rejoindre le combat ! 
  def index(conn, _params) do
    _uid = get_user_id(conn)
    render conn, "index.html"
  end

  # POST Inscrit un nouveau joueur
  def new_player(conn, _params) do 
    _uid = get_user_id(conn)
    _engine = get_engine()
    set_engine(_engine)
    redirect conn, to: "/battle/map"
  end

  # GET Recupere la map
  def map(conn, _param) do 

    redirect conn, to: "/battle/map"
  end

  # Ces methodes doivent renvoyer du JSON ! 
  # Les appels vers ces fonctions seront fait en ajax !


  # GET Recupere la map
  def map_refresh(conn, _param) do 

    json conn, %{result: :ok}
  end

  # Prend en compte un mouvement
  # Attention: le jeu dois attendre son appel, sinon 
  # renvoyer une erreur (pas son tour)
  def move(conn, _params) do

    json conn, %{result: :ok}
  end

  # Prend en compte une attaque
  # Attention: le jeu dois attendre son appel, sinon 
  # renvoyer une erreur (pas son tour)
  def attack(conn, _params) do

    json conn, %{result: :ok}
  end

  # Prend en compte la position initiale du joueur
  # Attention: le jeu dois attendre son appel, sinon 
  # renvoyer une erreur (pas son tour)
  def position(conn, _params) do

    json conn, %{result: :ok}
  end

  # Termine l'action / le mouvement / le positionnement du joueur
  # Attention: le jeu dois attendre son appel, sinon 
  # renvoyer une erreur (pas son tour)
  def pass(conn, _params) do 

    json conn, %{result: :ok}
  end

  # Controler que l'utilisateur possede un numero, sinon en créer un. 
  def check_user(conn, _params) do 
    case get_session(conn, :user_id ) do 
      nil -> 
        put_session(conn, :user_id, UUID.uuid4())
      _ ->
        :ok
      end
      conn
  end

end
