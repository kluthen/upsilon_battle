# Corriger des exercices du cours 1
# On notera que tout ce qui est précédé d'un # en elixir est un commentaire et n'est pas concideré par le langage comme utile  ;)
# Pour executer le code, il suffit de faire: 
# mix run exos/c1/corrige.exs
# Conciderez aussi que tout ce qui est ecris hors # correspond a une ligne que vous auriez pu ecrire dans iex. 

IO.puts "Exercice 1"
# 
# * Sachant le jour (L/M/Me/J/V/S/D) courant, quel jour on sera dans x jours.
#

# Petite liste contenant les jours de la semaine
jours = [:lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche ]
# On se souviendra qu'on accede au valeurs d'une liste par leur "index", le quel commence a 0 (pour Lundi) et ici termine a 6 (Dimanche)
aujourdhui =  4 # pour vendredi
dans_x_jours = 45

# il y a pleins de solutions pour obtenir le jour cible mais globalement on peux se limité a une operation: Reste de division (rem)
jour_cible = rem aujourdhui + dans_x_jours, 7 

# IO.puts permet d'ecrire dans la console, quand vous executerez ce code, vous ne verez finalement que les effets d'IO.puts s'afficher !
# Pour travailler avec les strings, il est toujours possible d'utiliser l'operateur " #{} " pour integrer d'autre variables
IO.puts "Dans #{dans_x_jours} jours, sachant que nous somme un #{Enum.at(jours, aujourdhui)} nous serons un #{Enum.at(jours, jour_cible)} "
 

IO.puts "Exercice 2"
# 
# * Créer un tableau à deux dimensions de largeur 10 et de hauteur 10 , la remplir de 0, assurer que tout le tour du tableau soit remplis de X.
# Exemple: ( ca rend mieux en console ;p )
# XXXXXX
# X0000X
# XXXXXX


# Bon la methode "feignant" qui marche juste ici ;)

tableau = [
    ["X","X","X","X","X","X","X","X","X","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","0","0","0","0","0","0","0","0","X"] ,
    ["X","X","X","X","X","X","X","X","X","X"] ,
]

# La methode un peu plus sympa : 


IO.inspect 0..9

# for <une_variable> <- <une liste> do ... end 
# cette syntaxe permet d'iterer sur chaque element de la liste
tableau_2 = for ligne <- 0..9 do 
                # Le code entre do ... end va etre executer pour chaque element de la liste.
                # la syntaxe 0..9 permet de créer une liste qui va de 0 a 9 
                # donc ici a cet endroit, ligne vaudra a tour de role, 0, 1, 2, 3, 4, 5, 6, 7, 8 et finalement 9
                for colone <- 0..9 do 
                    # même chose ici avec colone. 

                    # case permet de testé la valeur de ligne. 
                    case ligne do 
                        0 -> "X" # dans le cas ou ligne vaux 0, on met un X  ( afin de faire que la premiere ligne soit remplie de X) dans chaque colone.
                        9 -> "X" # Dans le cas ou ligne vaux 9 on met un X dans chaque colone.
                        _ -> # sinon ( dans le cas ou on est ni a la ligne 0 ni dans la ligne 9 )
                            case colone do 
                                0 -> "X" # Si la colone est 0 ( la bordure de gauche ) on met un X.
                                9 -> "X" # Si c'est la colone de droite ( 9 ) On met un X.
                                _ -> "0" # Sinon on met un "0". 
                            end 
                    end
                end
            end

IO.inspect tableau

IO.inspect tableau_2

IO.puts "Exercice 3"
# 
# * Faire une fonction qui imprime le tableau sur la sortie standard( params: le tableau )

# Si on prend un tableau en parametre, il nous reste juste a "mettre en string" ce tableau. 
# Pour cela on va utiliser la fonction Enum.join/2 qui permet de transformer chaque element en string et de mettre entre deux, un caractere (ici rien.)
print = fn(tableau) ->
    IO.puts Enum.join(
        for ligne <- tableau do 
            # Un saut de ligne se represente par \n (ou \r\n sous windows )
            "#{Enum.join ligne}\r\n"
        end
    )
end

print.(tableau)

IO.puts "Exercice 4"
# 
# * Faire une fonction qui retourne l’objet a une position donnée du tableau (params: tableau, x, y) retourne {:ok, valeur}, {:erreur, :x_invalide}, {:erreur, :y_invalide} 
# 
search = fn(tableau, x, y) ->
    # Enum.at/3 permet de chercher une valeur dans une liste, et dans le cas ou cette element n'existe pas de renvoyer le troisieme parametre 
    # (ici par exemple {:erreur,:x_invalide} )
    case Enum.at(tableau, x, {:erreur,:x_invalide}) do
        # case fait plus qu'un simple test d'egalité
        # il est capable de voir a l'interieur des choses.
        # ainsi, ici on regartde si le resultat d'Enum.at/3 ressemble a {:erreur, :x_invalide }
        # techniquement, on en a rien a faire de savoir quel erreur est remonté
        # donc on peux remplacer les champs inutile par _ 
        # d'autre part, on est interessé par l'erreur en entier
        # donc avec {:erreur, _ } = err on enregistre le retour de Enum.at/3 dans err
        # et on le renvois en resultat de case juste apres.
        {:erreur, _ } = err -> err 
        ligne -> 
            Enum.at(ligne, y, {:erreur, :y_invalide} )
    end
