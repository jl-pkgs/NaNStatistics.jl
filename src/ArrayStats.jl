## --- Transformations of arrays with NaNs

    """
    ```julia
    nanmask(A)
    ```
    Create a Boolean mask of dimensions `size(A)` that is false wherever `A` is `NaN`
    """
    nanmask(A) = nanmask!(Array{Bool}(undef,size(A)), A)
    export nanmask

    """
    ```julia
    nanmask!(mask, A)
    ```
    Fill a Boolean mask of dimensions `size(A)` that is false wherever `A` is `NaN`
    """
    function nanmask!(mask, A)
        @avx for i=1:length(A)
            mask[i] = !isnan(A[i])
        end
        return mask
    end
    # Special methods for arrays that cannot contain NaNs
    nanmask!(mask, A::AbstractArray{<:Integer}) = fill!(mask, true)
    nanmask!(mask, A::AbstractArray{<:Rational}) = fill!(mask, true)

    """
    ```julia
    zeronan!(A)
    ```
    Replace all `NaN`s in A with zeros of the same type
    """
    function zeronan!(A::Array)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            A[i] = ifelse(isnan(Aᵢ), 0, Aᵢ)
        end
        return A
    end
    export zeronan!


## --- Min & max ignoring NaNs

    """
    ```julia
    nanmax(a,b)
    ```
    As `max(a,b)`, but if either argument is `NaN`, return the other one
    """
    nanmax(a, b) = ifelse(a > b, a, b)
    nanmax(a, b::AbstractFloat) = ifelse(a==a, ifelse(b > a, b, a), b)
    nanmax(a::Vec{N,<:Integer}, b::Vec{N,<:Integer}) where N = ifelse(a > b, a, b)
    nanmax(a::Vec{N,<:AbstractFloat}, b::Vec{N,<:AbstractFloat}) where N = ifelse(isnan(a), b, ifelse(b > a, b, a))
    export nanmax

    """
    ```julia
    nanmin(a,b)
    ```
    As `min(a,b)`, but if either argument is `NaN`, return the other one
    """
    nanmin(a, b) = ifelse(a < b, a, b)
    nanmin(a, b::AbstractFloat) = ifelse(a==a, ifelse(b < a, b, a), b)
    nanmin(a::Vec{N,<:Integer}, b::Vec{N,<:Integer}) where N = ifelse(a < b, a, b)
    nanmin(a::Vec{N,<:AbstractFloat}, b::Vec{N,<:AbstractFloat}) where N = ifelse(isnan(a), b, ifelse(b < a, b, a))
    export nanmin

## --- Percentile statistics, excluding NaNs

    """
    ```julia
    pctile(A, p; dims)
    ```
    Find the `p`th percentile of an indexable collection `A`, ignoring NaNs,
    optionally along a dimension specified by `dims`.

    A valid percentile value must satisfy 0 <= `p` <= 100.
    """
    pctile(A, p; dims=:, dim=:) = __pctile(A, p, dims, dim)
    __pctile(A, p, dims, dim) = _pctile(A, p, dim) |> vec
    __pctile(A, p, dims, ::Colon) = _pctile(A, p, dims)
    function _pctile(A, p, ::Colon)
        t = nanmask(A)
        return any(t) ? percentile(A[t],p) : NaN
    end
    function _pctile(A, p, region)
        s = size(A)
        if region == 2
            t = Array{Bool}(undef, s[2])
            result = Array{float(eltype(A))}(undef, s[1], 1)
            for i=1:s[1]
                nanmask!(t, A[i,:])
                result[i] = any(t) ? percentile(A[i,t],p) : NaN
            end
        elseif region == 1
            t = Array{Bool}(undef, s[1])
            result = Array{float(eltype(A))}(undef, 1, s[2])
            for i=1:s[2]
                nanmask!(t, A[:,i])
                result[i] = any(t) ? percentile(A[t,i],p) : NaN
            end
        else
            result = _pctile(A, p, :)
        end
        return result
    end
    export pctile


    """
    ```julia
    inpctile(A, p::Number; dims)
    ```
    Return a boolean array that identifies which values of the iterable
    collection `A` fall within the central `p`th percentile, optionally along a
    dimension specified by `dims`.

    A valid percentile value must satisfy 0 <= `p` <= 100.
    """
    function inpctile(A, p)
        offset = (100 - p) / 2
        return _pctile(A, offset, :) .< A .< _pctile(A, 100-offset, :)
    end
    export inpctile

