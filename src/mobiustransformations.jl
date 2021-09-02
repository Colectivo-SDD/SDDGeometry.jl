
import Base: ∘

"""
Abstract type, base for invertible function in the Riemann sphere.
"""
abstract type AbstractComplexInvertibleFunction#={T <: Number}=# <: Function end

"""
Abstract type, base for Möbius transformations.
"""
abstract type AbstractMobiusTransformation#={T}=# <: AbstractComplexInvertibleFunction#={T}=# end

"""
Abstract type, base for affine transformations.
"""
abstract type AbstractAffineTransformation <: AbstractMobiusTransformation end


"""
    MobiusTransformation(a,b,c,d)

Möbius transformation, a conformal automorphism in the Riemann sphere
\$z \\mapsto \\frac{az+b}{cz+d}\$
with \$ad-bc\\neq 0\$.
"""
struct MobiusTransformation{T<:Number} <: AbstractMobiusTransformation
  a::T
  b::T
  c::T
  d::T

  function MobiusTransformation{T}(a0::T, b0::T, c0::T, d0::T) where T<:Number
    #@assert a0 * d0 - b0 * c0 != 0 "Invalid parameters for Möbius transformation."
    new(a0,b0,c0,d0)
  end

end

MobiusTransformation(a0::T, b0::T, c0::T, d0::T) where {T <: Number} =
MobiusTransformation{T}(a0,b0,c0,d0)

MobiusTransformation(a0::Number, b0::Number, c0::Number, d0::Number) =
MobiusTransformation(promote(a0,b0,c0,d0)...)

MobiusTransformation(f::MobiusTransformation{T}) where {T <: Number} =
MobiusTransformation{T}(f.a,f.b,f.c,f.d)


"""
    AffineTransformation(a,b)

Affine transformation in the Riemann sphere
\$z \\mapsto a z + b\$.
"""
struct AffineTransformation{T<:Number} <: AbstractAffineTransformation
  a::T
  b::T

  function AffineTransformation{T}(a0::T, b0::T) where T <:Number
    new(a0,b0)
  end
end

AffineTransformation(a0::T, b0::T) where {T <: Number} =
  AffineTransformation{T}(a0,b0)
AffineTransformation(a0::Number, b0::Number) =
  AffineTransformation(promote(a0,b0)...)
AffineTransformation(f::AffineTransformation{T}) where {T <: Number} =
  AffineTransformation(f.a,f.b)

MobiusTransformation(a0::Number, b0::Number) = AffineTransformation(promote(a0,b0)...)
MobiusTransformation(f::AffineTransformation) = AffineTransformation(f)


"""
    LinearTransformation(a)

Linear transformation (homotecy and rotation) in the Riemann sphere
\$z \\mapsto a z\$.
"""
struct LinearTransformation{T<:Number} <: AbstractAffineTransformation
  a::T

  function LinearTransformation{T}(a0::T) where T <: Number
    #@assert a0 == 0 "Invalid parameters for Möbius transformation."
    new(a0)
  end
end

LinearTransformation(a0::T) where {T <: Number} = LinearTransformation{T}(a0)
LinearTransformation(f::LinearTransformation{T}) where {T <: Number} =
  LinearTransformation{T}(f.a)

MobiusTransformation(a0::Number) = LinearTransformation(a0)
MobiusTransformation(f::LinearTransformation) = LinearTransformation(f)
AffineTransformation(f::LinearTransformation) = LinearTransformation(f)

"""
    Translation(b)

Translation in the Riemann sphere
\$z \\mapsto z + b\$.
"""
struct Translation{T<:Number} <: AbstractAffineTransformation
  b::T

  function Translation{T}(b0::T) where T <:Number
    new(b0)
  end
end

Translation(b0::T) where {T <: Number} = Translation{T}(b0)
Translation(f::Translation{T}) where {T <: Number} = Translation{T}(f.b)

MobiusTransformation(f::Translation) = Translation(f)
AffineTransformation(f::Translation) = Translation(f)


