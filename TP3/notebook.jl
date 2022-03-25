### A Pluto.jl notebook ###
# v0.14.9

using Markdown
using InteractiveUtils

# ╔═╡ 3eccfb4e-a9e0-11ec-2bed-4b05fea39fa8
begin
	using ImageIO
	using Images
	using ImageShow
	using ImageView
	using ImageFiltering
	using Plots
	using DSP
	using FFTW
	using Noise
	using PlutoUI
	using Augmentor
end

# ╔═╡ 70299800-57ed-46a1-9973-84b06f69d53e
md"
# TP3 IMN : Aliousalah et Belgoumri
"

# ╔═╡ 0e4f322b-a69a-4f62-897b-985d482da8a2
md"
# Question 1 : Lire l’image cameraman
"

# ╔═╡ 8ede9d45-338f-4b47-a91e-0c3f6162df58
begin
	cameraman = load("../images/cameraman.jpg")
end

# ╔═╡ c2aac58f-5169-4928-a49e-e575c6171c7a
md"
# Question 2 : Tracer son histogramme
"

# ╔═╡ 23788878-0cea-453e-8a9b-015b2d394e20
begin
	histogram(vec(reinterpret(UInt8, cameraman)))
end

# ╔═╡ 449459cf-d1a1-483b-9736-4717c0c3abba
md"
# Question 3 : Translater l'histogramme à droite et à gauche
"

# ╔═╡ e3292e8d-4b1a-4537-993f-87fb78ac4a6d
begin
	trans_d = channelview(cameraman)
	trans_d[trans_d .< 0.89] = trans_d[trans_d .< 0.89] .+ 0.1
	histogram(vec(reinterpret(UInt8, trans_d)))
	
end

# ╔═╡ 0ff1fb22-4da0-4ae6-abb7-2e1a1042c794
begin
	trans_g = channelview(cameraman)
	trans_g[trans_g .> 0.1] = trans_g[trans_g .> 0.1] .- 0.1
	histogram(vec(reinterpret(UInt8, trans_g)))
	
end

# ╔═╡ bb152872-fe6e-4f6f-a524-a8de0dda5d2c
md"
# Question 4 : Appliquer l’égalisation de l'histogramme de thumb_pout
"

# ╔═╡ 75f7276e-d483-40e8-a38b-84b1ad2c4a49
begin
	thumb = load("../images/thumb_pout.png")
end

# ╔═╡ 8f8b3dad-7792-4d23-b587-cf51086dbea3
begin
	egal = adjust_histogram(thumb, Equalization(nbins = 256))
end

# ╔═╡ c7fd22dc-c53a-4a8c-9aba-9a6f1df5ff1e
histogram(vec(reinterpret(UInt8, egal)))

# ╔═╡ 38381c61-d564-4cfb-834d-ba1c2b9835f4
md"
# Question 5 : érosion et dilatation de cameraman
"

# ╔═╡ 0a2064bb-47a6-41c5-8fe3-18d89a81d29c
begin
	er = erode(cameraman)
end

# ╔═╡ 0a53862c-e55a-4149-84a4-d08f6114e17b
begin
	dil = dilate(cameraman)
end

# ╔═╡ c5186293-c30a-411e-931b-18bb393dfea9
md"
# Question 6 : Trouver le contour morphologique
"

# ╔═╡ 916a82ea-5373-4be3-80a3-06341d1de5d6
begin
	contour_morph = morphogradient(cameraman)
end

# ╔═╡ 52e614a8-0d07-4f71-a7a7-cecc984d6106
md"
## Question 7.a : Créer la TF 
"

# ╔═╡ c86e3f32-ac65-46a2-b0bf-17842d551c39
begin
	tf_filtre = (zeros((size(cameraman)[1], size(cameraman)[2])))
	
	U0 = 10
	V0 = 10
	
	tf_filtre[128 - U0 : 129 + U0, 128 - V0 : 129 + V0] .= 1
	Gray.(tf_filtre)
end

# ╔═╡ 959f9cb4-ca0c-4599-9d97-62924ec7b091
md"
## Question 7.b : Filtrer l'image 
"

# ╔═╡ 48fe4ea7-7d7c-44fa-941a-836ceaad3e13
begin
	tf_image = fftshift(fft(channelview(cameraman)))
	tf_result = tf_image .* tf_filtre
	Gray.(real.(ifft(ifftshift(tf_result))))
end

# ╔═╡ 8402bd54-06dd-48f2-8aaf-83230d8ed5b1
md"
# Question 8 : Avec un filtre passe haut
"

# ╔═╡ 6c5ed745-1441-4c39-8c82-000984f764a3
begin
	tf_pass_haut = 1 .- tf_filtre
	
	tf_result_2 = tf_image .* tf_pass_haut
	Gray.(real.(ifft(ifftshift(tf_result_2))))

end

# ╔═╡ Cell order:
# ╟─70299800-57ed-46a1-9973-84b06f69d53e
# ╠═3eccfb4e-a9e0-11ec-2bed-4b05fea39fa8
# ╟─0e4f322b-a69a-4f62-897b-985d482da8a2
# ╠═8ede9d45-338f-4b47-a91e-0c3f6162df58
# ╟─c2aac58f-5169-4928-a49e-e575c6171c7a
# ╠═23788878-0cea-453e-8a9b-015b2d394e20
# ╟─449459cf-d1a1-483b-9736-4717c0c3abba
# ╠═e3292e8d-4b1a-4537-993f-87fb78ac4a6d
# ╠═0ff1fb22-4da0-4ae6-abb7-2e1a1042c794
# ╟─bb152872-fe6e-4f6f-a524-a8de0dda5d2c
# ╠═75f7276e-d483-40e8-a38b-84b1ad2c4a49
# ╠═8f8b3dad-7792-4d23-b587-cf51086dbea3
# ╠═c7fd22dc-c53a-4a8c-9aba-9a6f1df5ff1e
# ╟─38381c61-d564-4cfb-834d-ba1c2b9835f4
# ╠═0a2064bb-47a6-41c5-8fe3-18d89a81d29c
# ╠═0a53862c-e55a-4149-84a4-d08f6114e17b
# ╟─c5186293-c30a-411e-931b-18bb393dfea9
# ╠═916a82ea-5373-4be3-80a3-06341d1de5d6
# ╟─52e614a8-0d07-4f71-a7a7-cecc984d6106
# ╠═c86e3f32-ac65-46a2-b0bf-17842d551c39
# ╟─959f9cb4-ca0c-4599-9d97-62924ec7b091
# ╠═48fe4ea7-7d7c-44fa-941a-836ceaad3e13
# ╟─8402bd54-06dd-48f2-8aaf-83230d8ed5b1
# ╠═6c5ed745-1441-4c39-8c82-000984f764a3
