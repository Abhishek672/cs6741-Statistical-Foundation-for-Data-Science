##
using Random
using Distributions
##

function wo_replacement(Deck,simulations)
	Random.seed!(1)
	freq_wr=repeat([0.0],num_selections+1)
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
	return freq_wr/simulations
end
##

function with_replacement(Deck,simulations)
	
	Random.seed!(1)
	freq_r=repeat([0.0],num_selections+1)
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
	return freq_r/simulations
end
##

Deck=["A",1,2,3,4,5,6,7,8,9,10,"J","Q","K"]
Deck=repeat(Deck,4)
rng=MersenneTwister(1)
shuffle!(rng,Deck)
simulations=10^6
num_selections=7

##

Exp_r=with_replacement(Deck,simulations)
plot_1=scatter(0:num_selections,Exp_r,title="Experiments(with replacement)",xlabel="n",ylabel="P(n JACKS)",
guidefont=(10),color=:pink,label="")
savefig(plot_1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem2/a1p2_a.png")

##

Exp_wr=wo_replacement(Deck,simulations)
plot_2=scatter(0:num_selections,Exp_wr,title="Experiments(w/o replacement)",xlabel="n",ylabel="P(n JACKS)",
guidefont=(10),color=:cyan,label="")
savefig(plot_2,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem2/a1p2_b.png")
##