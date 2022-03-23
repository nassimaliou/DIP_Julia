### A Pluto.jl notebook ###
# v0.14.9

using Markdown
using InteractiveUtils

# ╔═╡ 74995506-a535-11ec-0ab7-49367349f1ae
begin
	using ImageIO 			 # For image IO
	using Images 			 # For image processing
	using ImageShow 		 # For image display
	using ImageFiltering 	 # For image filtering
	using LocalFilters 		 # For morphological operations
	using ImageEdgeDetection # For Edge detection
	using Plots 			 # For visualizations
	using DSP 				 # For signal processing operations
	using FFTW 				 # Fourrier transform
	using Noise 			 # For noises
	using Statistics 		 # For statistical functions
	using PlutoUI 			 
end

# ╔═╡ e439788d-d9f9-4208-afd7-1367a8e89f4c
md"
# TP2 IMN: Aliousalah et Belogoumri
"

# ╔═╡ 9145e532-fb6a-499d-8cc0-ced51b8b8373
md"
## Question 1: Lire une image .jpeg en couleur
"

# ╔═╡ f8405e9d-57c8-4744-a9bc-780f72bec874
A = load("A.jpeg")

# ╔═╡ c0f544af-728c-4889-8610-81fc1e5d7497
md"
## Question 2: Apliquer à A un filtre passe-haut
"

# ╔═╡ cad84508-1061-447b-94f9-c17a91fba311
begin
	pass_pas = collect(reshape([1, 2, 1, 2, 4, 2, 1, 2, 1], 3, 3)) ./16
	id = collect(reshape([0, 0, 0, 0, 1, 0, 0, 0, 0], 3, 3)) 
	pass_haut = (id - pass_pas) .* 5
	A_pass_haut = imfilter(A, pass_haut)
end


# ╔═╡ 780be2a8-c6fb-4edc-a4f5-3942ee837a6d
md"
## Question 3: Appliquer à A un filtre accentuateur
"

# ╔═╡ a1021fff-6006-42f7-bda2-ad041848fd52
A_accentuateur = imfilter(A, pass_pas + pass_haut)

# ╔═╡ e5059df4-c345-4564-961b-56365e37d378
md"
## Question 4: Charger l'image `trui.png`
"

# ╔═╡ 98104195-9dde-45c2-98b6-5ce133bb3e4f
trui = load("trui.png")

# ╔═╡ 8bfb6faf-b3f7-4a9a-81b8-c0b2eddf2664
md"
## Question 5: Appliquer à trui le mask $W_x$ de Sobel
"

# ╔═╡ 8f89693f-b50b-46b1-b074-74bb21f90bbb
trui_wx_sobel = imfilter(trui, collect(reshape([-1, -2, -1, 0, 0, 0, 1, 2, 1], 3, 3)))

# ╔═╡ bf2e4e38-bbd4-49cb-921f-eff6cb74997a
md"
## Question 6: Appliquer à trui le mask $W_y$ de Sobel
"

# ╔═╡ efe5a25f-8180-45c6-af61-54eb7ea65f84
trui_wy_sobel = imfilter(trui, collect(reshape([-1, 0, 1, -2, 0, 2, -1, 0, 1], 3, 3)))

# ╔═╡ f6379684-6468-4407-b002-877f04a15b62
md"
## Question 7: Module du gradient
"

# ╔═╡ e15dc4e9-f133-4c22-8e9b-19ca27924a8d
begin
	g1, g2 = imgradients(trui, KernelFactors.sobel)
	sqrt.(g1 .^ 2 + g2 .^ 2) .* 2
end

# ╔═╡ 0a6143c4-4be7-4973-9f03-4fceb806a848
md"
## Question 8: Trouver la TF de l'image cameraman, afficher l'image du module et celle de l'argument
"

# ╔═╡ 24671313-cf92-4468-8915-f7a6ac7d3a02
md"
### Image du module
"

