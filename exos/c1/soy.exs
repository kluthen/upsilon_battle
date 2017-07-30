IO.puts "Exercice 1"
jours= [:lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche ]
aujourdhui= 1
plustard= 3
differance= rem(aujourdhui + plustard,7)

IO.puts "Dans #{plustard} jours, sachant que nous somme un #{Enum.at(jours, aujourdhui)} nous serons un #{Enum.at(jours, differance)} "


largeur= [1,2,3,4,5,6,7,8,9,10]
hauteur= [1,2,3,4,5,6,7,8,9,10]

tableau2 = 
    for ligne <- hauteur do
        for colone <- largeur do
            case ligne do
                1 ->"x"
                10 -> "x"
                _   ->
                
                    case colone do 
                        1 ->"x"
                        10 ->"x"
                        _  ->"o"
                    end
            end 

        end

    end

    
tableau3 = 
    for ligne <- 0..5 do
        for colone <- 0..3 do
            case ligne do
                0 ->"x"
                5 -> "x"
                _   ->
                
                    case colone do 
                        0 ->"x"
                        3 ->"x"
                        _  ->"o"
                    end
            end 

        end

    end

affiche= fn tab -> 
    for ligne <- tab do
        IO.puts Enum.join(ligne)
    end
end

affiche.(tableau2)
affiche.(tableau3)
IO.inspect tableau2

cherche = fn tab, colone_recherche, ligne_recherche ->
    ligne= Enum.at(tab, ligne_recherche, {:erreur, :ligne_invalide})
    case ligne do
       {:erreur, :ligne_invalide} -> {:erreur, :ligne_invalide} 
       _ -> 
        valeur= Enum.at(ligne, colone_recherche,{:erreur, :colone_invalide})
        case valeur do
            {:erreur, :colone_invalide} -> {:erreur, :colone_invalide}
            _ -> {:ok, valeur}
        end
    end
end


IO.inspect cherche.(tableau2, 0,5)
IO.inspect cherche.(tableau2, 2,2)
IO.inspect cherche.(tableau2, 25,2)
IO.inspect cherche.(tableau2, 25,852)


cree = fn hauteur, largeur ->
    if largeur >=5 and hauteur >=5 do
        res = for ligne <- 0..(hauteur-1) do
            for colone <- 0..(largeur-1) do
                max_h = hauteur - 1
                case ligne do
                    0 ->"x"
                    ^max_h -> "x"
                    _   ->
                        max_l =largeur-1
                        case colone do 
                            0 ->"x"
                            ^max_l ->"x"
                            _  ->"o"
                        end
                end 

            end

        end
        {:ok, res}
    else
        {:erreur, :parametre_invalide}
    end
end

t = cree.(20,20)
IO.inspect t
{:ok, tab3} = t
affiche.(tab3)
IO.inspect cree.(-5,2)
