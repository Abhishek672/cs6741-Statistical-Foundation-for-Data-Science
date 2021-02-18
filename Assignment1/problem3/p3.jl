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

function return_Binomial(N,r,p)
	
	if (r>N)
		return 0.0
	end
    return binomial(N,r)*(p)^r*(1-p)^(N-r)
end

##

function return_Hypergeometric(N,n,a,r)

    if(r>a)
        return 0.0
    end
    numr=binomial(a,r)*binomial(N-a,n-r)
    denom=binomial(N,n)
    return numr/denom
end

##

Deck=["A",1,2,3,4,5,6,7,8,9,10,"J","Q","K"]
Deck=repeat(Deck,4)
rng=MersenneTwister(1)
shuffle!(rng,Deck)
simulations=10^6
num_selections=7

##

Emp_r=with_replacement(Deck,simulations)
Th_r=[return_Binomial(5,r,4/52) for r in 0:num_selections]
scatter(0:num_selections,Th_r,color=:pink,label="Theoritical prob",
title="Theoritical v Empirical(with replacement)",xlabel="n",ylabel="Probability",guidefont=(8))
plot_1=scatter!(0:num_selections,Emp_r,color=:blue,label="empirical prob",marker=:+,markersize=10)
savefig(plot_1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem3/a1p3_a.png")

##
Emp_wr=wo_replacement(Deck,simulations)
Th_wr=[return_Hypergeometric(52,5,4,r) for r in 0:num_selections]
scatter(0:num_selections,Th_wr,color=:cyan,label="Theoritical prob",
title="Theoritical v Empirical(w/o replacement)",xlabel="n",ylabel="Probability",guidefont=(8))
plot_2=scatter!(0:num_selections,Emp_wr,color=:orange,label="Empirical",marker=:+,markersize=10)
savefig(plot_2,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem3/a1p3_b.png")
##