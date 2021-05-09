### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ ff794c7e-ad03-11eb-1b84-71619cc79ff6
begin
	using PlutoUI
	using StatsPlots
	using RDatasets
	using StatsBase
	using Distributions
	using LaTeXStrings
	using Dates
	using Plots
	plotly()
	using Statistics
	using DataFrames
	using Random
	using QuadGK
	using RDatasets
end


# ╔═╡ 88ae309e-ad05-11eb-0983-39b700df744f
md"**Q1**"

# ╔═╡ 8f835896-b079-11eb-1eaf-27f4a259f828
md"**1.a Monte Carlo Simulations**"

# ╔═╡ 0a2f44a2-ad04-11eb-3adb-af61368879af
function A4_Q4_1(simulations)
	Random.seed!(10)
	c=0
	for _ in 1:simulations
		total_heads = sum(rand(50).<=0.5)
		if total_heads >= 30
			c+=1
		end
	end
	
	return c/simulations
end


# ╔═╡ 8c911f38-b079-11eb-11df-399bf317f399
A4_Q4_1(1000000)

# ╔═╡ b3ada5fa-b079-11eb-0e95-073dc0a14a08
md"**1.b.Computation using binomial distribution**"

# ╔═╡ 0dc5a358-b07a-11eb-34f6-51d544d27b0e
begin
	ansb1 = sum(binomial(big(50),big(r))*(0.5)^r*(0.5)^(50-r) for r in 30:50)
	ansb1
end

# ╔═╡ 0ee9fdb0-b07a-11eb-12ba-3d2e460b1b67
md"**1.c. using CLT**"

# ╔═╡ 0fb111c8-ad5e-11eb-0f77-bfdbfbf1abd0
1-cdf(Normal(25,3.535),29.5)

# ╔═╡ a8d5d552-ad05-11eb-28a0-7582f454484e
md"**Q2**"

# ╔═╡ 4b70faba-b07d-11eb-15de-7500c0b6dbfc
md"**2.a. Using CLT**"

# ╔═╡ 10b06ce8-ad04-11eb-3007-45be1635d9af
function get_min_p_CLT(n)
	Random.seed!(10)
	
	#initial phead..
	pheads = 0.5
	#step size..
	inc = 0.002
	
	while pheads <= 1.0
		
		#getting mean and s.d. of the Normal distribution approximated by CLT..
		μ = n*pheads
		σ = sqrt(n*pheads*(1-pheads))
		
		p_going_ahead = 1-cdf(Normal(μ,σ),29.5)
		
		if p_going_ahead >= 0.5
			return pheads
		end
		
		#incrementing the pheads by step size..
		pheads=round(pheads+inc;digits=3)
	end
	return -1
end


# ╔═╡ 198c0aac-ad04-11eb-2032-b533c5845ff9
ans2 = get_min_p_CLT(50)

# ╔═╡ 5a776f58-b07d-11eb-060d-ed2e68fcc7d9
md"**2.b Verification Using Monte Carlo Simulation with p_heads=0.59**"

# ╔═╡ 2045e606-ad04-11eb-3e03-e519d75db485
function A4_Q2_2(simulations,pheads)
	Random.seed!(10)
	c1=0
	for _ in 1:simulations
		total_heads = sum(rand(50).<=pheads)
		if total_heads >= 30
			c1+=1
		end
	end
	
	return c1/simulations
end

# ╔═╡ c87833de-b07d-11eb-2683-dfcf2b15278b
A4_Q2_2(1000000,0.59)

# ╔═╡ 20dd8880-b07e-11eb-20a7-bbb30e51f245
md"**2.c Verification using Binomial Distribution with p_heads=0.59**"

# ╔═╡ da8d1dea-ad60-11eb-103b-5f58806e2411
sum(binomial(big(50),big(r))*(0.59)^r*(0.41)^(50-r) for r in 30:50)

# ╔═╡ a8c2f882-ad63-11eb-2de4-13103381aa12
md"**Q3**"

# ╔═╡ aff33810-ad63-11eb-0edd-1768200d1128
function Q3_A4()
	μ = 100
	σ = 30
	
	for n in 2:100
		
		#Using CLT...
		Dn = Normal(n*μ,sqrt(n)*σ)
		
		if(1-cdf(Dn,2999.5) >= 0.95)
			return n
		end
	end
	return -1
end

# ╔═╡ b252965c-ad63-11eb-23e4-f9f5cc43ee59
Q3_A4()

