

print = fn tableau ->
    IO.inspect tableau
end
test = [1,2,3,[4,5,6]]
print.(test)
print.([1,2,3,4,5])

marquer = fn tableau, marqueur, x, y ->
    for i <- 0..(length(tableau)-1) do
        if i != y do
            IO.puts Enum.join(Enum.at(tableau, i),"")
        else 
            ligne = Enum.at(tableau, i)
            res = for o <- 0..length(ligne) do
                if o != x do
                    Enum.at(ligne,o)
                else 
                    marqueur
                end
            end
            IO.puts Enum.join(res, "")
        end
    end
end

res = for i <- 0..10 do 
    if i < 5 do
        'a'
    else
        'b'
    end
end

IO.inspect res

IO.puts Enum.join(res, "")

test = fn ->
    # Crée un beau tableau tout neuf :
    [1,2,3,4]
end

tab = test.();
