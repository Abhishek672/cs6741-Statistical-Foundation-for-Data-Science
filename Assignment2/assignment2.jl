### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 167eedba-7a47-11eb-1d7b-d98ce9e23e7e
begin
	using DataFrames
	using Distributions
	using Random
	
	using TableIO
	using Statistics
	using FreqTables
	using Dates
	using HTTP
	using JSON
	
	using Plots
end

# ╔═╡ fb02a7cc-7a4e-11eb-11b6-1f4ad15c9cfd
md"🌑**Problem 1:**"

# ╔═╡ 3f86b3fc-7a47-11eb-05b1-35017c6a2606
begin
	untidy_data=DataFrame()
	
	untidy_data[!,"religion"] = ["Agnostic","Atheist","Buddhist","Catholic","Don't know/refused","Evangelical Prot","Hindu","Hisorically Black Prot","Jehovah's Witness","Jewish"]
	untidy_data[!,"<\$10k"]    = [27,12,27,418,15,575,1,228,20,19]
	untidy_data[!,"\$10-20k"]  = [34,27,21,617,14,869,9,244,27,19]
	untidy_data[!,"\$20-30k"]  = [60,37,30,732,15,1064,7,236,24,25]
	untidy_data[!,"\$30-40k"]  = [81,52,34,670,11,982,9,238,24,25]
	untidy_data[!,"\$40-50k"]  = [76,35,33,638,10,881,11,197,21,30]
	untidy_data[!,"\$50-75k"]  = [137,70,58,1116,35,1486,34,223,30,95]
	untidy_data[!,"\$75-100k"] = [122,50,23,1150,40,1780,50,330,19,30]
	untidy_data[!,"\$100k-150k"]=[109,34,76,388,123,34,45,267,23,45]
	untidy_data[!,">\$150k"]=[84,23,45,213,34,31,12,151,13,15]
	untidy_data[!,"Don't know/refused"]=[96,10,15,201,10,230,5,112,10,8]
	
	untidy_data
end
	

# ╔═╡ 5e94544e-7a49-11eb-335b-3d0502273b0e
begin
tidy_data1=DataFrames.stack(untidy_data,2:11,variable_name=:income,value_name=:freq)
sort(tidy_data1,[:religion])
end

# ╔═╡ 7cf697e8-7a4f-11eb-0980-03b8b1f31c71
md"🌑**problem 2:**"

# ╔═╡ 0d37a49e-7b7e-11eb-30cf-cbbe064175b5
begin
	
	Random.seed!(2)
	
	#average temperatures for months of Jan Feb March April and May..
	temp=[18,24,30,35,40]
		
	#Different weather station IDs in Dataframe
	id_an=vcat(repeat(["MX17004"],6),repeat(["TX17008"],6),repeat(["NY17009"],8))
		
	#months in df.
	mn_an=[1,1,2,2,3,3,1,1,4,4,5,5,1,1,2,2,3,3,4,4]
		
	yr_an=vcat(repeat([2010],4),repeat([2011],2),repeat([2010],4),repeat([2011],2),repeat([2010],4),repeat([2009],4))
		
	el_an=repeat(["tmax","tmin"],10)
		
	df2=DataFrame()
	df2.id=id_an
	df2.year=yr_an
	df2.month=mn_an
	df2.element=el_an
		
	days1=["d"*string(i) for i in 1:31]
	
	#for each day fill 10 pairs (tmax,tmin) into the dataframe..
	#for each station the probability that it will not provide the (tmax,tmin) is 0.4..
	for i in 1:31
		
		temp_rec=[]
		
		for c in 1:10
			curr_month=mn_an[2*c]
			out=rand(1:5)
				
			is_date_invalid=(curr_month==2 && i==29) || (curr_month==2 && i==30) || (curr_month==2 && i==31) || (curr_month==4 && i==31)
			
	        #put missing value if (i)the day is invalid or (ii)The weather station does not provide the temperatures for that day..
			if(out<=2 || is_date_invalid )
				push!(temp_rec,missing)
				push!(temp_rec,missing)
			
	        #else take average temperature for the month and produce (i)tmax=avgtemp+err_max (ii)tmin=avgtemp-err_min 
	        #where err_max and err_min are uniformly distributed.
			else
				avg_temp=temp[curr_month]
				err_max=round(rand(Uniform(0,2));digits=2)
				err_min=round(rand(Uniform(-3,0));digits=2)
						
				push!(temp_rec,avg_temp+err_max)
				push!(temp_rec,avg_temp+err_min)
			end
		
		end
	
		df2[!,days1[i]]=temp_rec
	end
	
