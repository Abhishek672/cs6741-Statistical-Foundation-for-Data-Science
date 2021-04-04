### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3521cf7e-8ae3-11eb-3d8d-87a55562dd9f

begin
	using Plots
	plotly()
	using Distributions
	using QuadGK
	using Random
	using StatsBase
	using FreqTables
	using HTTP
	using JSON
	using DataFrames
	using Statistics
	using StatsPlots
end


# ╔═╡ fc4acf3c-8b11-11eb-0c0a-f78a77a5e3dd
begin
	using CSV
	using Dates
end

# ╔═╡ 653bca02-8ae8-11eb-17c5-5d7e015dffa8
md"**Question 1:**"

# ╔═╡ be261fec-8b2d-11eb-0dbe-5743c2a93f1a
#P and Q are probability values on a common domain d (here d is [-10:0.01:10])
function KLD(P,Q,d)
	sum=0
	
	for i in 1:length(d)
		
		if P[i]>0 && Q[i] >0
			
			sum+=P[i]*log(P[i]/Q[i])*0.01
		end
	end
	return sum
end
		

# ╔═╡ bd142a88-8ae5-11eb-006c-a5c207edac74
v = @bind v html"<input type=range min=1 max=5 step=1>"

# ╔═╡ 57f97f5e-8d47-11eb-1038-6f60a39527f7
begin
	D_n = Normal(0,1)
	T_n = TDist(v)
	dm = [x for x in -10:0.01:10]
	Q = [pdf(D_n,x) for x in dm]
	P = [pdf(T_n,x) for x in dm]
	KLD(P,Q,dm)
end

# ╔═╡ edb23198-8ae6-11eb-27e3-192fa2e177ea
begin
	plot(x->pdf(D_n,x),-10,10,label="Normal")
	plot!(x->pdf(T_n,x),-10,10,label="T(v="*string(v)*")")
end

# ╔═╡ 86b1126e-8ae8-11eb-0db2-87357c1ae6c9
md"**Question 2:**"

# ╔═╡ 833c246a-9483-11eb-35b7-21c196e9151b
md"**2.a Finding The Convolution and store in Cv_array**"

# ╔═╡ ee00975a-8b2e-11eb-0fb0-f7ca04687a5d
conv_f(F,D1,d,x) = sum(F[k] * pdf(D1,x - d[k])*0.01 for k in 1:length(d))

# ╔═╡ 99fac206-9564-11eb-0ab4-d1db1226b0f8
#To get convolutions..
begin
	U_d = Uniform(0,1)
	F = [pdf(U_d,x) for x in -10:0.01:10]

	d= [p for p in -10:0.01:10]
	Cv_array =[]
	for i in 2:10
		push!(Cv_array , [conv_f(F,U_d,d,x) for x in -10:0.01:10])
		F = Cv_array[i-1]
	end
end

# ╔═╡ 4e93250e-8b31-11eb-1594-d721982f7ba4
n_slider =@bind n html"<input type=range min=2 max=10 step=1>"

# ╔═╡ 759a32aa-8b31-11eb-00ec-6fe4c47714f9
plot(d,Cv_array[n-1],label="plot after convolution of n = "*string(n)*" distributions")

# ╔═╡ 6ec05f58-9483-11eb-2b63-351cfea0a42c
md"**2.b NOW FINDING THE KL DIVERGENCE BETWEEN 9 PLOTS AND CORRESPONDING NORMAL DISTRIBUTION**"

# ╔═╡ addb2f66-8b31-11eb-0862-935c7227cf4e
#Getting the KLD with the respective Normal Distribution...
begin
	KL_array=[]
	for i in 2:10
		
		#E[x] = xf(x)dx
		μ = sum(d.*Cv_array[i-1]*0.01)
		σ = sum(((d .- μ).^2).*Cv_array[i-1]*0.01)
	
		F_ND = [pdf(Normal(μ , σ),x) for x in d]
		push!(KL_array, KLD(Cv_array[i-1] , F_ND , d))
	end
end

# ╔═╡ aaa0d02a-8b32-11eb-088c-cff8d795d884
plot(2:10,KL_array,xlabel="n",ylabel="KLD")

# ╔═╡ 72757b4a-8b02-11eb-00a5-4ddfc2139f88
md"**Question 3:**"

