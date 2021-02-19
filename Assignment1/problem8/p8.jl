##
using Random
using Plots
using LaTeXStrings
Random.seed!(50)

#event A : having an amount >=10 after 20 days.
#event B : not going bankrupt in between.
function Simulate(p,n_trials)
    count_numr=0
    count_denom=0
    for _ in 1:n_trials
        net_profit=0
        flag=false;
        for _ in 1:20
            rn=rand()
            if(rn>p)
                net_profit+=1
            else
                net_profit-=1
            end
            
            #if goes bankrupt at least once..
            if(net_profit==-10)
                flag=true
            end
        end

        
        if(flag==false)
            count_denom+=1
            if(net_profit>=0)
                count_numr+=1
            end
        end
    end
    return count_numr/count_denom
end
    
##
n_trails=10^6
vals=[Simulate(p,n_trails) for p in 0:0.01:1]
plot_1=scatter(0:0.01:1,vals,color=:blue,xlabel="p",ylabel=L"\frac{P(A \bigcap B)}{P(B)}",label="probability",guidefont=(8),legend=:topright)
savefig(plot_1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem8/a1p8.png")
##