"""
    InversionReflection(b)

Inversion reflection in the Riemann sphere
\$z \\mapsto \\frac{b}{z}\$.
"""
struct InversionReflection{T<:Number} <: AbstractMobiusTransformation
  b::T

  function InversionReflection{T}(b0::T) where T <:Number
    new(b0)
  end
end

InversionReflection(b0::T) where {T <: Number} = InversionReflection{T}(b0)
InversionReflection(f::InversionReflection{T}) where {T <: Number} =
  InversionReflection{T}(f.b)

MobiusTransformation(f::InversionReflection) = InversionReflection(f)


Base.show(io::IO, f::MobiusTransformation{T}) where T<:Number =
  print(io, "MöbiusTransformation{$T}: z -> ((", f.a, ")z + (", f.b, ")) / ((", f.c, ")z + (", f.d, "))")

Base.show(io::IO, f::LinearTransformation{T}) where T<:Number  =
  print(io, "LinearTransformation{$T}: z -> (", f.a, ")z")

Base.show(io::IO, f::Translation{T}) where T<:Number  =
  print(io, "Translation{$T}: z -> z + (", f.b, ")")

Base.show(io::IO, f::AffineTransformation{T}) where T<:Number  =
  print(io, "AffineTransformation{$T}: z -> (", f.a, ")z + (", f.b, ")")

Base.show(io::IO, f::InversionReflection{T}) where T<:Number  =
  print(io, "InversionReflection{$T}: z -> (", f.b, ") / z")


function (f::MobiusTransformation)(z::Number)
  # ToDo! Create a method to eval infinity case
  if isinf(z)
    return iszero(f.c) ? Inf : f.a / f.c # Necesary to avoid number/(0+0im) = NaN+NaN*im
  end

  den = f.c * z + f.d

  if den ≈ 0 # Necesary to avoid number/(0+0im) = NaN+NaN*im
    return Inf
  end

  (f.a * z + f.b) / den
end

function (f::LinearTransformation)(z::Number)
  f.a * z
end

function (f::Translation)(z::Number)
  z + f.b
end

function (f::AffineTransformation)(z::Number)
  f.a * z + f.b
end

function (f::InversionReflection)(z::Number)
  # ToDo! Create a method to eval infinity case
  if isinf(z)
    return 0
  elseif z ≈ 0 # Necesary to avoid complex/(0+0im) = NaN+NaN*im
    return Inf
  end

  f.b / z
end


"""
Möbius transformation parameters accesors.
"""
a(f::MobiusTransformation) = f.a
b(f::MobiusTransformation) = f.b
c(f::MobiusTransformation) = f.c
d(f::MobiusTransformation) = f.d

a(f::LinearTransformation) = f.a
b(f::LinearTransformation) = 0
c(f::LinearTransformation) = 0
d(f::LinearTransformation) = 1

a(f::Translation) = 1
b(f::Translation) = f.b
c(f::Translation) = 0
d(f::Translation) = 1

a(f::AffineTransformation) = f.a
b(f::AffineTransformation) = f.b
c(f::AffineTransformation) = 0
d(f::AffineTransformation) = 1

a(f::InversionReflection) = 0
b(f::InversionReflection) = f.b
c(f::InversionReflection) = 1
d(f::InversionReflection) = 0


"""
Trace

\$tr(T)=a+d\$
"""
tr(f::AbstractMobiusTransformation) = a(f) + d(f)

tr(f::MobiusTransformation) = f.a + f.d

tr(f::LinearTransformation) = f.a + 1

tr(f::Translation) = 1

tr(f::AffineTransformation) = f.a + 1

tr(f::InversionReflection) = 0


"""
Determinant.

\$det(T)=ad-bc\$
"""
det(f::AbstractMobiusTransformation) = a(f)*d(f) - b(f)*c(f)

det(f::MobiusTransformation) = f.a * f.d - f.b * f.c

det(f::LinearTransformation) = f.a

det(f::Translation) = 1

det(f::AffineTransformation) = f.a

det(f::InversionReflection) = -f.b