# ╔═╡ 7a66d9a2-8b02-11eb-3fd6-cf0f306e64e0
#number of childrens for 1000 parents..
begin
	Random.seed!(1)
	data = []
	for i in 1:1000
		r = Random.rand(Uniform(0,1))
		if(r<0.3)
			push!(data , 0)
		elseif(0.3 <= r < 0.8)
			push!(data , 1)
		elseif(0.8 <= r < 0.95)
			push!(data , 2)
		elseif(0.95 <=r < 0.98)
			push!(data , 3)
		elseif(0.98 <= r <0.998)
			push!(data,4)
		else
			push!(data,5)
		
		end
	end
	FT = freqtable(data)
	xtick = names(FT)
end

# ╔═╡ 2237529e-8b33-11eb-3185-390f23da9fd1
begin
	plot(xtick ,FT,line=:stem, marker=:circle)
	scatter!([mean(data)],[0],label = "mean : "*string(mean(data)))
	scatter!([median(data)],[0],label = "median : "*string(median(data)))
end

# ╔═╡ 11bb81b8-9528-11eb-10dd-d5ea4c9890ef
median(data)

# ╔═╡ f26f1a9c-8b0f-11eb-220c-b3b6fdbb8b2e
md"**Question 4**"

# ╔═╡ 2691d174-8b11-11eb-2729-0d6c7901b7da
range_(x) = (maximum(x) - minimum(x))

# ╔═╡ f946b528-8b0f-11eb-324b-a7c4c3880dfb
begin
	Random.seed!(3)
	samples = [[rand(Uniform(0,1)) for _ in 1:30] for _ in 1:10000]
	range_s = range_.(samples)
end

# ╔═╡ db9c1e8e-9549-11eb-3c7d-75a246fde895
#takes the edges and weights of a fitted histogram and a statistic(mean median or mode)
#returns the (bin_number,count_bin) 
function Ret_bin_and_count(edges , weights ,stat)
	
	target_idx=0
	for idx in 1:length(edges)
		
		if edges[idx] < stat
			target_idx +=1
		elseif edges[idx] == stat
			break
		else
			target_idx-=1
			break
		end
	end
	target_idx +=1
	if target_idx == length(edges)
		target_idx -=1
	end
	
	bin_nu = edges[target_idx]
	y_val = weights[target_idx]
	
	return (bin_nu,y_val)
end

# ╔═╡ 96de2a78-9542-11eb-2c94-affc2622287f
begin
	h = fit(Histogram,range_s,nbins=100)
	edges = h.edges[1]
	weights = h.weights
	
	mean_d = mean(range_s)
	(x_mean , y_mean) = Ret_bin_and_count(edges,weights,mean_d)
	
	median_d = median(range_s)
	(x_med , y_med) = Ret_bin_and_count(edges,weights,median_d)
	
	mode_d = mode(range_s)
	(x_mode , y_mode) = Ret_bin_and_count(edges,weights,mode_d)
	
	mode_hist_idx = findmax(weights)[2]
	xh_mode = edges[mode_hist_idx] ; yh_mode = findmax(weights)[1]
	
	histogram(range_s,bins=100,c=:gray,legend=:topleft,label="")
	plot!([x_mean,x_mean],[0,y_mean],label="mean : "*string(mean_d),line=3)
	plot!([x_med,x_med],[0,y_med],label="median : "*string(median_d),line=3)
	plot!([x_mode,x_mode],[0,y_mode],label="mode_data : "*string(mode_d),line=3)
	plot!([xh_mode,xh_mode],[0,yh_mode],label="histogram mode : "*string(yh_mode),line=3)
	
end

# ╔═╡ f2ef9a8a-8b11-11eb-0a4a-578b32919fa3
md"**Question 6:**"

# ╔═╡ 7e96a916-8bf3-11eb-252f-cbcd31552801
begin
	df = CSV.read("/Users/abhisheknegi/Desktop/states.csv",DataFrame)
	
	#removing the state ="India" and the year 2021..
	cond1 = df.State .!= "India"
	cond2 = Dates.year.(df.Date) .== 2020
	
	new_df = df[cond1 .& cond2 ,:]
end

# ╔═╡ 21aeebe8-8bf4-11eb-0ba7-df56d50d6489
begin
	
	#replacing Date column by week number..
	select!(new_df , [:State,:Confirmed],:Date =>(x->Dates.week.(x))=>:Week)
	
	#grouping by state and week and getting the aggregate of confirmed cases.
	gb = groupby(new_df , [:State,:Week])
	
	df3 = combine(gb , :Confirmed => sum =>"weekly_confirmed")
	
	#unstacking by State Column..
	final_df = unstack(df3 , :State ,:weekly_confirmed)
