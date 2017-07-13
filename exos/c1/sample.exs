

print = fn tableau ->
    IO.inspect tableau
end
test = [1,2,3,[4,5,6]]
print.(test)
print.([1,2,3,4,5])