df2	
			
end

# ╔═╡ d4f90608-7a5c-11eb-0055-05d283dbc3bd
#Function takes "d23" and returns the date 23(Int64)
function ret_date(x)
	if length(x)==2
		return parse(Int64,last(x,1))
	else
		return parse(Int64,last(x,2))
	end
end

# ╔═╡ 8b60b1ec-7b99-11eb-0b46-bf85d4aa4f8c
function get_date(yy,mm,dd)
	
	if((mm==2 && dd>=29) || (mm==4 && dd==31))
		return missing
	else
		return Date.(yy,mm,dd)
	end
end
	

# ╔═╡ 79af05a2-7a5e-11eb-0bdf-0592f576d425
begin
	
	#collecting d1...d31 on a column named as :day
	inter_data=DataFrames.stack(df2,5:35,variable_name=:day,value_name=:temperature)
	
	#getting the numerical values for day.."di"--->i
	#removing the :day column
	select!(inter_data,Not(:day),:day=>(x->ret_date.(x))=>"day_number")
	
	#compressing the {:year,:month,:day_number} to a single column Date
	select!(inter_data,Not([:year,:month,:day_number]),[:year,:month,:day_number]=>((yy,mm,dd)->get_date.(yy,mm,dd))=>"Date")
	
end

# ╔═╡ ea4cda56-7b9d-11eb-0fd8-51e5c5ec3765
begin
	
	#removing the rows which will have missing value in their temperature column
	final_df=inter_data[completecases(inter_data),:]
	
	#while unstacking(element) then id+Date can be used as a key..
	
	tidy_df2=sort(DataFrames.unstack(final_df,[:id,:Date],:element,:temperature),[:id,:Date])
	
	tidy_df2

end

# ╔═╡ f311b35c-7aab-11eb-311b-81fa2d1678fd
md"🌑**Problem 3**"

# ╔═╡ fe59768c-7aab-11eb-129c-0d8fc1695a5c
begin
	untidy_data3=DataFrame(year=Int64[],artist=String[],time=String[],track=String[],date=Date[],week=Int64[],rank=Int64[])
	
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,02,26),1,87))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,03,04),2,82))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,03,11),3,72))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,03,18),4,77))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,03,25),5,87))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,04,1),6,94))
	push!(untidy_data3,(2000,"2Pac","4:22","Baby Don't Cry",Dates.Date(2000,04,8),7,99))
	
	push!(untidy_data3,(2000,"2Ge+her","3:15","The Hardest Part Of Breaking Up",Dates.Date(2000,09,2),1,91))
	push!(untidy_data3,(2000,"2Ge+her","3:15","The Hardest Part Of Breaking Up",Dates.Date(2000,09,9),2,87))
	push!(untidy_data3,(2000,"2Ge+her","3:15","The Hardest Part Of Breaking Up",Dates.Date(2000,09,16),3,92))
	
	push!(untidy_data3,(2000,"3 Doors Down","3:53","Kryptonite",Dates.Date(2000,04,8),1,81))
	push!(untidy_data3,(2000,"3 Doors Down","3:53","Kryptonite",Dates.Date(2000,04,15),2,70))
	push!(untidy_data3,(2000,"3 Doors Down","3:53","Kryptonite",Dates.Date(2000,04,22),3,68))
	push!(untidy_data3,(2000,"3 Doors Down","3:53","Kryptonite",Dates.Date(2000,04,29),4,67))
	push!(untidy_data3,(2000,"3 Doors Down","3:53","Kryptonite",Dates.Date(2000,05,6),5,66))
	
	
	
	untidy_data3
	