end

IO.inspect search.(tableau, 50, 0)
IO.puts search.(tableau,5,5)

IO.puts "Exercice 5"
# * Faire une fonction qui génère le tableau précédant, prenant en paramètre la hauteur et la largeur, elle doit renvoyer le {:ok, tableau} ou {:erreur, :hauteur} ou {:erreur, :largeur}  en cas de paramètres invalide. (paramètre valide: > 5 )
# 

create = fn
    # fonction a la mode case :)
    # ici on test specifiquement si lignes et colones sont positif.
    lignes, colones when lignes > 3 and colones > 3 ->
        # on commence a 1 pour eviter d'avoir une ligne/colone en trop
        tableau = for ligne <- 1..lignes do 
            for colone <- 1..colones do 
                case ligne do 
                    1 -> "X" 
                    ^lignes -> "X" # Ici, contrairement a tout a l'heure avec = err, on ne remplis pas la variable lignes, on test avec ^lignes si ligne est identique.
                    _ ->
                        case colone do 
                            1 -> "X" 
                            ^colones -> "X" # même chose :)
                            _ -> "0" 
                        end 
                end
            end
        end
        {:ok, tableau}
    lignes, colones when lignes <= 3 ->
        {:erreur, :lignes}
    lignes, colones when colones <= 3 ->
        {:erreur, :colones}
end

# Comme pour case, = permet de testé la structure qu'on assigne.
# comme la fonction create renvois en cas de succes {:ok, tableau }
# on verifie avec = qu'il y ai bien un {:ok, } et on recupere le tableau en mettant un nom de variable a la place du tableau.
{:ok, tableau_3 } = create.(5,4)
# On peux aussi valider que la valeur corresponde a une valeur contenu dans une autre variable.
# ici je verifie que le tableau de 10,10 corresponde bien a celui qu'on a créer au debut !
{:ok, ^tableau } = create.(10,10)

print.(tableau_3)

IO.inspect create.(0,2)
IO.inspect create.(4,2)

IO.puts "Exercice 6"
# * Faire une fonction qui ajoute un marqueur dans le tableau (params: tableau, marqueur(A,B,C,D), position).
#     En cas de positionnement valide ( case cible = 0 ) renvois {:ok, nouveau tableau }, sinon {:erreur, :position_invalide}
# 

# Helper ( un outils pour aidé ):
# Cette fonction va mettre un marqueur (qu'importe lequel d'ailleur) a l'endroit indiqué
put = fn tableau, marqueur, x, y  ->
        case search.(tableau, x, y) do
            {:erreur, _ } -> {:erreur, :position_invalide }
            _ ->
                # ici on a la partie compliqué. 
                # comme en elixir on ne modifie pas les variables
                # on va devoir créer un nouveau tableau, identique au premier
                # avec pour seul difference le nouveau caractere. 
                nb_lignes = length( tableau )-1
                ntable = for cx <- 0..nb_lignes do 
                    ligne = Enum.at(tableau, cx)
                    nb_colones = length( ligne )-1
                    for cy <- 0..nb_colones do 
                        if cx == x and cy == y do 
                            marqueur
                        else
                            Enum.at(ligne, cy)
                        end 
                    end
                end
                {:ok, ntable}
            _ -> {:erreur, :position_invalide}
        end
end

insert = fn tableau, marqueur, x, y when marqueur == "A" 
                            or marqueur == "B" 
                            or marqueur == "C" 
                            or marqueur == "D" ->
    case search.(tableau, x, y) do 
        "0" -> put.(tableau,marqueur,x,y)
        _ -> {:erreur, :position_invalide}
    end
    _,_,_,_ -> {:erreur, :marqueur_invalide}
end

{:ok, tableau_test } = create.(5,5)
{:ok, tableau_avec_marqueur } = insert.(tableau_test, "A", 2,2)
print.(tableau_avec_marqueur)

IO.puts "Exercice 7"
# * Faire une fonction qui déplace un marqueur dans le tableau (params: tableau, position du marqueur, nouvelle position )
#     Valid: position dans le tableau = A B C D, nouvelle position = 0
#     {:ok, nouveau tableau }
#     sinon {:erreur, :origine_invalide}
#     sinon {:erreur, :cible_invalide}
# 

move = fn tableau, origin_x, origin_y, x, y ->
    case search.(tableau, origin_x, origin_y) do
        {:erreur, _ } -> {:erreur, :position_invalide }
        contenu when contenu == "A" 
                     or contenu == "B" 
                     or contenu == "C" 
                     or contenu == "D" -> 
            case insert.(tableau, contenu, x,y ) do
                {:ok, tab }  -> 
                    put.(tab, "0", origin_x,origin_y)
                _ -> {:erreur, :cible_invalide}
            end
        _ -> {:erreur, :origine_invalide}
    end
end

{:ok, tableau_deplacer } = move.(tableau_avec_marqueur, 2,2, 3,3)
print.(tableau_deplacer)