# ╔═╡ b25bc0f0-ad05-11eb-1c95-f3ea7f04b854
md"**Q4**"

# ╔═╡ 272db25a-ad04-11eb-164d-41d5b3af6703
# Given the distribution it returns the smallest sample size "n" such that
# Sum((Xi-u)/Sn) matches N(0,1) and also the 4 moments for previous values of #"n"..

function Q4_A4_1(Dgiven)
	Random.seed!(10)
	
	#will contain the 4 moments for 2,3,4....n
	mean_arr=[]
	var_arr=[]
	skew_arr=[]
	kur_arr=[]
	n_arr=[]
	
	#population parameters..
	μ = mean(Dgiven)
	σ = std(Dgiven)
	Dn = Normal(0,1)
	
	for n in 2:500
		samples = []
		for k in 1:10000
			#getting n elements for a sample..
			X=rand(Dgiven,n)
			#calculating the Sn..
			sn = sqrt(n)*σ
			#transforming X..
			X = (X.-μ)./sn
			#1st sample created..
			push!(samples,X)
		end
		
		#getting the sum for each sample..
		Y=[sum(sample) for sample in samples]
		
		push!(n_arr,n)
		
		push!(mean_arr,mean(Y))
		d1 = abs(mean(Y)-mean(Dn))
		
		push!(var_arr,var(Y))
		d2 = abs(var(Y)-var(Dn))
		
		push!(skew_arr,skewness(Y))	
		d3 = abs(skewness(Y)-skewness(Dn))
		
		#pushing excess kurtosis to the array..
		push!(kur_arr,kurtosis(Y)+3)
		d4 = abs(kurtosis(Y)-kurtosis(Dn))
		
		#if all 4 moments match within 0.1 return the minimum n and the moments array.
		if(d1<=0.1 && d2<=0.1 && d3<=0.1 && d4<=0.1)
			vals=[]
			push!(vals,mean_arr)
			push!(vals,var_arr)
			push!(vals,skew_arr)
			push!(vals,kur_arr)
			
			return (n,vals)
		end
	end
	return (-1,-1)
end

# ╔═╡ 02f84f86-adc6-11eb-1871-49f30725168a
#Given the distribution this function return the plots and n..
function Q4_A4_2(Dgiven)
	
	#get the minimum 'n' and 4 moments array for each 2,3,4....min(n) 
	(n,vals) = Q4_A4_1(Dgiven)
	
	println("hello")
	disb = SubString(string(Dgiven),15)
	
	#moments of empirical distribution obtained by CLT..
					                 								         
	
	plot1 = scatter(2:n,vals[1],xlabel="n",title=disb,label="μ",markersize=2)
	scatter!(2:n,vals[2],label="σ^2",markersize=2)
	scatter!(2:n,vals[3],label="skew",markersize=2)
	scatter!(2:n,vals[4],label="kurtosis",markersize=2)
	
	#moments of N(0,1)..
	plot!(2:n,fill(0,n-1),label="M1_N(0,1)=0")
	plot!(2:n,fill(1,n-1),label="M2_N(0,1)=1")
	plot!(2:n,fill(0,n-1),label="M3_N(0,1)=0")
	plot!(2:n,fill(3,n-1),label="M4_N(0,1)=3")
	
	
	return (n,plot1)
end

# ╔═╡ 6e1bd31c-adca-11eb-0775-d5d8b147b298
md"**4.a**"

# ╔═╡ edf287cc-ad67-11eb-3cc7-e9413effcc37
begin
	ansto1 = Q4_A4_2(Uniform(0,1))
	plot_1 = ansto1[2]
	n_1 = ansto1[1]
end

# ╔═╡ bc95dc3e-b089-11eb-0059-4f66bb3b5c8a
plot_1

# ╔═╡ 80353a70-adca-11eb-1178-c36a81ecdc07
md"**4.b**"

# ╔═╡ 6e22b768-ad7d-11eb-187e-b31ec73ca147
begin
	ansto2 = Q4_A4_2(Binomial(50,0.01))
	plot_2 = ansto2[2]
	n_2 = ansto2[1]
end

# ╔═╡ eaa3b2d8-b089-11eb-17d2-652d01c8c942
plot_2

# ╔═╡ 84ca0104-adca-11eb-3d4c-c989af9fe500
md"**4.c**"