#function normalize(f::MobiusTransformation)
#  dt = det(f)
#  MobiusTransformation(f.a/dt, f.b/det, f.c/det, f.d/det)
#end

#function normalize(f::LinearTransformation)
#  f
#end


"""
Inverse.

\$T^{-1}(z)=\\frac{d z - b}{-c z + a}\$
"""
inverse(f::MobiusTransformation) = MobiusTransformation(f.d, -f.b, -f.c, f.a)

inverse(f::LinearTransformation) = LinearTransformation(1.0 / f.a)

inverse(f::Translation) = Translation(-f.b)

inverse(f::AffineTransformation) = AffineTransformation(1.0 / f.a, -f.b / f.a)

inverse(f::InversionReflection) = InversionReflection(f.b)


"""
Derivative.

\$T'(z)=\\frac{ad-bc}{(c z + d)^2}\$
"""
#=function derivative(f::MobiusTransformation)
  function der(z::Number)
    (f.a * f.d - f.b * f.c) / ((f.c * z + f.d)^2)
  end
end=#
derivative(f::MobiusTransformation) = z::Number -> (f.a * f.d - f.b * f.c) / ((f.c * z + f.d)^2)

function derivative(f::LinearTransformation)
  function der(z::Number)
    f.a
  end
end

function derivative(f::Translation)
  function der(z::Number)
    1
  end
end

function derivative(f::AffineTransformation)
  function der(z::Number)
    f.a
  end
end

function derivative(f::InversionReflection)
  function der(z::Number)
    -f.b / (z^2)
  end
end


"""
    fixedpoints(f)

Returns the fixed points of a Möbius transformation. Always returns two points,
even in the parabolic case returns the one fixed point duplicated.
"""
function fixedpoints(f::MobiusTransformation{T}) where T <: Real
  if f.c ≈ 0
    return f.b / (f.d - f.a), Inf
  end
  discr = (f.a + f.d)^2 - 4 * (f.a * f.d - f.b * f.c)
  rd = discr < 0 ? sqrt(complex(discr)) : sqrt(discr)
  (f.a - f.d + rd)/(2*f.c), (f.a - f.d - rd)/(2*f.c)
end

function fixedpoints(f::MobiusTransformation)
  if f.c ≈ 0
    return f.b / (f.d - f.a), Inf
  end
  rd = sqrt((f.a + f.d)^2 - 4 * (f.a * f.d - f.b * f.c))
  (f.a - f.d + rd)/(2*f.c), (f.a - f.d - rd)/(2*f.c)
end

function fixedpoints(f::LinearTransformation)
  0, Inf
end

function fixedpoints(f::Translation)
  Inf, Inf
end

function fixedpoints(f::AffineTransformation)
  if f.a ≈ 1
    return Inf, Inf
  end
  f.b / (1 - f.a), Inf
end

function fixedpoints(f::InversionReflection{T}) where T <: Real
  rd = f.b < 0 ? sqrt(complex(f.b)) : sqrt(f.b)
  rd, -rd
end

function fixedpoints(f::InversionReflection)
  rd = sqrt(f.b)
  rd, -rd
end


"""
Kind of Möbius transformation:
- `:parabolic` if \$t^2=4\$.
- `:elliptic` if \$t^2\\in [0,4)\$.
- `:hyperbolic` if \$t^2\\in (-\\infty,0)\\cup (4,\\infty)\$.
- `:loxodromic` otherwise.
where \$t=tr(T)/det(T)\$.
"""
function kind(f::AbstractMobiusTransformation)
  t2 = (tr(f)^2) / det(f)
  if imag(t2) ≈ 0
    t2 = real(t2)
    if t2 ≈ 4
      return :parabolic
    end

    if 0 <= t2 < 4
      return :elliptic
    end

    return :hyperbolic
  end

  :loxodromic
end

function kind(f::AbstractAffineTransformation)
  if a(f) ≈ 1
    return :parabolic
  end

  if abs2(a(f)) ≈ 1
    return :elliptic
  elseif imag(a(f)) ≈ 0
    return :hyperbolic
  end

  :loxodromic
