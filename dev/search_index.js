var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = NaNStatistics","category":"page"},{"location":"#NaNStatistics","page":"Home","title":"NaNStatistics","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [NaNStatistics]","category":"page"},{"location":"#NaNStatistics.histcounts!-Tuple{AbstractMatrix, AbstractVector, AbstractVector, AbstractRange, AbstractRange}","page":"Home","title":"NaNStatistics.histcounts!","text":"histcounts!(N, x, y, xedges::AbstractRange, yedges::AbstractRange)\n\nSimple 2D histogram; as histcounts, but in-place, adding counts to the first length(xedges)-1 columns and the first length(yedges)-1 rows of N elements of Array N.\n\nNote that counts will be added to N, not overwrite N, allowing you to produce cumulative histograms. However, this means you will have to initialize N with zeros before first use.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.histcounts!-Tuple{Array, AbstractArray, AbstractRange}","page":"Home","title":"NaNStatistics.histcounts!","text":"histcounts!(N, x, xedges::AbstractRange)\n\nSimple 1D histogram; as histcounts, but in-place, adding counts to the first length(xedges)-1 elements of Array N.\n\nNote that counts will be added to N, not overwrite N, allowing you to produce cumulative histograms. However, this means you will have to initialize N with zeros before first use.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.histcounts-Tuple{Any, AbstractRange}","page":"Home","title":"NaNStatistics.histcounts","text":"histcounts(x, xedges::AbstractRange; T=Int64)::Vector{T}\n\nA 1D histogram, ignoring NaNs: calculate the number of x values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nBy default, the counts are returned as Int64s, though this can be changed by specifying an output type with the optional keyword argument T.\n\nExamples\n\njulia> b = 10 * rand(100000);\n\njulia> histcounts(b, 0:1:10)\n10-element Vector{Int64}:\n 10054\n  9987\n  9851\n  9971\n  9832\n 10033\n 10250\n 10039\n  9950\n 10033\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.histcounts-Tuple{Any, Any, AbstractRange, AbstractRange}","page":"Home","title":"NaNStatistics.histcounts","text":"histcounts(x, y, xedges::AbstractRange, yedges::AbstractRange; T=Int64)::Matrix{T}\n\nA 2D histogram, ignoring NaNs: calculate the number of x, y pairs that fall into each square of a 2D grid of equally-spaced square bins with edges specified by xedges and yedges.\n\nThe resulting matrix N of counts is oriented with the lowest x and y bins in N[1,1], where the first (vertical / row) dimension of N corresponds to the y axis (with size(N,1) == length(yedges)-1) and the second (horizontal / column) dimension of N corresponds to the x axis (with size(N,2) == length(xedges)-1).\n\nBy default, the counts are returned as Int64s, though this can be changed by specifying an output type with the optional keyword argument T.\n\nExamples\n\njulia> x = y = 0.5:9.5;\n\njulia> xedges = yedges = 0:10;\n\njulia> N = histcounts(x,y,xedges,yedges)\n10×10 Matrix{Int64}:\n 1  0  0  0  0  0  0  0  0  0\n 0  1  0  0  0  0  0  0  0  0\n 0  0  1  0  0  0  0  0  0  0\n 0  0  0  1  0  0  0  0  0  0\n 0  0  0  0  1  0  0  0  0  0\n 0  0  0  0  0  1  0  0  0  0\n 0  0  0  0  0  0  1  0  0  0\n 0  0  0  0  0  0  0  1  0  0\n 0  0  0  0  0  0  0  0  1  0\n 0  0  0  0  0  0  0  0  0  1\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.inpctile-Union{Tuple{T}, Tuple{AbstractArray{T}, Number}} where T","page":"Home","title":"NaNStatistics.inpctile","text":"inpctile(A, p::Number; dims)\n\nReturn a boolean array that identifies which values of the iterable collection A fall within the central pth percentile, optionally along a dimension specified by dims.\n\nA valid percentile value must satisfy 0 <= p <= 100.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.movmean-Tuple{AbstractVector, Number}","page":"Home","title":"NaNStatistics.movmean","text":"movmean(x::AbstractVecOrMat, n::Number)\n\nSimple moving average of x in 1 or 2 dimensions, spanning n bins (or n*n in 2D), returning an array of the same size as x.\n\nFor the resulting moving average to be symmetric, n must be an odd integer; if n is not an odd integer, the first odd integer greater than n will be used instead.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanaad-Tuple{Any}","page":"Home","title":"NaNStatistics.nanaad","text":"nanaad(A; dims)\n\nMean (average) absolute deviation from the mean, ignoring NaNs, of an indexable collection A, optionally along a dimension specified by dims. Note that for a Normal distribution, sigma = 1.253 * AAD.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanadd!-Tuple{Array, AbstractArray}","page":"Home","title":"NaNStatistics.nanadd!","text":"nanadd!(A, B)\n\nAdd the non-NaN elements of B to A, treating NaNs as zeros\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanadd-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanadd","text":"nanadd(A, B)\n\nAdd the non-NaN elements of A and B, treating NaNs as zeros\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmean!-Tuple{AbstractMatrix, AbstractMatrix, AbstractVector, AbstractVector, AbstractVector, AbstractRange, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmean!","text":"nanbinmean!(MU, N, x, y, z, xedges::AbstractRange, yedges::AbstractRange)\n\nIgnoring NaNs, fill the matrix MU with the means and N with the counts of non-NAN z values that fall into a 2D grid of x and y bins defined by xedges and yedges. The independent variables x and y, as well as the dependent variable z, are all expected as 1D vectors (any subtype of AbstractVector).\n\nThe output matrices MU and N must be the same size, and must each have length(yedges)-1 rows and length(xedges)-1 columns.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmean!-Tuple{AbstractVecOrMat, AbstractVector, AbstractVecOrMat, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmean!","text":"nanbinmean!(MU, [N], x, y, xedges::AbstractRange)\n\nIgnoring NaNs, fill the array MU with the means (and optionally N with the counts) of non-NAN y values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nThe array of x data should given as a one-dimensional array (any subtype of AbstractVector) and y as either a 1-d or 2-d array (any subtype of AbstractVecOrMat).\n\nThe output arrays MU and N must be the same size, and must have the same number of columns as y; if y is a 2-d array (matrix), then each column of y will be treated as a separate variable.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmean-Tuple{AbstractVector, AbstractVecOrMat, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmean","text":"nanbinmean(x, y, xedges::AbstractRange)\n\nIgnoring NaNs, calculate the mean of y values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nThe array of x data should be given as a one-dimensional array (any subtype of AbstractVector) and y as either a 1-d or 2-d array (any subtype of AbstractVecOrMat). If y is a 2-d array, then each column of y will be treated as a separate variable.\n\nExamples\n\njulia> nanbinmean([1:100..., 1], [1:100..., NaN], 0:25:100)\n4-element Vector{Float64}:\n 13.0\n 38.0\n 63.0\n 87.5\n\njulia> nanbinmean(1:100, reshape(1:300,100,3), 0:25:100)\n4×3 Matrix{Float64}:\n 13.0  113.0  213.0\n 38.0  138.0  238.0\n 63.0  163.0  263.0\n 87.5  187.5  287.5\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmean-Tuple{AbstractVector, AbstractVecOrMat, AbstractVector, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmean","text":"nanbinmean(x, y, xedges::AbstractRange)\n\nIgnoring NaNs, calculate the weighted mean of y values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nThe array of x data should given as a one-dimensional array (any subtype of AbstractVector) and y as either a 1-d or 2-d array (any subtype of AbstractVecOrMat). If y is a 2-d array, then each column of y will be treated as a separate variable.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmean-Tuple{AbstractVector, AbstractVector, AbstractVector, AbstractRange, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmean","text":"nanbinmean(x, y, z, xedges, yedges)\n\nIgnoring NaNs, calculate the mean of z values that fall into a 2D grid of x and y bins with bin edges defined by xedges and yedges. The independent variables x and y, as well as the dependent variable z, are all expected as 1D vectors (any subtype of AbstractVector).\n\nExamples\n\njulia> x = y = z = 0.5:9.5;\n\njulia> xedges = yedges = 0:10;\n\njulia> nanbinmean(x,y,z,xedges,yedges)\n10×10 Matrix{Float64}:\n   0.5  NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN\n NaN      1.5  NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN\n NaN    NaN      2.5  NaN    NaN    NaN    NaN    NaN    NaN    NaN\n NaN    NaN    NaN      3.5  NaN    NaN    NaN    NaN    NaN    NaN\n NaN    NaN    NaN    NaN      4.5  NaN    NaN    NaN    NaN    NaN\n NaN    NaN    NaN    NaN    NaN      5.5  NaN    NaN    NaN    NaN\n NaN    NaN    NaN    NaN    NaN    NaN      6.5  NaN    NaN    NaN\n NaN    NaN    NaN    NaN    NaN    NaN    NaN      7.5  NaN    NaN\n NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN      8.5  NaN\n NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN    NaN      9.5\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmedian!-Tuple{AbstractVector, AbstractVector, AbstractVector, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmedian!","text":"nanbinmedian!(M, [N], x, y, xedges::AbstractRange)\n\nFill the array M with the medians (and optionally N with the counts) of non-NaN y values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nIf y is a 2-d array (matrix), each column will be treated as a separate variable\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanbinmedian-Tuple{AbstractVector, AbstractVecOrMat, AbstractRange}","page":"Home","title":"NaNStatistics.nanbinmedian","text":"nanbinmedian(x, y, xedges::AbstractRange)\n\nCalculate the median, ignoring NaNs, of y values that fall into each of length(xedges)-1 equally spaced bins along the x axis with bin edges specified by xedges.\n\nIf y is a 2-d array (matrix), each column will be treated as a separate variable\n\nExamples\n\njulia> nanbinmedian([1:100..., 1], [1:100..., NaN], 0:25:100)\n4-element Vector{Float64}:\n 12.5\n 37.0\n 62.0\n 87.0\n\njulia> nanbinmedian(1:100, reshape(1:300,100,3), 0:25:100)\n4×3 Matrix{Float64}:\n 12.5  112.5  212.5\n 37.0  137.0  237.0\n 62.0  162.0  262.0\n 87.0  187.0  287.0\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nancor-Tuple{AbstractMatrix}","page":"Home","title":"NaNStatistics.nancor","text":"nancor(X::AbstractMatrix; dims::Int=1)\n\nCompute the (Pearson's product-moment) correlation matrix of the matrix X, along dimension dims. As Statistics.cor, but ignoring NaNs.\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nancor-Tuple{AbstractVector, AbstractVector}","page":"Home","title":"NaNStatistics.nancor","text":"nancor(x::AbstractVector, y::AbstractVector)\n\nCompute the (Pearson's product-moment) correlation between the vectors x and y. As Statistics.cor, but ignoring NaNs.\n\nEquivalent to nancov(x,y) / (nanstd(x) * nanstd(y)).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nancov-Tuple{AbstractMatrix}","page":"Home","title":"NaNStatistics.nancov","text":"nancov(X::AbstractMatrix; dims::Int=1, corrected::Bool=true)\n\nCompute the covariance matrix of the matrix X, along dimension dims. As Statistics.cov, but ignoring NaNs.\n\nIf corrected is true as is the default, Bessel's correction will be applied, such that the sum is scaled by n-1 rather than n, where n = length(x).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nancov-Tuple{AbstractVector, AbstractVector}","page":"Home","title":"NaNStatistics.nancov","text":"nancov(x::AbstractVector, y::AbstractVector; corrected::Bool=true)\n\nCompute the covariance between the vectors x and y. As Statistics.cov, but ignoring NaNs.\n\nIf corrected is true as is the default, Bessel's correction will be applied, such that the sum is scaled by n-1 rather than n, where n = length(x).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanextrema-Tuple{Any}","page":"Home","title":"NaNStatistics.nanextrema","text":"nanextrema(A; dims)\n\nFind the extrema (maximum & minimum) of an indexable collection A, ignoring NaNs, optionally along a dimension specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmad-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmad","text":"nanmad(A; dims)\n\nMedian absolute deviation from the median, ignoring NaNs, of an indexable collection A, optionally along a dimension specified by dims. Note that for a Normal distribution, sigma = 1.4826 * MAD.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmask!-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanmask!","text":"nanmask!(mask, A)\n\nFill a Boolean mask of dimensions size(A) that is false wherever A is NaN\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmask-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmask","text":"nanmask(A)\n\nCreate a Boolean mask of dimensions size(A) that is false wherever A is NaN\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmax-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanmax","text":"nanmax(a,b)\n\nAs max(a,b), but if either argument is NaN, return the other one\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmaximum-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmaximum","text":"nanmaximum(A; dims)\n\nFind the largest non-NaN value of an indexable collection A, optionally along a dimension specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmean-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanmean","text":"nanmean(A, W; dims)\n\nIgnoring NaNs, calculate the weighted mean of an indexable collection A, optionally along dimensions specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmean-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmean","text":"nanmean(A; dims)\n\nCompute the mean of all non-NaN elements in A, optionally over dimensions specified by dims. As Statistics.mean, but ignoring NaNs.\n\nAs an alternative to dims, nanmean also supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> nanmean(A, dims=1)\n1×2 Matrix{Float64}:\n 2.0  3.0\n\njulia> nanmean(A, dims=2)\n2×1 Matrix{Float64}:\n 1.5\n 3.5\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmedian!-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmedian!","text":"nanmedian!(A; dims)\n\nCompute the median of all elements in A, optionally over dimensions specified by dims. As Statistics.median!, but ignoring NaNs and supporting the dims keyword.\n\nBe aware that, like Statistics.median!, this function modifies A, sorting or partially sorting the contents thereof (specifically, along the dimensions specified by dims, using either quicksort! or quickselect! around the median depending on the size of the array). Do not use this function if you do not want the contents of A to be rearranged.\n\nReduction over multiple dims is not officially supported, though does work (in generally suboptimal time) as long as the dimensions being reduced over are all contiguous.\n\nOptionally supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2 3; 4 5 6; 7 8 9]\n3×3 Matrix{Int64}:\n 1  2  3\n 4  5  6\n 7  8  9\n\n julia> nanmedian!(A, dims=1)\n 1×3 Matrix{Float64}:\n  4.0  5.0  6.0\n\n julia> nanmedian!(A, dims=2)\n 3×1 Matrix{Float64}:\n  2.0\n  5.0\n  8.0\n\n julia> nanmedian!(A)\n 5.0\n\n julia> A # Note that the array has been sorted\n3×3 Matrix{Int64}:\n 1  4  7\n 2  5  8\n 3  6  9\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmedian-Tuple{Any}","page":"Home","title":"NaNStatistics.nanmedian","text":"nanmedian(A; dims)\n\nCalculate the median, ignoring NaNs, of an indexable collection A, optionally along a dimension specified by dims.\n\nReduction over multiple dims is not officially supported, though does work (in generally suboptimal time) as long as the dimensions being reduced over are all contiguous.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanmin-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanmin","text":"nanmin(a,b)\n\nAs min(a,b), but if either argument is NaN, return the other one\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanminimum-Tuple{Any}","page":"Home","title":"NaNStatistics.nanminimum","text":"nanminimum(A; dims)\n\nAs minimum but ignoring NaNs: Find the smallest non-NaN value of an indexable collection A, optionally along a dimension specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanpctile!-Tuple{Any, Number}","page":"Home","title":"NaNStatistics.nanpctile!","text":"nanpctile!(A, p; dims)\n\nCompute the pth percentile (where p ∈ [0,100]) of all elements in A, optionally over dimensions specified by dims.\n\nAs StatsBase.percentile, but in-place, ignoring NaNs, and supporting the dims keyword.\n\nBe aware that, like Statistics.median!, this function modifies A, sorting or partially sorting the contents thereof (specifically, along the dimensions specified by dims, using either quicksort! or quickselect! depending on the size of the array). Do not use this function if you do not want the contents of A to be rearranged.\n\nReduction over multiple dims is not officially supported, though does work (in generally suboptimal time) as long as the dimensions being reduced over are all contiguous.\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2 3; 4 5 6; 7 8 9]\n3×3 Matrix{Int64}:\n 1  2  3\n 4  5  6\n 7  8  9\n\n julia> nanpctile!(A, 50, dims=1)\n 1×3 Matrix{Float64}:\n  4.0  5.0  6.0\n\n julia> nanpctile!(A, 50, dims=2)\n 3×1 Matrix{Float64}:\n  2.0\n  5.0\n  8.0\n\n julia> nanpctile!(A, 50)\n 5.0\n\n julia> A # Note that the array has been sorted\n3×3 Matrix{Int64}:\n 1  4  7\n 2  5  8\n 3  6  9\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanpctile-Tuple{Any, Number}","page":"Home","title":"NaNStatistics.nanpctile","text":"nanpctile(A, p; dims\n\nFind the pth percentile of an indexable collection A, ignoring NaNs, optionally along a dimension specified by dims.\n\nA valid percentile value must satisfy 0 <= p <= 100.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanquantile!-Tuple{Any, Number}","page":"Home","title":"NaNStatistics.nanquantile!","text":"nanquantile!(A, q; dims)\n\nCompute the qth quantile (where q ∈ [0,1]) of all elements in A, optionally over dimensions specified by dims.\n\nSimilar to StatsBase.quantile!, but ignoring NaNs, and supporting the dims keyword.\n\nBe aware that, like StatsBase.quantile!, this function modifies A, sorting or partially sorting the contents thereof (specifically, along the dimensions specified by dims, using either quicksort! or quickselect! depending on the size of the array). Do not use this function if you do not want the contents of A to be rearranged.\n\nReduction over multiple dims is not officially supported, though does work (in generally suboptimal time) as long as the dimensions being reduced over are all contiguous.\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2 3; 4 5 6; 7 8 9]\n3×3 Matrix{Int64}:\n 1  2  3\n 4  5  6\n 7  8  9\n\n julia> nanquantile!(A, 0.5, dims=1)\n 1×3 Matrix{Float64}:\n  4.0  5.0  6.0\n\n julia> nanquantile!(A, 0.5, dims=2)\n 3×1 Matrix{Float64}:\n  2.0\n  5.0\n  8.0\n\n julia> nanquantile!(A, 0.5)\n 5.0\n\n julia> A # Note that the array has been sorted\n3×3 Matrix{Int64}:\n 1  4  7\n 2  5  8\n 3  6  9\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanrange-Tuple{Any}","page":"Home","title":"NaNStatistics.nanrange","text":"nanrange(A; dims)\n\nCalculate the range (maximum - minimum) of an indexable collection A, ignoring NaNs, optionally along a dimension specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanstandardize!-Tuple{Array{<:AbstractFloat}}","page":"Home","title":"NaNStatistics.nanstandardize!","text":"nanstandardize!(A::Array{<:AbstractFloat}; dims)\n\nRescale A to unit variance and zero mean i.e. A .= (A .- nanmean(A)) ./ nanstd(A)\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanstandardize-Tuple{AbstractArray}","page":"Home","title":"NaNStatistics.nanstandardize","text":"nanstandardize(A; dims)\n\nRescale a copy of A to unit variance and zero mean i.e. (A .- nanmean(A)) ./ nanstd(A)\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanstd-Tuple{Any, Any}","page":"Home","title":"NaNStatistics.nanstd","text":"nanstd(A, W; dims)\n\nCalculate the weighted standard deviation, ignoring NaNs, of an indexable collection A, optionally along a dimension specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanstd-Tuple{Any}","page":"Home","title":"NaNStatistics.nanstd","text":"nanstd(A; dims=:, mean=nothing, corrected=true)\n\nCompute the variance of all non-NaN elements in A, optionally over dimensions specified by dims. As Statistics.var, but ignoring NaNs.\n\nA precomputed mean may optionally be provided, which results in a somewhat faster calculation. If corrected is true, then Bessel's correction is applied, such that the sum is divided by n-1 rather than n.\n\nAs an alternative to dims, nanstd also supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> nanstd(A, dims=1)\n1×2 Matrix{Float64}:\n 1.41421  1.41421\n\njulia> nanstd(A, dims=2)\n2×1 Matrix{Float64}:\n 0.7071067811865476\n 0.7071067811865476\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nansum-Tuple{Any}","page":"Home","title":"NaNStatistics.nansum","text":"nansum(A; dims)\n\nCalculate the sum of an indexable collection A, ignoring NaNs, optionally along dimensions specified by dims.\n\nAlso supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> nansum(A, dims=1)\n1×2 Matrix{Int64}:\n 4  6\n\njulia> nansum(A, dims=2)\n2×1 Matrix{Int64}:\n 3\n 7\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.nanvar-Tuple{Any}","page":"Home","title":"NaNStatistics.nanvar","text":"nanvar(A; dims=:, mean=nothing, corrected=true)\n\nCompute the variance of all non-NaN elements in A, optionally over dimensions specified by dims. As Statistics.var, but ignoring NaNs.\n\nA precomputed mean may optionally be provided, which results in a somewhat faster calculation. If corrected is true, then Bessel's correction is applied, such that the sum is divided by n-1 rather than n.\n\nAs an alternative to dims, nanvar also supports the dim keyword, which behaves identically to dims, but also drops any singleton dimensions that have been reduced over (as is the convention in some other languages).\n\nExamples\n\njulia> using NaNStatistics\n\njulia> A = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> nanvar(A, dims=1)\n1×2 Matrix{Float64}:\n 2.0  2.0\n\njulia> nanvar(A, dims=2)\n2×1 Matrix{Float64}:\n 0.5\n 0.5\n\n\n\n\n\n","category":"method"},{"location":"#NaNStatistics.zeronan!-Tuple{Array}","page":"Home","title":"NaNStatistics.zeronan!","text":"zeronan!(A)\n\nReplace all NaNs in A with zeros of the same type\n\n\n\n\n\n","category":"method"}]
}