end


# ╔═╡ dfb681c2-8c06-11eb-015d-a90672127227
State_names = names(final_df)[2:37]

# ╔═╡ b6baf972-8bfe-11eb-147f-9d9f61e66694
findpos(arr) = [indexin(arr[i], sort(arr))[1] for i in 1:length(arr)]

# ╔═╡ 8e7cbcce-8bfa-11eb-35d2-21cb5abb5d75
function covmat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cov(collect(sx), collect(sy))
	   end
   end
   return t
end;

# ╔═╡ 1ffea3c8-8bfc-11eb-0d7b-95dfe15b903f
function cormat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cor(collect(sx), collect(sy))
	   end
   end
   return t
   end;

# ╔═╡ a647c412-8bfe-11eb-1ff5-1d3b39c690fe
function Spearman_cormat(df)
   nc = ncol(df)
   t = zeros(nc, nc)
   for (i, c1) in enumerate(eachcol(df))
	   for (j, c2) in enumerate(eachcol(df))
		   sx, sy = skipmissings(c1, c2)
		   t[i, j] = cor(findpos(collect(sx)), findpos(collect(sy)))
	   end
   end
   return t
   end;

# ╔═╡ ba4e81e0-8bfd-11eb-2823-5368d94c4d62
begin
	cov_table = covmat(select(final_df,Not(:Week)))
	heatmap(State_names,State_names,cov_table,c=:thermal)
end

# ╔═╡ 3c9818f4-8c04-11eb-0d0a-cbb3e7c365ca
md"
>1.As for every 2 states we choose ,the trend in the data as week progresses is similar.The confirmed covid cases are increasing each week.

>2.For covariance it depends on the magnitude of data.the higher the number of cases the higher will be covariance.That's why we can see for state 11 (i.e. maharashtra) the covariance with every state is high ,and with itself is highest.
"

# ╔═╡ 1614308a-8c01-11eb-3b56-b971a01760e7
begin
	cor_table = cormat(select(final_df,Not(:Week)))
	heatmap(State_names,State_names , cor_table,c=:thermal)
end

# ╔═╡ 04edfb8e-8c05-11eb-0429-457eae22b5ca
md"
$(State_names[14])
>1.For state 14 .Himachal Pradesh the correlation with other states is less than 1.It is the case because it's relationship with other states is not perfectly linear.The increase in cases in HP is slow as compared to other states

"

# ╔═╡ 2c273732-8c01-11eb-18e5-c5c8f4ec31f7
begin
	sp_cor_table = Spearman_cormat(select(final_df,Not(:Week)))
	heatmap(State_names,State_names,sp_cor_table,c=:thermal)
end

# ╔═╡ 15686d00-8c05-11eb-1b2d-77dcaf3a314e
md"
>1.The number of cases for each week increase as year progresses for each state so rankwise they are all same.That's why we can see the spearmen correlation coefficient is 1 for every 2 states.

>2.For the 36th state there are missing values 
"

# ╔═╡ 2bb93ccc-8b3a-11eb-16f7-837f70235c35
md"**Question 7:**"


# ╔═╡ 5afcf3c4-8c10-11eb-2203-e13eb5c4f5f6
function OneSidedTail(x,D)
	pct = quantile(D,1.0-(x/100.0))
	return pct
end	

# ╔═╡ cc4b63c2-953f-11eb-093c-bf4ba0feb5be
x_slider = @bind x html"<input type=range min=1 max=99 step=1>"

# ╔═╡ 985e176c-8c7a-11eb-3e89-4363a48ac53b
function plot_curve(D)
	hp = OneSidedTail(x,D)
	plot(x->x , x->pdf(D,x) , -10,10,label="x ="*string(x),line=3)
	plot!(x->x , x->pdf(D,x), -10,hp,fill=(0,:orange),label=string(100-x)*"th percentile : "*string(round(hp;digits=3)))
	a = round(quadgk(x->pdf(D,x),-10,hp)[1] , digits=5)
	plot!(x->x , x->pdf(D,x) ,-10,hp ,label="area : "*string(a))
end

