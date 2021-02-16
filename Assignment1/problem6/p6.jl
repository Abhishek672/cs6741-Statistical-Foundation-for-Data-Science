##
using Random
using Plots
Random.seed!(0)
function Simulate(p,n_trials)
    count=0
    for _ in 1:n_trials
        net_profit=0
        for _ in 1:20
            rn=rand()
            if(rn>p)
                net_profit+=1
            else
                net_profit-=1
            end
        end
        if (net_profit>=0)
            count+=1
        end
    end
    return count/n_trials
end
    
##
n_trails=10^2
vals=[Simulate(p,n_trails) for p in 0:0.05:1]
scatter(0:0.05:1,vals,color=:orange,xlabel="p",ylabel="P(at least 10 rupee after 20 days)",label="probability")
##