end

# ╔═╡ ef1630d6-7b08-11eb-36ae-492a9d56129b
begin
	select!(untidy_data3,Not(:year))
	select!(untidy_data3,Not(:week))
	
	gpb=groupby(untidy_data3,[:artist,:time,:track])
	uqdf=unique(combine(gpb,[:artist,:time,:track]))
	
	insertcols!(uqdf,1,:Index => 1:size(uqdf)[1],makeunique=true)
	
	jn_df=innerjoin(uqdf,untidy_data3,on=[:artist,:time,:track])
	select!(jn_df,[:Index,:date,:rank])
	
end

# ╔═╡ 0262fe66-7f24-11eb-063a-8f1df3a87fb2
uqdf

# ╔═╡ 109aa646-7f24-11eb-28bf-19e92e067b7b
jn_df

# ╔═╡ 1c015fec-7b15-11eb-177a-e36d6f23ef36
md"🌑**Problem 4**"

# ╔═╡ ea983c62-7b0f-11eb-130f-ffffe43b2f25
begin
	resp=HTTP.get("https://api.covid19india.org/data.json")
	s=String(resp.body)
	jobj=JSON.Parser.parse(s)
	
	
	v=jobj["cases_time_series"]
	df4=vcat(DataFrame.(v)...)
end

# ╔═╡ a5c99e00-7b2f-11eb-017c-9b85d3abf4f6
#converting string columns into integers
begin
	df4.dailyconfirmed=parse.(Int64,df4.dailyconfirmed)
	df4.dailydeceased=parse.(Int64,df4.dailydeceased)
	df4.dailyrecovered=parse.(Int64,df4.dailyrecovered)
	df4.totalconfirmed=parse.(Int64,df4.totalconfirmed)
	df4.totaldeceased=parse.(Int64,df4.totaldeceased)
	df4.totalrecovered=parse.(Int64,df4.totalrecovered)
end

# ╔═╡ 3b01f74e-7b33-11eb-0bbc-2b6fc3bd68b7
function string_to_date(s)
	dfmt=DateFormat("y-m-d")
	
	return Date(s,dfmt)
end

# ╔═╡ 44ef70b6-7b32-11eb-0d7f-ad7ef76590cf
begin
	select!(df4,:dateymd=>(x->string_to_date.(x))=>:Date,:dailyconfirmed,:dailydeceased,:dailyrecovered)
	
	#sort the dataframe according to date..
	sort!(df4,:Date)
	
	df4_1=select(df4,:Date=>(x->(Dates.month.(x)))=>:month,:Date=>(x->(Dates.year.(x)))=>:year,:dailyconfirmed,:dailydeceased,:dailyrecovered)
	
	
	grpb=groupby(df4_1,[:month,:year])
	df4_2=combine(grpb,:dailyconfirmed=>(x->sum(x))=>"total_confirmed"
	,:dailydeceased=>(x->sum(x))=>"total_deceased",
	:dailyrecovered=>(x->sum(x))=>"total_recovered")
	
	df4_2
end
	

# ╔═╡ 1f78b624-7b39-11eb-1cbd-ab30548e611b
md"🌑**Problem 5**"

# ╔═╡ 2c5aadca-7b39-11eb-2a70-4bb7990eaa5d
df4

# ╔═╡ 4cc9f876-7f31-11eb-2fc3-a1c569b6a547
function MA(x,ws)
	
	n = size(x)[1]
	y = []
	
	for i in 1:n
		
		if i<ws
			push!(y,missing)
		else
			push!(y,mean(x[i-ws+1:i]))
		end
	end
	
	return y
end
	

