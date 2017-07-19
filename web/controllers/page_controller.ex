defmodule UpsilonBattle.PageController do
  use UpsilonBattle.Web, :controller

  # Exercice 2: on fait sauté le _ de params afin d'indiqué qu'on compte se servir de cette valeur.
  def index(conn, params) do

    #Exercice 1
    jours = [:lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche ]

    #Exercice 2
    default = %{ "aujourdhui" => (:rand.uniform(7) -1 ), "dans_x_jours" => 45 }
    # On merge (fusionne) les deux maps, de facon a ce qu'on ai des valeurs valide 
    # quelque soit le contenu de param
    # Map.merge(map1, map2, callback)
    #   D'apres la doc, la fonction en 3e argument prend 3 parametres:
    #     * la clé
    #     * la valeur de la premiere map.
    #     * la valeur de la seconde map
    # 
    # La fonction est appelé en cas de conflit ( les deux maps présente la même clé )
    # Ici nous voulons en profiter pour convertir la String en chiffre
    # Avec la fonction String.to_intger()
    resultat = Map.merge(default, params, fn(_k, d, p )->
        String.to_integer(p)
      end)

    #Exercice 1 (fin)
    jour_cible = rem( resultat["aujourdhui"] + 
                      resultat["dans_x_jours"] , 7 )

    # deux options, soit on utilise
    # render conn, "index.html", aujourdhui: ..., cible: ..., etc
    # soit on utilise la fonction assign(conn, key, value)
    # l'operateur |> (pipe) permet de faire des operations du type: 
    # conn = assign(conn, )
    # Ou on passe un objet en premier parametre et on le recupere en resultat "modifié"
    # Et il est rendu disponible pour le prochain appel de fonction !
    conn
    |> assign(:aujourdhui, Enum.at(jours, resultat["aujourdhui"]) )
    |> assign(:cible, resultat["dans_x_jours"] )
    |> assign(:resultat, Enum.at(jours, jour_cible))
    |> render("index.html")
  end
end
