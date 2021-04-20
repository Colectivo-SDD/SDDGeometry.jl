
import Base: show


"""
    Circle(c,r)

Circle in the complex plane. \$|c-z|=r\$.
"""
struct Circle{N <: Number, R <: Real} <: AbstractCircularCurve
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
radius(c::Circle) = c.radius
radius2(c::Circle) = c.radius*c.radius

function show(io::IO, c::Circle)
  print(io, "Circle: |z - (", c.center, ")| = ", c.radius)
end

#=
islinear(c::Circle) = false
iscircular(c::Circle) = true
isline(c::Circle) = false
iscircle(c::Circle) = true
=#

"""
    CircleR2(x,y,r)

Circle in the plane \$\\mathbb{R}^2\$. \$|(x0,y0)-(x,y)|=r\$.
"""
struct CircleR2{R <: Real} <: AbstractCircularCurve
  centerx::R
  centery::R
  radius::R

  function Circle{R}(x0::R, y0::R, r0::R)  where {R <: Real}
    #if r0 < 0
    #  error("Circle can not have negative radius.")
    #end
    new(x0,y0,r0)
  end
end

CircleR2(x0::R, y0::R, r0::R) where {R <: Real} = CircleR2{R}(x0,y0,r0)

CircleR2(x0::Real, y0::Real, r0::Real) = CircleR2(promote(x0,y0,r0)...)

center(c::CircleR2) = c.centerx, c.centery
centerx(c::CircleR2) = c.centerx
centery(c::CircleR2) = c.centery
radius(c::CircleR2) = c.radius
radius2(c::CircleR2) = c.radius*c.radius

function show(io::IO, c::CircleR2)
  print(io, "Circle: |(x,y) - (", c.centerx, ",", c.centery, " )| = ", c.radius)
end

#=
islinear(c::CircleR2) = false
iscircular(c::CircleR2) = true
isline(c::CircleR2) = false
iscircle(c::CircleR2) = true
=#

"""
    CircularArc(c,p1,p2)

Circular arc the complex plane.
"""
struct CircularArc{N} <: AbstractCircularCurve
  center::N
  p1::N
  p2::N

  function CircularArc{N}(c0::N, p10::N, p20::N)  where {N <: Number}
    #if r0 < 0
    #  error("Circle can not have negative radius.")
    #end
    new(c0,p10,p20)
  end
end


CircularArc(c0::N, p10::N, p20::N) where {N <: Number} = CircularArc{N}(c0,p10,p20)
CircularArc(c0::Number, p10::Number, p20::Number) = CircularArc(promote(c0,p10,p20)...)
CircularArc(c0::Number, r::Real, θ1::Real, θ2::Real) =
  CircularArc(c0, r*(cos(θ1)+sin(θ1)*im), r*(cos(θ2)+sin(θ2)*im))

center(ca::CircularArc) = ca.center
radius(ca::CircularArc) = abs(ca.center - ca.p1)
radius2(ca::CircularArc) = abs2(ca.center - ca.p1)
p1(ca::CircularArc) = ca.p1
p2(ca::CircularArc) = ca.p2

function show(io::IO, ca::CircularArc)
  print(io, "Circular Arc: center=", ca.center, ", extremes ", ca.p1, ", ", ca.p2)
end

#=
islinear(ca::CircularArc) = false
iscircular(ca::CircularArc) = true
isline(ca::CircularArc) = false
iscircle(ca::CircularArc) = true
=#

#=
ToDo!
CircularArcR2
=#


"""
    CLine(A,B,C)

Circle-Line (Cline) in the complex plane, also called generalized circle.

\$A |z|^2 + B z + \\overline{B \\overline{z} + C = 0\$.

\$A,C \\in \\mathbb R , B \\in \\mathbb C\$.

"""
struct CLine{R <: Real, N <:Number} <: AbstractCircularLinearCurve
  A::R
  B::N
  C::R

  function CLine{R,N}(A0::R, B0::N, C0::R) where {R <: Real, N <: Number }
    #if abs2(B0) <= A0*C0
    #  error("Invalid parameters for CLine. Must satisfy |B|^2 > AC.")
    #end
    new(A0,B0,C0)
  end