## --- Combine arrays containing NaNs

    """
    ```julia
    nanadd(A, B)
    ```
    Add the non-NaN elements of A and B, treating NaNs as zeros
    """
    function nanadd(A::AbstractArray, B::AbstractArray)
        result_type = promote_type(eltype(A), eltype(B))
        result = similar(A, result_type)
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            Bᵢ = B[i]
            result[i] = (Aᵢ * (Aᵢ==Aᵢ)) + (Bᵢ * (Bᵢ==Bᵢ))
        end
        return result
    end
    export nanadd

    """
    ```julia
    nanadd!(A, B)
    ```
    Add the non-NaN elements of `B` to `A`, treating NaNs as zeros
    """
    function nanadd!(A::Array, B::AbstractArray)
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            Bᵢ = B[i]
            A[i] = (Aᵢ * (Aᵢ==Aᵢ)) + (Bᵢ * (Bᵢ==Bᵢ))
        end
        return A
    end
    export nanadd!


## --- Summary statistics of arrays with NaNs

    """
    ```julia
    nansum(A; dims)
    ```
    Calculate the sum of an indexable collection `A`, ignoring NaNs, optionally
    along dimensions specified by `dims`.
    """
    nansum(A; dims=:, dim=:) = __nansum(A, dims, dim)
    __nansum(A, dims, dim) = _nansum(A, dim) |> vec
    __nansum(A, dims, ::Colon) = _nansum(A, dims)
    _nansum(A, region) = sum(A.*nanmask(A), dims=region)
    function _nansum(A,::Colon)
        m = zero(eltype(A))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            m += Aᵢ * (Aᵢ==Aᵢ)
        end
        return m
    end
    function _nansum(A::Array{<:Integer},::Colon)
        m = zero(eltype(A))
        @avx for i ∈ eachindex(A)
            m += A[i]
        end
        return m
    end
    function _nansum(A::AbstractArray{<:AbstractFloat},::Colon)
        T = eltype(A)
        m = zero(T)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            m += ifelse(isnan(Aᵢ), zero(T), Aᵢ)
        end
        return m
    end
    export nansum

    """
    ```julia
    nanminimum(A; dims)
    ```
    As `minimum` but ignoring `NaN`s: Find the smallest non-`NaN` value of an
    indexable collection `A`, optionally along a dimension specified by `dims`.
    """
    nanminimum(A; dims=:, dim=:) = __nanminimum(A, dims, dim)
    __nanminimum(A, dims, dim) = _nanminimum(A, dim) |> vec
    __nanminimum(A, dims, ::Colon) = _nanminimum(A, dims)
    _nanminimum(A, region) = reduce(nanmin, A, dims=region, init=float(eltype(A))(NaN))
    _nanminimum(A::AbstractArray{<:Number}, ::Colon) = vreduce(nanmin, A)
    export nanminimum


    """
    ```julia
    nanmaximum(A; dims)
    ```
    Find the largest non-NaN value of an indexable collection `A`, optionally
    along a dimension specified by `dims`.
    """
    nanmaximum(A; dims=:, dim=:) = __nanmaximum(A, dims, dim)
    __nanmaximum(A, dims, dim) = _nanmaximum(A, dim) |> vec
    __nanmaximum(A, dims, ::Colon) = _nanmaximum(A, dims)
    _nanmaximum(A, region) = reduce(nanmax, A, dims=region, init=float(eltype(A))(NaN))
    _nanmaximum(A::AbstractArray{<:Number}, ::Colon) = vreduce(nanmax, A)
    export nanmaximum


    """
    ```julia
    nanextrema(A; dims)
    ```
    Find the extrema (maximum & minimum) of an indexable collection `A`,
    ignoring NaNs, optionally along a dimension specified by `dims`.
    """
    nanextrema(A; dims=:) = _nanextrema(A, dims)
    _nanextrema(A, region) = collect(zip(_nanminimum(A, region), _nanmaximum(A, region)))
    _nanextrema(A, ::Colon) = (_nanminimum(A, :), _nanmaximum(A, :))
    export nanextrema


    """
    ```julia
    nanrange(A; dims)
    ```
    Calculate the range (maximum - minimum) of an indexable collection `A`,
    ignoring NaNs, optionally along a dimension specified by `dims`.
    """
    nanrange(A; dims=:) = _nanmaximum(A, dims) - _nanminimum(A, dims)
    export nanrange


    """
    ```julia
    nanmean(A, [W]; dims)
    ```
    Ignoring NaNs, calculate the mean (optionally weighted) of an indexable
    collection `A`, optionally along dimensions specified by `dims`.
    """
    nanmean(A; dims=:, dim=:) = __nanmean(A, dims, dim)
    __nanmean(A, dims, dim) = _nanmean(A, dim) |> vec
    __nanmean(A, dims, ::Colon) = _nanmean(A, dims)
    function _nanmean(A, region)
        mask = nanmask(A)
        return sum(A.*mask, dims=region) ./ sum(mask, dims=region)
    end
    # Fallback method for non-Arrays
    function _nanmean(A, ::Colon)
        n = 0
        m = zero(eltype(A))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            t = Aᵢ == Aᵢ
            n += t
            m += Aᵢ * t
        end
        return m / n
    end
    # Can't have NaNs if array is all Integers
    function _nanmean(A::Array{<:Integer}, ::Colon)
        m = zero(eltype(A))
        @avx for i ∈ eachindex(A)
            m += A[i]
        end
        return m / length(A)
    end
    # Optimized AVX version for floats
    function _nanmean(A::AbstractArray{<:AbstractFloat}, ::Colon)
        n = 0
        T = eltype(A)
        m = zero(T)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            t = isnan(Aᵢ)
            n += !t
            m += ifelse(t, zero(T), Aᵢ)
        end
        return m / n
    end

    nanmean(A, W; dims=:, dim=:) = __nanmean(A, W, dims, dim)
    __nanmean(A, W, dims, dim) = _nanmean(A, W, dim) |> vec
    __nanmean(A, W, dims, ::Colon) = _nanmean(A, W, dims)
    function _nanmean(A, W, region)
        mask = nanmask(A)
        return sum(A.*W.*mask, dims=region) ./ sum(W.*mask, dims=region)
    end
    # Fallback method for non-Arrays
    function _nanmean(A, W, ::Colon)
        n = zero(eltype(W))
        m = zero(promote_type(eltype(W), eltype(A)))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            Wᵢ = W[i]
            t = Aᵢ == Aᵢ
            n += Wᵢ * t
            m += Wᵢ * Aᵢ * t
        end
        return m / n
    end
    # Can't have NaNs if array is all Integers
    function _nanmean(A::Array{<:Integer}, W, ::Colon)
        n = zero(eltype(W))
        m = zero(promote_type(eltype(W), eltype(A)))
        @avx for i ∈ eachindex(A)
            Wᵢ = W[i]
            n += Wᵢ
            m += Wᵢ * A[i]
        end
        return m / n
    end
    # Optimized AVX method for floats
    function _nanmean(A::AbstractArray{<:AbstractFloat}, W, ::Colon)
        T1 = eltype(W)
        T2 = promote_type(eltype(W), eltype(A))
        n = zero(T1)
        m = zero(T2)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            Wᵢ = W[i]
            t = isnan(Aᵢ)
            n += ifelse(t, zero(T1), Wᵢ)
            m += ifelse(t, zero(T2), Wᵢ * Aᵢ)
        end
        return m / n
    end


    """
    ```julia
    nanmean(x, y, [w], xmin::Number, xmax::Number, nbins::Integer)
    ```
    Ignoring NaNs, calculate the mean (optionally weighted) of `y` values that
    fall into each of `nbins` equally spaced `x` bins between `xmin` and `xmax`,
    aligned with bin edges as `xmin`:(`xmax`-`xmin`)/`nbins`:`xmax`

    The array of `x` data should given as a one-dimensional array (any subtype
    of AbstractVector) and `y` as either a 1-d or 2-d array (any subtype of
    AbstractVecOrMat). If `y` is a 2-d array, then each column of `y` will be
    treated as a separate variable.
    """
    function nanmean(x::AbstractVector, y::AbstractVecOrMat, xmin::Number, xmax::Number, nbins::Integer)
        N = Array{Int}(undef, nbins, size(y)[2:end]...)
        MU = Array{float(eltype(y))}(undef, nbins, size(y)[2:end]...)
        return nanmean!(MU, N, x, y, xmin, xmax, nbins)
    end
    function nanmean(x::AbstractVector, y::AbstractVecOrMat, w::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        W = Array{float(eltype(y))}(undef, nbins, size(y)[2:end]...)
        MU = Array{float(eltype(y))}(undef, nbins, size(y)[2:end]...)
        return nanmean!(MU, W, x, y, w, xmin, xmax, nbins)
    end
    export nanmean


    """
    ```julia
    nanmean!(MU, [N], x, y, [w], xmin::Number, xmax::Number, nbins::Integer)
    ```
    Ignoring NaNs, fill the array `MU` with the means (and optionally `N` with
    the counts) of non-NAN `y` values that fall into each of `nbins` equally
    spaced `x` bins between `xmin` and `xmax`, aligned with bin edges as
    `xmin`:(`xmax`-`xmin`)/`nbins`:`xmax`

    If an optional array of weights [`w`] is specified, then `N` is required, and
    will be filled with the sum of weights for each bin.

    The array of `x` data should given as a one-dimensional array (any subtype
    of AbstractVector) and `y` as either a 1-d or 2-d array (any subtype of
    AbstractVecOrMat).

    The output arrays `MU` and `N` must be the same size, and must have the same
    number of columns as `y`; if `y` is a 2-d array (matrix), then each column of
    `y` will be treated as a separate variable.
    """
    function nanmean!(MU::AbstractVecOrMat, x::AbstractVector, y::AbstractVecOrMat, xmin::Number, xmax::Number, nbins::Integer)
        N = Array{Int}(undef, size(MU))
        return nanmean!(MU, N, x, y, xmin, xmax, nbins)
    end
    # As above, but also return an array of counts, N; y, N, and MU as 1D vectors
    function nanmean!(MU::AbstractVector, N::AbstractVector, x::AbstractVector, y::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        # Calculate bin index from x value
        scalefactor = nbins / (xmax - xmin)

        # Calculate the means for each bin, ignoring NaNs
        fill!(N, 0)
        fill!(MU, 0) # Fill the output array with zeros to start
        @inbounds for i = 1:length(x)
            bin_index_float = (x[i] - xmin) * scalefactor
            if (0 < bin_index_float < nbins) && !isnan(y[i])
                bin_index = ceil(Int, bin_index_float)
                N[bin_index] += 1
                MU[bin_index] += y[i]
            end
        end
        MU ./= N # Divide by N to calculate means. Empty bin = 0/0 = NaN

        return MU
    end
    # In-place binning; as above but with y, N, MU as 2D matrices instead of 1D vectors
    function nanmean!(MU::AbstractMatrix, N::AbstractMatrix, x::AbstractVector, y::AbstractMatrix, xmin::Number, xmax::Number, nbins::Integer)
        # Calculate bin index from x value
        scalefactor = nbins / (xmax - xmin)

        # Calculate the means for each bin, ignoring NaNs
        fill!(N, 0)
        fill!(MU, 0) # Fill the output array with zeros to start
        @inbounds for i = 1:length(x)
            bin_index_float = (x[i] - xmin) * scalefactor
            if (0 < bin_index_float < nbins)
                bin_index = ceil(Int, bin_index_float)
                for j = 1:size(y,2)
                    if !isnan(y[i,j])
                        N[bin_index,j] += 1
                        MU[bin_index,j] += y[i,j]
                    end
                end
            end
        end
        MU ./= N # Divide by N to calculate means. Empty bin = 0/0 = NaN

        return MU
    end
    # In-place binning with weights; y, W, MU as 1D vectors
    function nanmean!(MU::AbstractVector, W::AbstractVector, x::AbstractVector, y::AbstractVector, w::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        # Calculate bin index from x value
        scalefactor = nbins / (xmax - xmin)

        # Calculate the means for each bin, ignoring NaNs
        fill!(W, 0)
        fill!(MU, 0) # Fill the output array with zeros to start
        @inbounds for i = 1:length(x)
            bin_index_float = (x[i] - xmin) * scalefactor
            if (0 < bin_index_float < nbins) && !isnan(y[i])
                bin_index = ceil(Int, bin_index_float)
                W[bin_index] += w[i]
                MU[bin_index] += y[i]*w[i]
            end
        end
        MU ./= W # Divide by sum of weights to calculate means. Empty bin = 0/0 = NaN

        return MU
    end
    # In-place binning with weights; y, W, MU as 2D matrices
    function nanmean!(MU::AbstractMatrix, W::AbstractMatrix, x::AbstractVector, y::AbstractMatrix, w::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        # Calculate bin index from x value
        scalefactor = nbins / (xmax - xmin)

        # Calculate the means for each bin, ignoring NaNs
        fill!(W, 0)
        fill!(MU, 0) # Fill the output array with zeros to start
        @inbounds for i = 1:length(x)
            bin_index_float = (x[i] - xmin) * scalefactor
            if (0 < bin_index_float < nbins)
                bin_index = ceil(Int, bin_index_float)
                for j = 1:size(y,2)
                    if !isnan(y[i,j])
                        W[bin_index,j] += w[i]
                        MU[bin_index,j] += y[i,j]*w[i]
                    end
                end
            end
        end
        MU ./= W # Divide by sum of weights to calculate means. Empty bin = 0/0 = NaN

        return MU
    end
    export nanmean!


    """
    ```julia
    nanstd(A, [W]; dims)
    ```
    Calculate the standard deviation (optionaly weighted), ignoring NaNs, of an
    indexable collection `A`, optionally along a dimension specified by `dims`.
    """
    nanstd(A; dims=:, dim=:) = __nanstd(A, dims, dim)
    __nanstd(A, dims, dim) = _nanstd(A, dim) |> vec
    __nanstd(A, dims, ::Colon) = _nanstd(A, dims)
    function _nanstd(A, region)
        mask = nanmask(A)
        N = sum(mask, dims=region)
        s = sum(A.*mask, dims=region)./N
        d = A .- s # Subtract mean, using broadcasting
        @avx for i ∈ eachindex(d)
            dᵢ = d[i]
            d[i] = ifelse(mask[i], dᵢ * dᵢ, 0)
        end
        s .= sum(d, dims=region)
        @avx for i ∈ eachindex(s)
            s[i] = sqrt( s[i] / max((N[i] - 1), 0) )
        end
        return s
    end
    function _nanstd(A, ::Colon)
        n = 0
        m = zero(eltype(A))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            t = Aᵢ == Aᵢ # False for NaNs
            n += t
            m += Aᵢ * t
        end
        mu = m / n
        s = zero(typeof(mu))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            d = (Aᵢ - mu) * (Aᵢ == Aᵢ)# zero if Aᵢ is NaN
            s += d * d
        end
        return sqrt(s / max((n-1), 0))
    end
    function _nanstd(A::AbstractArray{<:AbstractFloat}, ::Colon)
        n = 0
        T = eltype(A)
        m = zero(T)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            t = isnan(Aᵢ)
            n += !t
            m += ifelse(t, zero(T), Aᵢ)
        end
        mu = m / n
        s = zero(typeof(mu))
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            d = ifelse(isnan(Aᵢ), 0, Aᵢ - mu)
            s += d * d
        end
        return sqrt(s / max((n-1), 0))
    end

    nanstd(A, W; dims=:, dim=:) = __nanstd(A, W, dims, dim)
    __nanstd(A, W, dims, dim) = _nanstd(A, W, dim) |> vec
    __nanstd(A, W, dims, ::Colon) = _nanstd(A, W, dims)
    function _nanstd(A, W, region)
        mask = nanmask(A)
        n = sum(mask, dims=region)
        w = sum(W.*mask, dims=region)
        s = sum(A.*W.*mask, dims=region) ./ w
        d = A .- s # Subtract mean, using broadcasting
        @avx for i ∈ eachindex(d)
            dᵢ = d[i]
            d[i] = (dᵢ * dᵢ * W[i]) * mask[i]
        end
        s .= sum(d, dims=region)
        @avx for i ∈ eachindex(s)
            s[i] = sqrt((s[i] * n[i]) / (w[i] * (n[i] - 1)))
        end
        return s
    end
    function _nanstd(A, W, ::Colon)
        n = 0
        w = zero(eltype(W))
        m = zero(promote_type(eltype(W), eltype(A)))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            Wᵢ = W[i]
            t = Aᵢ == Aᵢ
            n += t
            w += Wᵢ * t
            m += Wᵢ * Aᵢ * t
        end
        mu = m / w
        s = zero(typeof(mu))
        @inbounds @simd for i ∈ eachindex(A)
            Aᵢ = A[i]
            d = Aᵢ - mu
            s += (d * d * W[i]) * (Aᵢ == Aᵢ) # Zero if Aᵢ is NaN
        end
        return sqrt(s / w * n / (n-1))
    end
    function _nanstd(A::AbstractArray{<:AbstractFloat}, W, ::Colon)
        n = 0
        Tw = eltype(W)
        Tm = promote_type(eltype(W), eltype(A))
        w = zero(Tw)
        m = zero(Tm)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            Wᵢ = W[i]
            t = isnan(Aᵢ)
            n += !t
            w += ifelse(t, zero(Tw), Wᵢ)
            m += ifelse(t, zero(Tm), Wᵢ * Aᵢ)
        end
        mu = m / w
        Tmu = typeof(mu)
        s = zero(Tmu)
        @avx for i ∈ eachindex(A)
            Aᵢ = A[i]
            d = Aᵢ - mu
            s += ifelse(isnan(Aᵢ), zero(Tmu), d * d * W[i])
        end
        return sqrt(s / w * n / (n-1))
    end
    export nanstd


    """
    ```julia
    nanmedian(A; dims)
    ```
    Calculate the median, ignoring NaNs, of an indexable collection `A`,
    optionally along a dimension specified by `dims`.
    """
    nanmedian(A; dims=:, dim=:) = _nanmedian(A, dims, dim)
    _nanmedian(A, region, ::Colon) = _nanmedian(A, region)
    _nanmedian(A, ::Colon, region) = _nanmedian(A, region) |> vec
    _nanmedian(A, ::Colon, ::Colon) = _nanmedian(A, :)
    function _nanmedian(A, ::Colon)
        t = nanmask(A)
        return any(t) ? median(A[t]) : float(eltype(A))(NaN)
    end
    function _nanmedian(A, region)
        s = size(A)
        if region == 2
            t = Array{Bool}(undef, s[2])
            result = Array{float(eltype(A))}(undef, s[1], 1)
            for i=1:s[1]
                nanmask!(t, A[i,:])
                result[i] = any(t) ? median(A[i,t]) : float(eltype(A))(NaN)
            end
        elseif region == 1
            t = Array{Bool}(undef, s[1])
            result = Array{float(eltype(A))}(undef, 1, s[2])
            for i=1:s[2]
                nanmask!(t, A[:,i])
                result[i] = any(t) ? median(A[t,i]) : float(eltype(A))(NaN)
            end
        else
            result = _nanmedian(A, :)
        end
        return result
    end

    """
    ```julia
    nanmedian(x::AbstractVector, y::AbstractVecOrMat, xmin::Number, xmax::Number, nbins::Integer)
    ```
    Calculate the median, ignoring NaNs, of y values that fall into each of `nbins`
    equally spaced `x` bins between `xmin` and `xmax`, aligned with bin edges as
    `xmin`:(`xmax`-`xmin`)/`nbins`:`xmax`

    If `y` is a 2-d array (matrix), each column will be treated as a separate variable
    """
    function nanmedian(x::AbstractVector, y::AbstractVecOrMat, xmin::Number, xmax::Number, nbins::Integer)
        M = Array{float(eltype(y))}(undef, nbins, size(y)[2:end]...)
        return nanmedian!(M, x, y, xmin, xmax, nbins)
    end
    export nanmedian

    """
    ```julia
    nanmedian!(M::AbstractVecOrMat, x::AbstractVector, y::AbstractVecOrMat, xmin::Number, xmax::Number, nbins::Integer)
    ```
    Fill the array `M` with the medians of non-NaN `y` values that fall into
    each of `nbins` equally spaced `x` bins between `xmin` and `xmax`, aligned
    with bin edges as `xmin`:(`xmax`-`xmin`)/`nbins`:`xmax`

    If `y` is a 2-d array (matrix), each column will be treated as a separate variable
    """
    function nanmedian!(M::AbstractVector, x::AbstractVector, y::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        binedges = range(xmin, xmax, length=nbins+1)
        t = Array{Bool}(undef, length(x))
        for i = 1:nbins
            t .= (x.>binedges[i]) .& (x.<=binedges[i+1]) .& (y.==y)
            M[i] = any(t) ? median(y[t]) : float(eltype(A))(NaN)
        end
        return M
    end
    function nanmedian!(M::AbstractMatrix, x::AbstractVector, y::AbstractMatrix, xmin::Number, xmax::Number, nbins::Integer)
        binedges = range(xmin, xmax, length=nbins+1)
        t = Array{Bool}(undef, length(x))
        tj = Array{Bool}(undef, length(x))
        for i = 1:nbins
            t .= (x.>binedges[i]) .& (x.<=binedges[i+1])
            for j = 1:size(y,2)
                tj .= t .& .!isnan.(y[:,j])
                M[i,j] = any(tj) ? median(y[tj,j]) : float(eltype(A))(NaN)
            end
        end
        return M
    end
    function nanmedian!(M::AbstractVector, N::AbstractVector, x::AbstractVector, y::AbstractVector, xmin::Number, xmax::Number, nbins::Integer)
        binedges = range(xmin, xmax, length=nbins+1)
        t = Array{Bool}(undef, length(x))
        for i = 1:nbins
            t .= (x.>binedges[i]) .& (x.<=binedges[i+1]) .& (y.==y)
            M[i] = any(t) ? median(y[t]) : float(eltype(A))(NaN)
            N[i] = count(t)
        end
        return M
    end
    function nanmedian!(M::AbstractMatrix, N::AbstractMatrix, x::AbstractVector, y::AbstractMatrix, xmin::Number, xmax::Number, nbins::Integer)
        binedges = range(xmin, xmax, length=nbins+1)
        t = Array{Bool}(undef, length(x))
        tj = Array{Bool}(undef, length(x))
        for i = 1:nbins
            t .= (x.>binedges[i]) .& (x.<=binedges[i+1])
            for j = 1:size(y,2)
                tj .= t .& .!isnan.(y[:,j])
                M[i,j] = any(tj) ? median(y[tj,j]) : float(eltype(A))(NaN)
                N[i,j] = count(tj)
            end
        end
        return M
    end
    export nanmedian!


    """
    ```julia
    nanmad(A; dims)
    ```
    Median absolute deviation from the median, ignoring NaNs, of an indexable
    collection `A`, optionally along a dimension specified by `dims`.
    Note that for a Normal distribution, sigma = 1.4826 * MAD
    """
    function nanmad(A; dims=:)
        s = size(A)
        if dims == 2
            t = Array{Bool}(undef, s[2])
            result = Array{float(eltype(A))}(undef, s[1], 1)
            for i=1:s[1]
                nanmask!(t, A[i,:])
                result[i] = any(t) ? median(abs.( A[i,t] .- median(A[i,t]) )) : float(eltype(A))(NaN)
            end
        elseif dims == 1
            t = Array{Bool}(undef, s[1])
            result = Array{float(eltype(A))}(undef, 1, s[2])
            for i=1:s[2]
                nanmask!(t, A[:,i])
                result[i] = any(t) ? median(abs.( A[t,i] .- median(A[t,i]) )) : float(eltype(A))(NaN)
            end
        else
            t = nanmask(A)
            result = any(t) ? median(abs.( A[t] .- median(A[t]) )) : float(eltype(A))(NaN)
        end
        return result
    end
    export nanmad


    """
    ```julia
    nanaad(A; dims)
    ```
    Mean (average) absolute deviation from the mean, ignoring NaNs, of an
    indexable collection `A`, optionally along a dimension specified by `dims`.
    Note that for a Normal distribution, sigma = 1.253 * AAD
    """
    nanaad(A; dims=:) = _nanmean(abs.(A .- _nanmean(A, dims)), dims)
    export nanaad


## -- moving average

    """
    ```julia
    movmean(x::AbstractVecOrMat, n::Number)
    ```
    Simple moving average of `x` in 1 or 2 dimensions, spanning `n` bins (or n*n in 2D)
    """
    function movmean(x::AbstractVector, n::Number)
        halfspan = ceil((n-1)/2)
        t = Array{Bool}(undef,length(x))
        m = Array{float(eltype(x))}(undef,size(x))
        ind = 1:length(x)
        @inbounds for i in ind
            t .= ceil(i-halfspan) .<= ind .<= ceil(i+halfspan)
            m[i] = nanmean(x[t])
        end
        return m
    end
    function movmean(x::AbstractMatrix, n::Number)
        halfspan = ceil((n-1)/2)
        t = Array{Bool}(undef,size(x))
        m = Array{float(eltype(x))}(undef,size(x))
        iind = repeat(1:size(x,1), 1, size(x,2))
        jind = repeat((1:size(x,2))', size(x,1), 1)
        @inbounds for k = 1:length(x)
            i = iind[k]
            j = jind[k]
            t .= ((i-halfspan) .<= iind .<= (i+halfspan)) .& ((j-halfspan) .<= jind .<= (j+halfspan))
            m[i,j] = nanmean(x[t])
        end
        return m
    end
    export movmean


## --- End of File
