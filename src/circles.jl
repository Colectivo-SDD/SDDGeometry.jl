

"""
    Circle(c,r)

Circle in the complex plane. \$|c-z|=r\$.

#### Arguments
- `c::N`: Center.
- `r::R`: Radius.
"""
struct Circle{N <: Number, R <: Real} <: AbstractCircle
  center::N
  radius::R

  function Circle{N,R}(c0::N, r0::R)  where {N <: Number, R <: Real}
    #if r0 < 0
    #  error("Circle can not have negative radius.")
    #end
    new(c0,r0)
  end
end

Circle(c0::N, r0::R) where {N <: Number, R <: Real} = Circle{N,R}(c0,r0)

center(c::Circle) = c.center
centerC(c::Circle) = c.center
centerR2(c::Circle) = real(c.center), imag(c.center)
centerx(c::Circle) = real(c.center)
centery(c::Circle) = imag(c.center)
radius(c::Circle) = c.radius
radius2(c::Circle) = c.radius*c.radius

Base.show(io::IO, c::Circle{N,R}) where {N,R} =
print(io, "Circle{$N,$R}: |z - (", c.center, ")| = ", c.radius)


"""
    CircleR2(x,y,r)

Circle in the plane \$\\mathbb{R}^2\$. \$|(x0,y0)-(x,y)|=r\$.
"""
struct CircleR2{R <: Real} <: AbstractCircle
  centerx::R
  centery::R
  radius::R

  function CircleR2{R}(x0::R, y0::R, r0::R)  where {R <: Real}
    #if r0 < 0
    #  error("Circle can not have negative radius.")
    #end
    new(x0,y0,r0)
  end
end

CircleR2(x0::R, y0::R, r0::R) where {R <: Real} = CircleR2{R}(x0,y0,r0)
CircleR2(x0::Real, y0::Real, r0::Real) = CircleR2(promote(x0,y0,r0)...)

center(c::CircleR2) = c.centerx, c.centery
centerC(c::CircleR2) = complex(c.centerx, c.centery)
centerR2(c::CircleR2) = c.centerx, c.centery
centerx(c::CircleR2) = c.centerx
centery(c::CircleR2) = c.centery
radius(c::CircleR2) = c.radius
radius2(c::CircleR2) = c.radius*c.radius

Base.show(io::IO, c::CircleR2{R}) where {R} =
print(io, "CircleR2{$R}: |(x,y) - (", c.centerx, ",", c.centery, " )| = ", c.radius)


"""
    Arc(c,p1,p2)

Circular arc the complex plane.

#### Arguments:
- `c::N`: center.
- `p1::N`: Initial point.
- `p2::N`: Final point.
"""
struct Arc{N} <: AbstractArc
  center::N
  p1::N
  p2::N

  function Arc{N}(c0::N, p10::N, p20::N)  where {N <: Number}
    #if r0 < 0
    #  error("Circle can not have negative radius.")
    #end
    new(c0,p10,p20)
  end
end


Arc(c0::N, p10::N, p20::N) where {N <: Number} = Arc{N}(c0,p10,p20)
Arc(c0::Number, p10::Number, p20::Number) = Arc(promote(c0,p10,p20)...)
Arc(c0::Number, r::Real, θ1::Real, θ2::Real) =
Arc(c0, r*(cos(θ1)+sin(θ1)*im), r*(cos(θ2)+sin(θ2)*im))

center(ca::Arc) = ca.center
centerC(ca::Arc) = ca.center
centerR2(ca::Arc) = real(ca.center), imag(ca.center)
radius(ca::Arc) = abs(ca.center - ca.p1)
radius2(ca::Arc) = abs2(ca.center - ca.p1)
initialpoint(ca::Arc) = ca.p1
finalpoint(ca::Arc) = ca.p2
initialpointC(ca::Arc) = ca.p1
finalpointC(ca::Arc) = ca.p2
initialpointR2(ca::Arc) = real(ca.p1), imag(ca.p1)
finalpointR2(ca::Arc) = real(ca.p2), imag(ca.p2)

Base.show(io::IO, ca::Arc{N}) where {N} =
print(io, "Arc{$N}: center=", ca.center, ", extremes ", ca.p1, ", ", ca.p2)


"""
    BiArc(c,p1,p2,p3,p4)

Two arcs in the same circunference.
"""
struct BiArc{N <: Number} <: AbstractCircularCurve
  center::N
  p1::N
  p2::N
  p3::N
  p4::N

  function BiArc{N}(c0::N, p10::N, p20::N, p30::N, p40::N)  where {N <: Number}
    new(c0,p10,p20,p30,p40)
  end
end

BiArc(c0::N, p10::N, p20::N, p30::N, p40::N) where {N <: Number} = BiArc{N}(c0,p10,p20,p30,p40)
BiArc(c0::Number, p10::Number, p20::Number, p30::Number, p40::Number) = BiArc(promote(c0,p10,p20,p30,p40)...)

toarcs(ba::BiArc) = Arc(ba.center,ba.p1,ba.p2), Arc(ba.center,ba.p3,ba.p4)


#=
ToDo!
ArcR2
BiArcR2
=#



"""
Checks if `z` is inside the circle `c` with \$|center-z|^2 < radius^2\$.
"""
isinside(z::Number, c::Circle) = abs2(c.center - z) < (c.radius * c.radius)

"""
Checks if `z` is outside the circle `c` with \$|center-z|^2 > radius^2\$.
"""
isoutside(z::Number, c::Circle) = abs2(c.center - z) > (c.radius * c.radius)


"""
    circlepoints(c, [θ0, θ1; numpts]) -> Array{Tuple{Float64,Float64}}

Create an array of points (`Tuple{Float64,Float64}`) in a given circle

#### Arguments
- `c::Circle`: A circle.
- `θ0::Real`: Initial angle.
- `θ1::Real`: Final angle.
- `numpts::Integer`: Number of points to create.
"""
circlepoints(c::AbstractCircle, θ0::Real=0, θ1::Real=2π; numpts::Integer=100) =
[ (centerx(c) + radius(c)*cos(θ), centery(c) + radius(c)*sin(θ)) for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]

circlepoints(x::Real, y::Real, r::Real, θ0::Real=0, θ1::Real=2π; numpts::Integer=100) =
[ (x + r*cos(θ), y + r*sin(θ)) for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]

"""
    circlepoints(c, [θ0, θ1; numpts]) -> Array{Complex{Float64}}

Create an array of complex number in a given circle.

#### Arguments
- `c::Circle`: A circle.
- `θ0::Real`: Initial angle.
- `θ1::Real`: Final angle.
- `numpts::Integer`: Number of points to create.
"""
circlecomplexes(c::AbstractCircle, θ0::Real=0, θ1::Real=2π; numpts::Integer=100) =
[ centerC(c) + radius(c)*exp(θ*im) for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]

circlecomplexes(z::Number, r::Real, θ0::Real=0, θ1::Real=2π; numpts::Integer=100) =
[ z + r*cos(θ) + r*sin(θ)*im for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]