end

kind(f::Translation) = :parabolic


"""
Compose two Möbius transformations.
"""
compose(f::AbstractMobiusTransformation, g::AbstractMobiusTransformation) =
  MobiusTransformation(a(f)*a(g)+b(f)*c(g), a(f)*b(g)+b(f)*d(g),
    c(f)*a(g)+d(f)*c(g), c(f)*b(g)+c(f)*d(g))

compose(f::MobiusTransformation, g::MobiusTransformation) =
  MobiusTransformation(f.a*g.a+f.b*g.c, f.a*g.b+f.b*g.d,
    f.c*g.a+f.d*g.c, f.c*g.b+f.d*g.d)

compose(f::LinearTransformation, g::LinearTransformation) =
  LinearTransformation(f.a * g.a)

compose(f::Translation, g::Translation) =
  Translation(f.b + g.b)

compose(f::AffineTransformation, g::AffineTransformation) =
  AffineTransformation(f.a * g.a, f.a * g.b + f.b)

compose(f::InversionReflection, g::InversionReflection) =
  LinearTransformation(f.b / g.b)


# LinearTransformation vs ...
compose(f::LinearTransformation, g::MobiusTransformation) =
  MobiusTransformation(f.a*g.a, f.a*g.b, g.c, g.d)

compose(f::MobiusTransformation, g::LinearTransformation) =
  MobiusTransformation(f.a*g.a, f.b, f.c*g.a, f.d)


compose(f::LinearTransformation, g::Translation) =
  AffineTransformation(f.a, f.a * g.b)

compose(f::Translation, g::LinearTransformation) =
  AffineTransformation(g.a, f.b)


compose(f::LinearTransformation, g::AffineTransformation) =
  AffineTransformation(f.a * g.a, f.a * g.b)

compose(f::AffineTransformation, g::LinearTransformation) =
  AffineTransformation(f.a * g.a, f.b)


# Translation vs ...
compose(f::Translation, g::MobiusTransformation) =
  MobiusTransformation(g.a+f.b*g.c, g.b+f.b*g.d, g.c, g.d)

compose(f::MobiusTransformation, g::Translation) =
  MobiusTransformation(f.a, f.a*g.b+f.b, f.c, f.c*g.b+f.d)


compose(f::Translation, g::AffineTransformation) =
  AffineTransformation(g.a, g.b+f.b)

compose(f::AffineTransformation, g::Translation) =
  AffineTransformation(f.a, f.a*g.b+f.b)


# AffineTransformation vs ...
compose(f::AffineTransformation, g::MobiusTransformation) =
  MobiusTransformation(f.a*g.a+f.b*g.c, f.a*g.b+f.b*g.d, g.c, g.d)

compose(f::MobiusTransformation, g::AffineTransformation) =
  MobiusTransformation(f.a*g.a, f.a*g.b+f.b, f.c*g.a, f.c*g.b+f.d)


# InversionReflection vs ...
# all result are a MobiusTransformation, fall back to AbstractMobiusTransformation implementation


"""
Binary operator to compose two Möbius transformations.
"""
∘(f::AbstractMobiusTransformation, g::AbstractMobiusTransformation) = compose(f,g)


"""
    maptozerooneinf(z1,z2,z3)

Create the Möbius transformation such that \$z_1 \\mapsto 0\$,
\$z_2 \\mapsto 1\$ and \$z_3 \\mapsto \\infty\$.
"""
function maptozerooneinf(z1::Number, z2::Number, z3::Number)
  # z -> ( (z2-z3)(z-z1) ) / ( (z2-z1)(z-z3) )

  if isinf(z1)
    return MobiusTransformation(0, z2-z3, 1, -z3)
  elseif isinf(z2)
    return MobiusTransformation(1, -z1, 1, -z3)
  elseif isinf(z3)
    return MobiusTransformation(1, -z1, 0, z2-z1)
  end

  MobiusTransformation(z2-z3, z1*(z3-z2), z2-z1, z3*(z1-z2))
