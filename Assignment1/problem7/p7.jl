##
using Random
using Plots
Random.seed!(50)

function Simulate(p,n_trials)
    count=0
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
            
            if(net_profit==-10)
                flag=true
                break
            end
        end

        #if flag==false that means we were not bankrupt at any day in these 20 days of play..
        if(flag==false)
            count+=1
        end
    end
    return 1-count/n_trials
end
    
##
n_trails=10^6
vals=[Simulate(p,n_trails) for p in 0:0.01:1]
plot_1=scatter(0:0.01:1,vals,color=:red,xlabel="p",ylabel="P(going bankrupt at least once)",label="probability",guidefont=(10),legend=:topleft)
savefig(plot_1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem7/a1p7.png")
##