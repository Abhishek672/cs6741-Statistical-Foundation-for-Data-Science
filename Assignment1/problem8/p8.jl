##
using Random
using Plots
Random.seed!(50)

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
scatter(0:0.01:1,vals,color=:red,xlabel="p",ylabel="P(toatl amount>=10 | no state of bankrupt)",label="probability",guidefont=(10),legend=:topleft)
#savefig(plot_1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem7/a1p7.png")
##