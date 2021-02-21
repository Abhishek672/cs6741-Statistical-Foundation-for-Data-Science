##
using Random
Random.seed!(50)
Dictionary=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T',
'U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q',
'r','s','t','u','v','w','x','y','z','~','!','@', '#', '$', '%', '^', '&', '*', '(', ')',
 '_', '+', '=', '-', '`']
actual_pass=rand(Dictionary,8);
n_trials=10^6;
count=0
for _ in 1:n_trials
    guessed_pass=rand(Dictionary,8)
    if(sum(guessed_pass.==actual_pass)>=2)
        face1=rand(1:6)
        face2=rand(1:6)
        if(face1==face2)
            count+=1
        end
    end
end
println(count/n_trails)
##