# ╔═╡ 102a88a6-ad7e-11eb-1068-e7bfaa23d3c4
begin
	ansto3 = Q4_A4_2(Binomial(50,0.5))
	plot_3 = ansto3[2]
	n_3 = ansto3[1]
end

# ╔═╡ 0ba4ec1a-b08a-11eb-13fe-2b508afe4a4f
plot_3

# ╔═╡ 899c52e2-adca-11eb-04bc-997e90c43157
md"**4.d**"

# ╔═╡ 374956a8-ad72-11eb-165d-e38a2d5dcdb3
begin
	ansto4 = Q4_A4_2(Chisq(3))
	plot_4 = ansto4[2]
	n_4 = ansto4[1]
end

# ╔═╡ 251c47d6-b08a-11eb-1b39-0d5215e145ec
plot_4

# ╔═╡ 40790758-b08a-11eb-178a-39bb75de9f31
md"**Q5**"

# ╔═╡ 6e45af12-b017-11eb-1be9-f17083d29716
function A4_Q5()
	for K in 1:100
		if(cdf(Chisq(K),5)<0.9)
			return K-1
		end
	end
	
	return -1
end

# ╔═╡ 2aa696b8-b0d8-11eb-1872-df216d4e6a5c
A4_Q5()/100

# ╔═╡ Cell order:
# ╠═ff794c7e-ad03-11eb-1b84-71619cc79ff6
# ╟─88ae309e-ad05-11eb-0983-39b700df744f
# ╟─8f835896-b079-11eb-1eaf-27f4a259f828
# ╠═0a2f44a2-ad04-11eb-3adb-af61368879af
# ╠═8c911f38-b079-11eb-11df-399bf317f399
# ╟─b3ada5fa-b079-11eb-0e95-073dc0a14a08
# ╠═0dc5a358-b07a-11eb-34f6-51d544d27b0e
# ╟─0ee9fdb0-b07a-11eb-12ba-3d2e460b1b67
# ╠═0fb111c8-ad5e-11eb-0f77-bfdbfbf1abd0
# ╟─a8d5d552-ad05-11eb-28a0-7582f454484e
# ╟─4b70faba-b07d-11eb-15de-7500c0b6dbfc
# ╠═10b06ce8-ad04-11eb-3007-45be1635d9af
# ╠═198c0aac-ad04-11eb-2032-b533c5845ff9
# ╟─5a776f58-b07d-11eb-060d-ed2e68fcc7d9
# ╠═2045e606-ad04-11eb-3e03-e519d75db485
# ╠═c87833de-b07d-11eb-2683-dfcf2b15278b
# ╟─20dd8880-b07e-11eb-20a7-bbb30e51f245
# ╠═da8d1dea-ad60-11eb-103b-5f58806e2411
# ╟─a8c2f882-ad63-11eb-2de4-13103381aa12
# ╠═aff33810-ad63-11eb-0edd-1768200d1128
# ╠═b252965c-ad63-11eb-23e4-f9f5cc43ee59
# ╟─b25bc0f0-ad05-11eb-1c95-f3ea7f04b854
# ╠═272db25a-ad04-11eb-164d-41d5b3af6703
# ╠═02f84f86-adc6-11eb-1871-49f30725168a
# ╟─6e1bd31c-adca-11eb-0775-d5d8b147b298
# ╠═edf287cc-ad67-11eb-3cc7-e9413effcc37
# ╠═bc95dc3e-b089-11eb-0059-4f66bb3b5c8a
# ╟─80353a70-adca-11eb-1178-c36a81ecdc07
# ╠═6e22b768-ad7d-11eb-187e-b31ec73ca147
# ╟─eaa3b2d8-b089-11eb-17d2-652d01c8c942
# ╟─84ca0104-adca-11eb-3d4c-c989af9fe500
# ╠═102a88a6-ad7e-11eb-1068-e7bfaa23d3c4
# ╠═0ba4ec1a-b08a-11eb-13fe-2b508afe4a4f
# ╟─899c52e2-adca-11eb-04bc-997e90c43157
# ╠═374956a8-ad72-11eb-165d-e38a2d5dcdb3
# ╠═251c47d6-b08a-11eb-1b39-0d5215e145ec
# ╟─40790758-b08a-11eb-178a-39bb75de9f31
# ╠═6e45af12-b017-11eb-1be9-f17083d29716
# ╠═2aa696b8-b0d8-11eb-1872-df216d4e6a5c