# ╔═╡ 469fe262-8c6f-11eb-1e11-d341675b2fed
plot_curve(Normal(0,1))

# ╔═╡ 6070ccea-8c71-11eb-2ba6-e1f29c861adb
plot_curve(TDist(10))

# ╔═╡ 70c863a8-9556-11eb-3dea-55a917acba40


# ╔═╡ 5f213406-8c7b-11eb-3d67-93a55e939a35
md"
>1 The xth percentile values are different for both distributions but the area under curve is same."

# ╔═╡ Cell order:
# ╠═3521cf7e-8ae3-11eb-3d8d-87a55562dd9f
# ╟─653bca02-8ae8-11eb-17c5-5d7e015dffa8
# ╠═be261fec-8b2d-11eb-0dbe-5743c2a93f1a
# ╠═bd142a88-8ae5-11eb-006c-a5c207edac74
# ╠═57f97f5e-8d47-11eb-1038-6f60a39527f7
# ╠═edb23198-8ae6-11eb-27e3-192fa2e177ea
# ╟─86b1126e-8ae8-11eb-0db2-87357c1ae6c9
# ╟─833c246a-9483-11eb-35b7-21c196e9151b
# ╠═ee00975a-8b2e-11eb-0fb0-f7ca04687a5d
# ╠═99fac206-9564-11eb-0ab4-d1db1226b0f8
# ╠═4e93250e-8b31-11eb-1594-d721982f7ba4
# ╠═759a32aa-8b31-11eb-00ec-6fe4c47714f9
# ╟─6ec05f58-9483-11eb-2b63-351cfea0a42c
# ╠═addb2f66-8b31-11eb-0862-935c7227cf4e
# ╠═aaa0d02a-8b32-11eb-088c-cff8d795d884
# ╟─72757b4a-8b02-11eb-00a5-4ddfc2139f88
# ╠═7a66d9a2-8b02-11eb-3fd6-cf0f306e64e0
# ╠═2237529e-8b33-11eb-3185-390f23da9fd1
# ╠═11bb81b8-9528-11eb-10dd-d5ea4c9890ef
# ╟─f26f1a9c-8b0f-11eb-220c-b3b6fdbb8b2e
# ╠═2691d174-8b11-11eb-2729-0d6c7901b7da
# ╠═f946b528-8b0f-11eb-324b-a7c4c3880dfb
# ╠═db9c1e8e-9549-11eb-3c7d-75a246fde895
# ╠═96de2a78-9542-11eb-2c94-affc2622287f
# ╟─f2ef9a8a-8b11-11eb-0a4a-578b32919fa3
# ╠═fc4acf3c-8b11-11eb-0c0a-f78a77a5e3dd
# ╠═7e96a916-8bf3-11eb-252f-cbcd31552801
# ╠═21aeebe8-8bf4-11eb-0ba7-df56d50d6489
# ╠═dfb681c2-8c06-11eb-015d-a90672127227
# ╠═b6baf972-8bfe-11eb-147f-9d9f61e66694
# ╠═8e7cbcce-8bfa-11eb-35d2-21cb5abb5d75
# ╠═1ffea3c8-8bfc-11eb-0d7b-95dfe15b903f
# ╠═a647c412-8bfe-11eb-1ff5-1d3b39c690fe
# ╠═ba4e81e0-8bfd-11eb-2823-5368d94c4d62
# ╠═3c9818f4-8c04-11eb-0d0a-cbb3e7c365ca
# ╠═1614308a-8c01-11eb-3b56-b971a01760e7
# ╟─04edfb8e-8c05-11eb-0429-457eae22b5ca
# ╠═2c273732-8c01-11eb-18e5-c5c8f4ec31f7
# ╟─15686d00-8c05-11eb-1b2d-77dcaf3a314e
# ╟─2bb93ccc-8b3a-11eb-16f7-837f70235c35
# ╠═5afcf3c4-8c10-11eb-2203-e13eb5c4f5f6
# ╠═cc4b63c2-953f-11eb-093c-bf4ba0feb5be
# ╠═985e176c-8c7a-11eb-3e89-4363a48ac53b
# ╠═469fe262-8c6f-11eb-1e11-d341675b2fed
# ╠═6070ccea-8c71-11eb-2ba6-e1f29c861adb
# ╠═70c863a8-9556-11eb-3dea-55a917acba40
# ╟─5f213406-8c7b-11eb-3d67-93a55e939a35
