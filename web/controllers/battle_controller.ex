defmodule UpsilonBattle.BattleController do
  use UpsilonBattle.Web, :controller

  # Notes

  # Acces au données en session: 
  # conn = put_session(conn, :message, "new stuff we just set in the session")
  # message = get_session(conn, :message)



  # GET Permet au joueurs de rejoindre le combat ! 
  def index(conn, _params) do
    render conn, "index.html"
  end

  # POST Inscrit un nouveau joueur
  def new_player(conn, _params) do 

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

end
