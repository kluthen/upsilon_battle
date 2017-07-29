IO.puts "Exercice 1"
jours= [:lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche ]
aujourdhui= 1
plustard= 3
differance= rem(aujourdhui + plustard,7)

IO.puts "Dans #{plustard} jours, sachant que nous somme un #{Enum.at(jours, aujourdhui)} nous serons un #{Enum.at(jours, differance)} "


largeur= [1,2,3,4,5,6,7,8,9,10]
hauteur= [1,2,3,4,5,6,7,8,9,10]

resultat = for ligne <- hauteur do
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


IO.inspect resultat