##
using Plots
n_samples=[5,50,100,200,500,1000,2000,5000,10000,50000,10^5,500000,10^6]
averages=[]
using Random
Random.seed!(4)
for sample in n_samples
    sum=0
    for _ in 1:sample
        sum+=rand(-50:50)
    end
    push!(averages,sum/sample)
end
plot_p1=plot(1:length(averages),averages,xlabel="samples taken",
ylabel="average",size=(700,600),xticks=(1:length(n_samples),n_samples),
label="averages",color=:red,grid=false)
savefig(plot_p1,"/Users/abhisheknegi/Desktop/Stats_4_ds/Assignment1/problem1/a1p1.png")
##