end

"""
    mapfromzerooneinf(z1,z2,z3)

Create the Möbius transformation such that \$0 \\mapsto z_1\$,
  \$1 \\mapsto z_2\$ and \$\\infty \\mapsto z_3\$.
"""
function mapfromzerooneinf(z1::Number, z2::Number, z3::Number)
  # z -> ( z3(z1-z2)z + z1(z2-z3) ) / ( (z1-z2)z + (z2-z3) )

  if isinf(z1)
    return MobiusTransformation(z3, z2-z3, 1, 0)
  elseif isinf(z2)
    return MobiusTransformation(-z3, z1, -1, 1)
  elseif isinf(z3)
    return MobiusTransformation(z2-z1, z1, 0, 1)
  end

  # inverse of
  # MobiusTransformation(z2-z3, z1*(z3-z2), z2-z1, z3*(z1-z2))
  MobiusTransformation(z3*(z1-z2), z1*(z2-z3), z1-z2, z2-z3)
end

"""
Create the Möbius transformation such that \$z_1 \\mapsto w_1\$,
  \$z_2 \\mapsto w_2\$ and \$z_3 \\mapsto w_3\$.
"""
function MobiusTransformation(z1::Number, z2::Number, z3::Number,
  w1::Number, w2::Number, w3::Number)
  f = maptozerooneinf(z1,z2,z3)
  g = mapfromzerooneinf(w1,w2,w3)
  g∘f
end



#=
function (f::MobiusTransformation)(c::CLine)
  CLine(
   abs2(f.d) * c.A - 2 * real( conj(f.c) * f.d * c.B ) + abs2(f.c) * c.C,
   conj(f.a) * (f.d * c.B - f.c * c.C) - conj(f.b) * (f.c * conj(c.B) - f.d * c.A),
   abs2(f.b) * c.A - 2 * real( conj(f.a) * f.b * c.B ) + abs2(f.a) * c.C
  )
end

# ToDO: Methods!!!
=#

