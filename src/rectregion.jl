
"""
A rectangular region in the cartesian plane.
"""
struct RectRegion{R<:Real}
    xmin::R
    ymin::R
    xmax::R
    ymax::R
  
    RectRegion{R}(x0::R, y0::R, x1::R, y1::R) where R<:Real = new(x0,y0,x1,y1)
end

RectRegion(x0::T, y0::T, x1::T, y1::T) where {T<:Real} =
    RectRegion{T}(x0,y0,x1,y1)

RectRegion(x0::Real, y0::Real, x1::Real, y1::Real) =
    RectRegion(promote(x0,y0,x1,y1)...)

RectRegion(; xmin::Real=0, ymin::Real=0, xmax::Real=1, ymax::Real=1)  =
    RectRegion(promote(xmin,ymin,xmax,ymax)...)

RectRegion(xs::AbstractVector{<:Real}, ys::AbstractVector{<:Real}) =
    RectRegion(promote(xs[1],ys[1],xs[end],ys[end])...)


"""
"""
isinside(p::AbstractVector{<:Real}, rr::RectRegion) =
    (rr.xmin < p[1] < rr.xmax && rr.ymin < p[2] < rr.ymax )

"""
"""
isinsidemax(p::AbstractVector{<:Real}, rr::RectRegion) =
    (rr.xmin <= p[1] < rr.xmax && rr.ymin <= p[2] < rr.ymax )
    
"""
"""
isinsideclosed(p::AbstractVector{<:Real}, rr::RectRegion) =
    (rr.xmin <= p[1] <= rr.xmax && rr.ymin <= p[2] <= rr.ymax )


"""
"""
isinside(p::Number, rr::RectRegion) =
    (rr.xmin < real(p) < rr.xmax && rr.ymin < imag(p) < rr.ymax )
    
"""
"""
isinsidemax(p::Number, rr::RectRegion) =
    (rr.xmin <= real(p) < rr.xmax && rr.ymin <= imag(p) < rr.ymax )
        
"""
"""
isinsideclosed(p::Number, rr::RectRegion) =
    (rr.xmin <= real(p) <= rr.xmax && rr.ymin <= imag(p) <= rr.ymax )
    

"""
"""
tomatrixindex(x::Real, y::Real, w::Int, h::Int, rr::RectRegion) =
    Int(ceil((w-1)*(x - rr.xmin)/(rr.xmax - rr.xmin))+1),
    Int(ceil((h-1)*(y - rr.ymin)/(rr.ymax - rr.ymin))+1)

"""
"""
tomatrixindex(p::AbstractVector{<:Real}, w::Int, h::Int, rr::RectRegion) =
    tomatrixindex(p[1], p[2], w, h, rr)

"""
"""
tomatrixindex(p::Number, w::Int, h::Int, rr::RectRegion) =
    tomatrixindex(real(p), imag(p), w, h, rr)


"""
"""
torot90matrixindex(x::Real, y::Real, w::Int, h::Int, rr::RectRegion) =
    Int(ceil((h-1)*(rr.ymax - y)/(rr.ymax - rr.ymin))+1),
    Int(ceil((w-1)*(x - rr.xmin)/(rr.xmax - rr.xmin))+1)
    
"""
"""
torot90matrixindex(p::AbstractVector{<:Real}, w::Int, h::Int, rr::RectRegion) =
    torot90matrixindex(p[1], p[2], w, h, rr)

"""
"""
torot90matrixindex(p::Number, w::Int, h::Int, rr::RectRegion) =
    torot90matrixindex(real(p), imag(p), w, h, rr)


"""
A ortogonal parallelepiped region in the cartesian 3D space.
"""
struct RectRegion3D{R<:Real}
    xmin::R
    ymin::R
    zmin::R
    xmax::R
    ymax::R
    zmax::R
  
    RectRegion3D{R}(x0::R, y0::R, z0::R, x1::R, y1::R, z1::R) where R<:Real = new(x0,y0,z0,x1,y1,z1)
end

RectRegion3D(x0::T, y0::T, z0::T, x1::T, y1::T, z1::T) where {T<:Real} =
    RectRegion3D{T}(x0,y0,z0,x1,y1,z1)

RectRegion3D(x0::Real, y0::Real, z0::Real, x1::Real, y1::Real, z1::Real) =
    RectRegion3D(promote(x0,y0,z0,x1,y1,z1)...)

RectRegion3D(; xmin::Real=0, ymin::Real=0, zmin::Real=0, xmax::Real=1, ymax::Real=1, zmax::Real=1) =
    RectRegion3D(promote(xmin,ymin,zmin,xmax,ymax,zmax)...)

RectRegion3D(xs::AbstractVector{<:Real}, ys::AbstractVector{<:Real}, zs::AbstractVector{<:Real}) =
    RectRegion3D(promote(xs[1],ys[1],zs[1],xs[end],ys[end],zs[end])...)


"""
"""
isinside(p::AbstractVector{<:Real}, rr::RectRegion3D) =
    (rr.xmin < p[1] < rr.xmax && rr.ymin < p[2] < rr.ymax && rr.zmin < p[3] < rr.zmax )

"""
"""
isinsidemax(p::AbstractVector{<:Real}, rr::RectRegion3D) =
    (rr.xmin <= p[1] < rr.xmax && rr.ymin <= p[2] < rr.ymax && rr.zmin <= p[3] < rr.zmax )
    
"""
"""
isinsideclosed(p::AbstractVector{<:Real}, rr::RectRegion3D) =
    (rr.xmin <= p[1] <= rr.xmax && rr.ymin <= p[2] <= rr.ymax && rr.zmin <= p[3] <= rr.zmax )


"""
"""
tocubeindex(p::AbstractVector{<:Real}, w::Int, h::Int, d::Int, rr::RectRegion3D) =
    Int(ceil((w-1)*(p[1] - rr.xmin)/(rr.xmax - rr.xmin))+1),
    Int(ceil((h-1)*(p[2] - rr.ymin)/(rr.ymax - rr.ymin))+1),
    Int(ceil((d-1)*(p[3] - rr.zmin)/(rr.zmax - rr.zmin))+1)