end

CLine(A0::R, B0::N, C0::R) where {R <: Real, N <: Number} = CLine{R,N}(A0,B0,C0)

function CLine(A0::Real, B0::Number, C0::Real)
  ac = promote(A0,C0)
  CLine(ac[1],B0,ac[2])
end

center(c::CLine) = -conj(c.B)

function radius(c::CLine)
  if c.A ≈ 0.0
    return Inf
  end
  sqrt( abs2(c.B) / (c.A * c.A) - c.C / c.A )
end

function radius2(c::CLine)
  if c.A ≈ 0.0
    return Inf
  end
  abs2(c.B) / (c.A * c.A) - c.C / c.A
end

function show(io::IO, c::CLine)
  print(io, "CLine: (", c.A, ")|z|^2 + (", c.B, ")z + (", conj(c.B), ")conj(z) + (", c.C, ") = 0")
end

#=
islinear(c::CLine) = iszero(c.A)
iscircular(c::CLine) = !iszero(c.A)
=#

"""
Checks if `z` is inside the circle `c` with \$|center-z|^2 < radius^2\$.
"""
isinside(z::Number, c::Circle) = abs2(c.center - z) < (c.radius * c.radius)

"""
Checks if `z` is inside the CLine `c` with \$A |z|^2 + 2 Re(B z) + C < 0\$.
"""
isinside(z::Number, c::CLine) = c.A * abs2(z) + 2 * real(c.B * z) + c.C < 0

"""
Checks if `z` is outside the circle `c` with \$|center-z|^2 > radius^2\$.
"""
isoutside(z::Number, c::Circle) = abs2(c.center - z) > (c.radius * c.radius)

"""
Checks if `z` is outside the CLine `c` with \$A |z|^2 + 2 Re(B z) + C > 0\$.
"""
isoutside(z::Number, c::CLine) = c.A * abs2(z) + 2 * real(c.B * z) + c.C > 0


"""
Convert `CLine` to `Circle`.
"""
circle(c::CLine) = Circle(center(c), radius(c))

"""
Convert `Circle` to `CLine`.
"""
cline(c::Circle) = CLine(1, -conj(c.center), abs2(c.center) - c.radius*c.radius)


"""
    circlepoints(c, [θ0, θ1; numpts]) -> Array{Tuple{Float64,Float64}}

Create an array of points (`Tuple{Float64,Float64}`) in a given circle

#### Arguments
- `c::Circle`: A circle.
- `θ0::Real`: Initial angle.
- `θ1::Real`: Final angle.
- `numpts::Integer`: Number of points to create.
"""
function circlepoints(c::Circle, θ0::Real=0, θ1::Real=2π; numpts::Integer=100)
#=  pts = Tuple{Float64,Float64}[]
  Δθ = (θ1 - θ0)/npts
  θ = θ0
  for n in 0:npts
    push!(pts, ( c.center.re + c.radius * cos(θ), c.center.im + c.radius * sin(θ) ) )
    θ += Δθ
  end
  pts
=#
  [ (c.center.re + c.radius*cos(θ), c.center.im + c.radius*sin(θ)) for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]
end

"""
    circlepoints(c, [θ0, θ1; numpts]) -> Array{Complex{Float64}}

Create an array of complex number in a given circle.

#### Arguments
- `c::Circle`: A circle.
- `θ0::Real`: Initial angle.
- `θ1::Real`: Final angle.
- `numpts::Integer`: Number of points to create.
"""
function circlecomplexes(c::Circle, θ0::Real=0, θ1::Real=2π; numpts::Integer=100)
  [ c.center + c.radius*exp(θ*im) for θ ∈ θ0:((θ1 - θ0)/numpts):θ1 ]
end