# ╔═╡ 1c511cbe-7f37-11eb-2fab-ef2c4c245eca
begin
	

	df7=transform(df4,:dailyconfirmed => (x->MA(x,7))=>"MAvg_dailyConfirmed",:dailydeceased => (x->MA(x,7))=>"MAvg_dailyDeceased",:dailyrecovered => (x->MA(x,7))=>"MAvg_dailyRecovered")
	
	
	sz=size(df7)[1]
	
	plot(1:sz,df7.MAvg_dailyConfirmed,xlabel="time",ylabel="confirmed",label="moving average")
	p1=plot!(1:sz,df7.dailyconfirmed,label="daily confirmed")
	
	savefig(p1,"/Users/abhisheknegi/Desktop/p1.png")
	
	plot(1:sz,df7.MAvg_dailyDeceased,xlabel="time",ylabel="deceased",label="moving average")
	p2=plot!(1:sz,df7.dailydeceased,label="daily deceased")
	savefig(p2,"/Users/abhisheknegi/Desktop/p2.png")
	
	
	plot(1:sz,df7.MAvg_dailyRecovered,xlabel="time",ylabel="recovered",label="moving average")
	p3=plot!(1:sz,df7.dailyrecovered,label="daily recovered")
	savefig(p3,"/Users/abhisheknegi/Desktop/p3.png")
	
	
end

# ╔═╡ 4191d76a-7f38-11eb-3f9e-adb1d71feb79
p1

# ╔═╡ 63f41d8e-7f38-11eb-16b2-791b0b0143fa
p2

# ╔═╡ 66f2f07a-7f38-11eb-32e6-b31b66b6cf91
p3

# ╔═╡ Cell order:
# ╠═167eedba-7a47-11eb-1d7b-d98ce9e23e7e
# ╟─fb02a7cc-7a4e-11eb-11b6-1f4ad15c9cfd
# ╠═3f86b3fc-7a47-11eb-05b1-35017c6a2606
# ╠═5e94544e-7a49-11eb-335b-3d0502273b0e
# ╟─7cf697e8-7a4f-11eb-0980-03b8b1f31c71
# ╠═0d37a49e-7b7e-11eb-30cf-cbbe064175b5
# ╠═d4f90608-7a5c-11eb-0055-05d283dbc3bd
# ╠═8b60b1ec-7b99-11eb-0b46-bf85d4aa4f8c
# ╠═79af05a2-7a5e-11eb-0bdf-0592f576d425
# ╠═ea4cda56-7b9d-11eb-0fd8-51e5c5ec3765
# ╟─f311b35c-7aab-11eb-311b-81fa2d1678fd
# ╠═fe59768c-7aab-11eb-129c-0d8fc1695a5c
# ╠═ef1630d6-7b08-11eb-36ae-492a9d56129b
# ╠═0262fe66-7f24-11eb-063a-8f1df3a87fb2
# ╠═109aa646-7f24-11eb-28bf-19e92e067b7b
# ╟─1c015fec-7b15-11eb-177a-e36d6f23ef36
# ╠═ea983c62-7b0f-11eb-130f-ffffe43b2f25
# ╠═a5c99e00-7b2f-11eb-017c-9b85d3abf4f6
# ╠═3b01f74e-7b33-11eb-0bbc-2b6fc3bd68b7
# ╠═44ef70b6-7b32-11eb-0d7f-ad7ef76590cf
# ╟─1f78b624-7b39-11eb-1cbd-ab30548e611b
# ╠═2c5aadca-7b39-11eb-2a70-4bb7990eaa5d
# ╠═4cc9f876-7f31-11eb-2fc3-a1c569b6a547
# ╠═1c511cbe-7f37-11eb-2fab-ef2c4c245eca
# ╠═4191d76a-7f38-11eb-3f9e-adb1d71feb79
# ╠═63f41d8e-7f38-11eb-16b2-791b0b0143fa
# ╠═66f2f07a-7f38-11eb-32e6-b31b66b6cf91
