##
using Plots
n_samples=[5,50,100,200,500,1000,2000,5000,10000,50000,10^5,500000,10^6]
averages=[]
using Random
for sample in n_samples
    sum=0
    for _ in 1:sample
        sum+=rand(-50:50)
    end
    push!(averages,sum/sample)
end
plot(1:length(averages),averages,xlabel="samples taken",
ylabel="average",size=(700,600),xticks=(1:length(n_samples),n_samples),
label="averages",color=:red)
##