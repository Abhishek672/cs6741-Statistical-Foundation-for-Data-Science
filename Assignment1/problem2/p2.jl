##
using Random
using Distributions
##

Deck=["A",1,2,3,4,5,6,7,8,9,10,"J","Q","K"]
Deck=repeat(Deck,4)
rng=MersenneTwister(1)
shuffle!(rng,Deck)
simulations=10^5
freq_wr=repeat([0.0],8);
freq_r=copy(freq_wr);
##

Random.seed!(4)

#without replacement...
for _ in 1:simulations
    d1=copy(Deck)
    count=0
    for _ in 1:5
        card=rand(d1)
        deleteat!(d1,findfirst(x->x==card,d1))
        if card=="J"
            count+=1
        end
    end
    freq_wr[count+1]+=1
end

#with replacement..
for _ in 1:simulations
    count=0
    for _ in 1:5
        card=rand(Deck)
        if card=="J"
            count+=1
        end
    end
    freq_r[count+1]+=1
end

##
scatter(0:7,freq_wr/simulations,color=:red,title="pmf",
xlabel="n",ylabel="P(x=n)",label="without replacement")
plot_2=scatter!(0:7,freq_r/simulations,color=:blue,label="with replacement")
savefig(plot_2,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem2/a1p2.png")
println(freq_wr/simulations)
println(freq_r/simulations)
##