# ╔═╡ 43594a7c-9968-4ca0-8dad-26ea3cf735e9
begin
	cameraman = load("cameraman.jpg")
	cameraman_tf = fftshift(fft(Float64.(trui)))
	cameraman_tf_module = Gray.(abs.(cameraman_tf))
end


# ╔═╡ 7a4c0ca3-3586-4cd4-85e6-6f2f36c45687
md"
### Image de l'argument
"

# ╔═╡ a69da0b4-fbb3-49b2-94b7-5dc8ae6d7a55
cameraman_tf_arg = Gray.(angle.(cameraman_tf))

# ╔═╡ 615e95c6-7706-49e5-ac75-4dc9c3a463db
md"
## Question 9: Trouver la TF de l'image trui, afficher l'image du module et celle de l'argument
"

# ╔═╡ c737e947-f701-4907-816a-f92a9179c0be
md"
### Image du module
"

# ╔═╡ 27b2ef3f-fe07-45a6-bd10-ca95804219c6
begin
	trui_tf = fftshift(fft(Float64.(trui)))
	trui_tf_module = Gray.(abs.(trui_tf))
end

# ╔═╡ 8610b165-b5fd-48c7-b351-411c82d7782d
md"
### Image de l'argument
"

# ╔═╡ 553b204a-6b2d-4fa0-a769-15d83432694f
trui_tf_arg = Gray.(angle.(trui_tf))

# ╔═╡ b7719a78-b1d8-4440-a222-cc4a4b343cc8
md"
## Question 10: Construire une nouvelle image avec le module de cameraman et l'argument de trui
"

# ╔═╡ f5b06eb7-ceb8-4a5b-be74-ad10c829999a
begin
	r = abs.(fft(Float64.(cameraman)))
	θ = angle.(fft(Float64.(trui)))
	tf = r .* exp.(im .* θ)
	image3 = Gray.(real.(ifft(tf)))
end

# ╔═╡ Cell order:
# ╟─e439788d-d9f9-4208-afd7-1367a8e89f4c
# ╠═74995506-a535-11ec-0ab7-49367349f1ae
# ╟─9145e532-fb6a-499d-8cc0-ced51b8b8373
# ╟─f8405e9d-57c8-4744-a9bc-780f72bec874
# ╟─c0f544af-728c-4889-8610-81fc1e5d7497
# ╠═cad84508-1061-447b-94f9-c17a91fba311
# ╟─780be2a8-c6fb-4edc-a4f5-3942ee837a6d
# ╟─a1021fff-6006-42f7-bda2-ad041848fd52
# ╟─e5059df4-c345-4564-961b-56365e37d378
# ╟─98104195-9dde-45c2-98b6-5ce133bb3e4f
# ╟─8bfb6faf-b3f7-4a9a-81b8-c0b2eddf2664
# ╟─8f89693f-b50b-46b1-b074-74bb21f90bbb
# ╟─bf2e4e38-bbd4-49cb-921f-eff6cb74997a
# ╟─efe5a25f-8180-45c6-af61-54eb7ea65f84
# ╟─f6379684-6468-4407-b002-877f04a15b62
# ╟─e15dc4e9-f133-4c22-8e9b-19ca27924a8d
# ╟─0a6143c4-4be7-4973-9f03-4fceb806a848
# ╟─24671313-cf92-4468-8915-f7a6ac7d3a02
# ╟─43594a7c-9968-4ca0-8dad-26ea3cf735e9
# ╟─7a4c0ca3-3586-4cd4-85e6-6f2f36c45687
# ╠═a69da0b4-fbb3-49b2-94b7-5dc8ae6d7a55
# ╟─615e95c6-7706-49e5-ac75-4dc9c3a463db
# ╟─c737e947-f701-4907-816a-f92a9179c0be
# ╟─27b2ef3f-fe07-45a6-bd10-ca95804219c6
# ╟─8610b165-b5fd-48c7-b351-411c82d7782d
# ╟─553b204a-6b2d-4fa0-a769-15d83432694f
# ╟─b7719a78-b1d8-4440-a222-cc4a4b343cc8
# ╟─f5b06eb7-ceb8-4a5b-be74-ad10c829999a
