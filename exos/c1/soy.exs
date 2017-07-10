IO.puts "Exercice 1"
jours= [:lundi, :mardi, :mercredi, :jeudi, :vendredi, :samedi, :dimanche ]
aujourdhui= 1
plustard= 3
differance= rem(aujourdhui + plustard,7)

    IO.puts "Dans #{plustard} jours, sachant que nous somme un #{Enum.at(jours, aujourdhui)} nous serons un #{Enum.at(jours, differance)} "

    