"""
Given a Möbius transformation \$f(z)=\\frac{az+b}{cz+d}\$ and a circle
\$C: |center-z|=radius\$, the circle  \$f(C)\$ has center

\$ w = f(center - \\frac{radius^2}{\\overline{\\frac{d}{c}+center}})\$

and radius

\$|w - f(center+radius)|\$.
"""
function (f::MobiusTransformation)(c::Circle)
  if f.c ≈ 0.0
    return Circle( f(c.center), abs(f.a/f.d)*c.radius )
  elseif abs(c.center + f.d/f.c) ≈ c.radius
    z = c.center + f.d/f.c
    w1 = f(c.center + z)
    w2 = f(c.center + im*z)
    return Line(w1, angle(w1-w2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - c.radius*c.radius/conj(f.d/f.c + c.center)
  fz = f(z)
  Circle(fz, abs(fz - f(c.center + c.radius)))
end

function (f::LinearTransformation)(c::Circle)
  Circle( f(c.center), abs(f.a)*c.radius )
end

function (f::Translation)(c::Circle)
  Circle( f(c.center), c.radius )
end

function (f::AffineTransformation)(c::Circle)
  Circle( f(c.center), abs(f.a)*c.radius )
end

function (f::InversionReflection)(c::Circle)
  if abs(c.center) ≈ c.radius
    w1 = f(2*c.center)
    w2 = f(c.center + im*c.center)
    return Line(w1, angle(w1-w2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - c.radius*c.radius/conj(c.center)
  fz = f(z)
  Circle(fz, abs(fz - f(c.center + c.radius)))
end


function (f::MobiusTransformation)(c::Arc)
  if f.c ≈ 0
    return Arc( f(c.center), f(c.p1), f(c.p2) )
  elseif abs(c.center + f.d/f.c) ≈ radius(c)
    #ToDo!: Case 2 rays!
    return LineSegment(f(c.p1), f(c.p2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - radius2(c)/conj(f.d/f.c + c.center)
  Arc(f(z), f(c.p1), f(c.p2))
end

function (f::LinearTransformation)(c::Arc)
  Arc(f(c.center), f(c.p1), f(c.p2))
end

function (f::Translation)(c::Arc)
  Arc(f(c.center), f(c.p1), f(c.p2))
end

function (f::AffineTransformation)(c::Arc)
  Arc(f(c.center), f(c.p1), f(c.p2))
end

function (f::InversionReflection)(c::Arc)
  if abs(c.center) ≈ c.radius
    #ToDo!: Case 2 rays!
    return LineSegment(f(c.p1), f(c.p2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - radius2(c)/conj(c.center)
  Arc(f(z), f(c.p1), f(c.p2))
end


function (f::MobiusTransformation)(l::Line)
  if f.c ≈ 0.0 # f is Affine
    w1 = f(l.base)
    return Line( w1, angle(w1 - f(l.base + complexU(l.a))) )
  elseif l.base ≈ -f.d/f.c # f(l) through infinity, then is a line
    w = f(Inf)
    return Line(w, angle(w - f(Inf)))
  else
    a = angle(l.base + f.d/f.c)
    if a ≈ l.a || a ≈ (l.a + pi) # f(l) through infinity, then is a line
      w = f(l.base)
      return Line(w, angle(w - f(Inf)))
    end
  end

  # General case, f(l) is a circle

  # Decomposing f in simplier transformations

  # Apply z -> z + d/c
  q = 1.0/(nearestpoint(0, Line(l.base + f.d/f.c, l.a)))
  center = q/2 #conj(q/2) # Applied z -> 1/z
  radius = abs(center) # Applied z -> 1/z

  A = (f.b*f.c - f.a*f.d)/(f.c^2)
  #B = f.a/f.c
  Circle( A*center + f.a/f.c, abs(A)*radius ) # Apply z -> Az+B
end

function (f::LinearTransformation)(l::Line)
  Line(f(l.base), l.a + angle(f.a))
end

function (f::Translation)(l::Line)
  Line(f(l.base), l.a)
end

function (f::AffineTransformation)(l::Line)
  Line(f(l.base), l.a + angle(f.a))
end

function (f::InversionReflection)(l::Line)
  if l.base ≈ 0
    return Line(l.base, l.a + angle(f.b))
  else
    a = angle(l.base)
    if a ≈ l.a || a ≈ (l.a + pi)
      return Line(l.base, l.a + angle(f.b))
    end
  end

  # General case, f(l) is a circle

  # Decomposing f in simplier transformations

  q = 1.0/(nearestpoint(0, l))
  center = q/2 #conj(q/2) # Applied z -> 1/z
  radius = abs(center) # Applied z -> 1/z

  Circle( f.b*center, abs(f.b)*radius ) # Apply z -> bz
end


function (f::MobiusTransformation)(l::LineSegment)
  if f.c ≈ 0.0
    return LineSegment( f(l.p1), f(l.p2) )
  elseif l.p1 ≈ -f.d/f.c
    # ToDo! Ray
  elseif l.p2 ≈ -f.d/f.c
    # ToDo! Ray
  else
    # ToDo! Two Rays!
    # ToDo! Line Segment!
  end

  w1 = f(l.z1)
  w2 = f(l.z2)
  w3 = f((l.z1+l.z2)/2)
  Arc(circumcenter(w1,w2,w3), w1, w2)
end

function (f::AbstractAffineTransformation)(l::LineSegment)
  LineSegment(f(l.p1), f(l.p2))
end

function (f::InversionReflection)(l::LineSegment)
  if l.p1 ≈ 0
    # ToDo! Ray
  elseif l.p2 ≈ 0
    # ToDo! Ray
  else
    # ToDo! Two Rays!
    # ToDo! Line Segment!
  end

  w1 = f(l.z1)
  w2 = f(l.z2)
  w3 = f((l.z1+l.z2)/2)
  Arc(circumcenter(w1,w2,w3), w1, w2)
end


function (f::AbstractComplexInvertibleFunction)(a::Array)
  f.(a)
end
