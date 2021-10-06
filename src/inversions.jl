
import Base: ∘

"""
Abstract type, base for circle inversions and line reflections.
"""
abstract type AbstractInversion#={T, R <: Real}=# <: AbstractComplexInvertibleFunction#={T}=# end


"""
    CircleInversion(p,r)

Circle inversion, in the Riemann sphere
\$z \\mapsto \\frac{r^2}{\\overline{z-p}}+p\$
where ...
"""
struct CircleInversion{T<:Number,R<:Real} <: AbstractInversion
  center::T
  radius::R

  function CircleInversion{T,R}(c0::T=0,r0::R=1) where {T <: Number, R <: Real}
    new(c0,r0)
  end

end

CircleInversion(c0::T=0,r0::R=1) where {T <: Number, R <: Real} =
CircleInversion{T,R}(c0,r0)

CircleInversion(f::CircleInversion{T,R}) where {T <: Number, R <: Real} =
CircleInversion{T,R}(f.center,f.radius)

CircleInversion(c::Circle) = CircleInversion(c.center, c.radius)


"""
    Reflection(p,θ)

Line reflection, in the Riemann sphere
\$z \\mapsto e^{θi}\\(overline{z-p})}+p\$
where ...
"""
struct Reflection{T<:Number,R<:Real} <: AbstractInversion
  base::T
  a::R

  function Reflection{T,R}(b0::T=0,a0::R=0) where {T <: Number, R <: Real}
    new(b0,a0)
  end
end

Reflection(b0::T=0,a0::R=0) where {T <: Number, R <:Real} = Reflection{T,R}(b0,a0)
Reflection(f::Reflection{T,R}) where {T <: Number, R <:Real} = Reflection{T,R}(f.base,f.a)

Reflection(l::Line) = Reflection(l.base, l.a)


Base.show(io::IO, f::CircleInversion{T,R}) where {T<:Number,R<:Real} =
  print(io, "CircleInversion{$T,$R}: z -> (", f.radius, ")^2 / conj(z - ", f.center, ") + ", f.center)

Base.show(io::IO, f::Reflection{T,R}) where {T<:Number,R<:Real}  =
  print(io, "Reflection{$T,$R}: z -> e^((", f.a, ")i)conj(z - (", f.base, ")) + ", f.base)


function (f::CircleInversion)(z::Number)
  isinf(z) ? 0 : f.radius^2 / conj(z - f.center) + f.center
end

function (f::Reflection)(z::Number)
  complexU(2f.a)*conj(z - f.base) + f.base
end


"""
Inversions parameters accesors.
"""
radius(f::CircleInversion) = f.radius
center(f::CircleInversion) = f.center

radius(f::Reflection) = Inf
lineangle(f::Reflection) = f.a
basepoint(f::Reflection) = f.base


"""
Inverse.
"""
inverse(f::CircleInversion) = f
inverse(f::Reflection) = f


#="""
Derivative.
"""
function derivative(f::CircleInversion)
  function der(z::Number)
    (f.a * f.d - f.b * f.c) / ((f.c * z + f.d)^2)
  end
end

function derivative(f::Reflection)
  function der(z::Number)
    f.a
  end
end=#


#="""
    fixedpoints(f)
"""
function fixedpoints(f::CircleInversion)
  Circle
end

function fixedpoints(f::Reflection)
  Line
end=#


"""
Kind of inversion:
- `:circleinversion`.
- `:reflection`.
"""
kind(f::CircleInversion) = :circleinversion
kind(f::Reflection) = :reflection


"""
Compose two inversions.
"""
function compose(f::CircleInversion, g::CircleInversion)
  c = conj(g.center - f.center)
  fr2 = f.radius^2
  gr2 = g.radiur^2
  MobiusTransformation(fr2 - c*f.center,
    gr2*f.center - fr2*g.center - c*f.center*g.center,
    c, gr2 - c*g.center)
end

function compose(f::Reflection, g::Reflection)
  a = complexU(f.a - g.a)
  AffineTransformation(a,
    f.center + complexU(f.a)*conj(g.center - f.center) - a*g.center)
end

function compose(f::CircleInversion, g::Reflection)
  c = complexU(-g.a)
  d = conj(g.center - f.center) - c*g.center
  MobiusTransformation(c*f.center, f.center*d + f.radius^2, c, d)
end

function compose(f::Reflection, g::CircleInversion)
  u = complexU(f.a)
  a = u*(conj(g.center - f.center) + f.center)
  MobiusTransformation(a, (g.radius^2)*u - a*g.center, 1, -g.center)
end


"""
Binary operator to compose two Inversions and with Möbius transformations.
"""
∘(f::AbstractInversion, g::AbstractInversion) = compose(f,g)


"""
"""
function (f::CircleInversion)(c::Circle)
  if f.center ≈ c.center
    return Circle(c.center, abs(f(c.center + c.radius) - c.center))
  end

  v = f.center - c.center
  absv = abs(v)

  if absv ≈ c.radius
    return Line(f.center, angle(perp(v)))
  end

  v = v/absv
  q1 = f(c.center + c.radius*v)
  q2 = f(c.center - c.radius*v)
  newcenter = (q1 + q2)/2
  Circle(newcenter, abs(newcenter - q1))
end

function (f::Reflection)(c::Circle)
  Circle( f(c.center), c.radius )
end


function (f::CircleInversion)(c::Arc)
  #ToDo!
end

function (f::Reflection)(c::Arc)
  Arc(f(c.center), f(c.p1), f(c.p2))
end


function (f::CircleInversion)(l::Line)
  if abs(angle(f.center - l.base)) ≈ l.a
    return l
  end

  q = f(nearestpoint(f.center, l))
  newcenter = (f.center + q)/2
  Circle(newcenter, abs(newcenter - q))
end

function (f::Reflection)(l::Line)
  Line(f(l.base), 2f.a - l.a)
end


function (f::CircleInversion)(l::LineSegment)
    # ToDo!
end

function (f::Reflection)(l::LineSegment)
  LineSegment(f(l.p1), f(l.p2))
end
