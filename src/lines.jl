
"""
    Line(z,angle)

Line in the complex plane.

#### Arguments
- `z::Number`: Base point belonging to the line.
- `angle::Real`: Angle (in radians) between the line and the X axis.
"""
struct Line{N <: Number, R <: Real} <: AbstractLine
  base::N
  angle::R

  function Line{N,R}(z0::N, a0::R) where {N <: Number, R <: Real}
    new(z0,a0)
  end
end

Line(z0::N, a0::R) where {N <: Number, R <: Real} = Line{N,R}(z0,a0)

basepoint(l::Line) = l.base
basepointC(l::Line) = l.base
basepointR2(l::Line) = real(l.base), imag(l.base)
angle(l::Line) = l.angle
normal(l::Line) = complex(cos(l.angle), sin(l.angle))
normalC(l::Line) = complex(cos(l.angle), sin(l.angle))
normalR2(l::Line) = cos(l.angle), sin(l.angle)

Base.show(io::IO, l::Line{N,R}) where {N,R} =
print(io, "Line{$N,$R}: base point ", l.base, ", angle with X ", l.angle)


"""
    Ray(z,angle)

A straight line ray.

#### Arguments
- `z::Number`: Base point belonging to the ray.
- `angle::Real`: Angle (in radians) between the ray and the X axis.
"""
struct Ray{N <: Number, R <: Real} <: AbstractRay
  base::N
  angle::R

  function Ray{N,R}(z0::N, a0::R) where {N <: Number, R <: Real}
    new(z0,a0)
  end
end

Ray(z0::N, a0::R) where {N <: Number, R <: Real} = Ray{N,R}(z0,a0)

basepoint(l::Ray) = l.base
basepointC(l::Ray) = l.base
basepointR2(l::Ray) = real(l.base), imag(l.base)
angle(l::Ray) = l.angle
normal(l::Ray) = complex(cos(l.angle), sin(l.angle))
normalC(l::Ray) = complex(cos(l.angle), sin(l.angle))
normalR2(l::Ray) = cos(l.angle), sin(l.angle)


Base.show(io::IO, l::Ray{N,R}) where {N,R} =
print(io, "Ray{$N,$R}: base point", l.base, ", angle with X ", l.angle)


"""
    BiRay(z1,z2,angle)

A straight line bi-ray: the ray from \$z_1\$ to \$\\infty\$ union
the ray from \$z_2\$ to \$\\infty\$.
"""
struct BiRay{N <: Number, R <: Real} <: AbstractLinearCurve
  z1::N
  z2::N
  angle::R

  function BiRay{N,R}(z10::N, z20::N, a0::R) where {N <: Number, R <: Real}
    new(z10,z20,a0)
  end
end

BiRay(z10::N, z20::N, a0::R) where {N <: Number, R <: Real} = BiRay{N,R}(z10,z20,a0)
BiRay(z10::Number, z20::Number, a0::Real) = BiRay(promote(z10,z20)...,a0)

initialpoint(l::BiRay) = l.z1
finalpoint(l::BiRay) = l.z2
angle(l::BiRay) = l.angle
normal(l::BiRay) = cos(l.angle), sin(l.angle)

torays(br::BiRay) = Ray(initialpoint(br),angle(br)), Ray(finalpoint(br),angle(br)+π)

Base.show(io::IO, l::BiRay{N,R}) where {N,R} =
  print(io, "BiRay{$N,$R}: initial point", l.z1, ", final point", l.z2, ", angle with X ", l.angle)


"""
    LineSegment(z1,z2)

A straight line segment.
"""
struct LineSegment{N <: Number} <: AbstractLineSegment
  z1::N
  z2::N

  function LineSegment{N}(z10::N, z20::N) where N <: Number
    new(z10,z20)
  end
end

LineSegment(z10::N, z20::N) where {N <: Number} = LineSegment{N}(z10,z20)
LineSegment(z10::Number, z20::Number) = LineSegment(promote(z10,z20)...)

initialpoint(l::LineSegment) = l.z1
finalpoint(l::LineSegment) = l.z2
initialpointC(l::LineSegment) = l.z1
finalpointC(l::LineSegment) = l.z2
initialpointR2(l::LineSegment) = real(l.z1), imag(l.z1)
finalpointR2(l::LineSegment) = real(l.z2), imag(l.z2)
angle(l::LineSegment) = angle(z1-z2)
normal(l::LineSegment) = perp(z1-z2)
normalC(l::LineSegment) = perp(z1-z2)
#normalR2(l::LineSegment) = perp(z1-z2)

Base.show(io::IO, l::LineSegment{N}) where {N} =
print(io, "LineSegment{$N}: from ", l.z1, " to ", l.z2)


#=
ToDO!

LineR2
RayR2
ByRayR2
LineSegmentR2
=#


linepoints(x1::Real, y1::Real, x2::Real, y2::Real, numpts::Integer=100) =
[(x1+t*(x2-x1)/numpts, y1+t*(y2-y1)/numpts) for t ∈ 0:numpts]

linecomplexes(z1::Number, z2::Number, numpts::Integer=100) =
[z1+t*(z2-z1)/numpts for t ∈ 0:numpts]

function linepoints(l::AbstractLineSegment, numpts::Integer=100)
  x1, y1 = initialpointR2(l)
  x2, y2 = finalpointR2(l)
  [(x1+t*(x2-x1)/numpts, y1+t*(y2-y1)/numpts) for t ∈ 0:numpts]
end

function linecomplexes(l::AbstractLineSegment, numpts::Integer=100)
  z1 = initialpointC(l)
  z2 = finalpointC(l)
  [z1+t*(z2-z1)/numpts for t ∈ 0:numpts]
end


"""
Checks if `z` is inside the semi-plane determined by the line `l` with
  \$0 > normal \\cdot (z - base)\$.
"""
isinside(z::Number, l::Line) = 0 > dot(normal(l), z - l.base)

"""
Checks if `z` is outside the semi-plane determined by the line `l` with
  \$0 < normal \\cdot (z - base)\$.
"""
isoutside(z::Number, c::Line) = 0 < dot(normal(l), z - l.base)
