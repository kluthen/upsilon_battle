
A produire en elixir et en javascript:

* Sachant le jour (L/M/Me/J/V/S/D) courant, quel jour on sera dans x jours.

* Créer un tableau à deux dimensions de largeur 10 et de hauteur 10 , la remplir de 0, assurer que tout le tour du tableau soit remplis de X.
Exemple: 
XXXXXX
X0000X
XXXXXX

* Faire une fonction qui imprime le tableau sur la sortie standard( params: le tableau )
    Note: Enum.join(tableau, separateur)
    Enum.join([1,2,3],”-”) # “1-2-3”
    Enum.join([1,2,3],””) # “123”
    https://hexdocs.pm/elixir/master/Enum.html#join/2 


* Faire une fonction qui retourne l’objet a une position donnée du tableau (params: tableau, x, y) retourne {:ok, valeur}, {:erreur, :x_invalide}, {:erreur, :y_invalide} 

* Faire une fonction qui génère le tableau précédant, prenant en paramètre la hauteur et la largeur, elle doit renvoyer le {:ok, tableau} ou {:erreur, :hauteur} ou {:erreur, :largeur}  en cas de paramètres invalide. (paramètre valide: > 5 )

* Faire une fonction qui ajoute un marqueur dans le tableau (params: tableau, marqueur(A,B,C,D), position).
    En cas de positionnement valide ( case cible = 0 ) renvois {:ok, nouveau tableau }, sinon {:erreur, :position_invalide}

* Faire une fonction qui déplace un marqueur dans le tableau (params: tableau, position du marqueur, nouvelle position )
    Valid: position dans le tableau = A B C D, nouvelle position = 0
    {:ok, nouveau tableau }
    sinon {:erreur, :origine_invalide}
    sinon {:erreur, :cible_invalide}

NOTES: en javascript le résultat sera plus proche de {ok: tableau} ou  {erreur: "valeur"}
