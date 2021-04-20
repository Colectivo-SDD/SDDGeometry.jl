
import Base: show, ∘

abstract type AbstractMobiusTransformation{T} end

"""
    MobiusTransformation(a,b,c,d)

Möbius transformation, a conformal automorphism in the Riemann sphere
\$z \\mapsto \\frac{az+b}{cz+d}\$
with \$ad-bc\\neq 0\$.
"""
struct MobiusTransformation{T <: Number} <: AbstractMobiusTransformation{T}
  a::T
  b::T
  c::T
  d::T

  function MobiusTransformation{T}(a0::T, b0::T, c0::T, d0::T) where T <: Number
    #@assert a0 * d0 - b0 * c0 != 0 "Invalid parameters for Möbius transformation."
    new(a0,b0,c0,d0)
  end

end

MobiusTransformation(a0::T, b0::T, c0::T, d0::T) where {T <: Number} = MobiusTransformation{T}(a0,b0,c0,d0)

MobiusTransformation(a0::Number, b0::Number, c0::Number, d0::Number) = MobiusTransformation(promote(a0,b0,c0,d0)...)


"""
    LinearTransformation(a)

Linear transformation (homotecy and rotation) in the Riemann sphere
\$z \\mapsto a z\$.
"""
struct LinearTransformation{T <: Number} <: AbstractMobiusTransformation{T}
  a::T

  function LinearMobiusTransformation{T}(a0::T) where T <:Number
    #@assert a0 == 0 "Invalid parameters for Möbius transformation."
    new(a0)
  end

end

LinearTransformation(a0::T) where {T <: Number} = LinearTransformation{T}(a0)

MobiusTransformation(a0::T) where {T <: Number} = LinearTransformation{T}(a0)


"""
    Translation(b)

Translation in the Riemann sphere
\$z \\mapsto z + b\$.
"""
struct Translation{T <: Number} <: AbstractMobiusTransformation{T}
  b::T

  function Translation{T}(b0::T) where T <:Number
    new(b0)
  end
end

Translation(b0::T) where {T <: Number} = Translation{T}(b0)


"""
    AffineTransformation(a,b)

Affine transformation in the Riemann sphere
\$z \\mapsto a z + b\$.
"""
struct AffineTransformation{T <: Number} <: AbstractMobiusTransformation{T}
  a::T
  b::T

  function AffineTransformation{T}(a0::T, b0::T) where T <:Number
    new(a0,b0)
  end

end

AffineTransformation(a0::T, b0::T) where {T <: Number} = AffineTransformation{T}(a0,b0)

AffineTransformation(a0::Number, b0::Number) = AffineTransformation(promote(a0,b0)...)

MobiusTransformation(a0::T, b0::T) where {T <: Number} = AffineTransformation{T}(a0,b0)

MobiusTransformation(a0::Number, b0::Number) = AffineTransformation(promote(a0,b0)...)


"""
    InversionReflection(b)

Inversion reflection in the Riemann sphere
\$z \\mapsto \\frac{b}{z}\$.
"""
struct InversionReflection{T <: Number} <: AbstractMobiusTransformation{T}
  b::T

  function InversionReflection{T}(b0::T) where T <:Number
    new(b0)
  end

end

InversionReflection(b0::T) where {T <: Number} = InversionReflection{T}(b0)


show(io::IO, f::MobiusTransformation) =
  print(io, "Möbius Transformation: z -> ((", f.a, ")z + (", f.b, ")) / ((", f.c, ")z + (", f.d, "))")

show(io::IO, f::LinearTransformation) =
  print(io, "Linear Transformation: z -> (", f.a, ")z")

show(io::IO, f::Translation) =
  print(io, "Translation: z -> z + (", f.b, ")")

show(io::IO, f::AffineTransformationAB) =
  print(io, "Affine Transformation: z -> (", f.a, ")z + (", f.b, ")")

show(io::IO, f::InversionReflection) =
  print(io, "Inversion Reflection: z -> (", f.b, ") / z")


function (f::MobiusTransformation)(z::Number)
  # ToDo! Create a method to eval infinity case
  if isinf(z)
    return f.a / f.c
  end

  (f.a * z + f.b) / (f.c * z + f.d)
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
function derivative(f::MobiusTransformation)
  function der(z::Number)
    (f.a * f.d - f.b * f.c) / ((f.c * z + f.d)^2)
  end
end

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
  if f.c == 0
    return f.b / (f.d - f.a), Inf
  end
  discr = (f.a + f.d)^2 - 4 * (f.a * f.d - f.b * f.c)
  rd = discr < 0 ? sqrt(complex(discr)) : sqrt(discr)
  (f.a - f.d + rd)/(2*f.c), (f.a - f.d - rd)/(2*f.c)
end

function fixedpoints(f::MobiusTransformation)
  if f.c == 0
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
  if f.a == 1
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
  t = tr(f) / det(f)
  t2 = t^2
  if imag(t2) ≈ 0
    if t2 == 4
      return :parabolic
    end

    if 0 <= t2 < 4
      return :elliptic
    end

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
  InversionReflection(f.b / g.b)


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
# result in a MobiusTransformation, fall back to AbstractMobiusTransformation implementation


"""
Binary operator to compose two Möbius transformations.
"""
∘(f::AbstractMobiusTransformation, g::AbstractMobiusTransformation) = compose(f,g)



"""
    maptozerooneinf(z1,z2,z3)

Create the Möbius transformation such that \$z_1 \\mapsto 0\$,
\$z_2 \\mapsto 1\$ and \$z_3 \\mapsto \\infty\$.
"""
maptozerooneinf(z1::Number, z2::Number, z3::Number) =
  MobiusTransformation(z2-z3, z1*(z3-z2), z2-z1, z3*(z1-z2))

"""
    mapfromzerooneinf(z1,z2,z3)

Create the Möbius transformation such that \$0 \\mapsto z_1\$,
  \$1 \\mapsto z_2\$ and \$\\infty \\mapsto z_3\$.
"""
mapfromzerooneinf(z1::Number, z2::Number, z3::Number) =
  MobiusTransformation(z3*(z1-z2), z1*(z2-z3), z1-z2, z2-z3)

"""
Create the Möbius transformation such that \$z_1 \\mapsto w_1\$,
  \$z_2 \\mapsto w_2\$ and \$z_3 \\mapsto w_3\$.
"""
function MobiusTransformation(z1::Number, z2::Number, z3::Number,
  w1::Number, w2::Number, w3::Number)
  f = mapstoonezeroinf(z1,z2,z3)
  g = mapsfromzerooneinf(w1,w2,w3)
  g∘f
end



function (f::MobiusTransformation)(c::CLine)
  CLine(
   abs2(f.d) * c.A - 2 * real( conj(f.c) * f.d * c.B ) + abs2(f.c) * c.C,
   conj(f.a) * (f.d * c.B - f.c * c.C) - conj(f.b) * (f.c * conj(c.B) - f.d * c.A),
   abs2(f.b) * c.A - 2 * real( conj(f.a) * f.b * c.B ) + abs2(f.a) * c.C
  )
end

# ToDO: Methods!!!


"""
Given a Möbius transformation \$f(z)=\\frac{az+b}{cz+d}\$ and a circle
\$C: |center-z|=radius\$, the circle  \$f(C)\$ has center

\$ w = f(center - \\frac{radius^2}{\\overline{\\frac{d}{c}+center}})

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
  Circle(f(z), abs(z - f(c.center + c.radius)))
end
#cline = f( toCLine(c) )
#if cline.A == 0
#  return cline
#end
#toCircle( cline )

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
  Circle(f(z), abs(z - f(c.center + c.radius)))
end


function (f::MobiusTransformation)(c::CircularArc)
  if f.c ≈ 0.0
    return CircularArc( f(c.center), f(c.p1), f(c.p2) )
  elseif abs(c.center + f.d/f.c) ≈ radius(c)
    #ToDo!: Case 2 rays!
    return LineSegment(f(c.p1), f(c.p2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - radius2(c)/conj(f.d/f.c + c.center)
  CircularArc(f(z), f(c.p1), f(c.p2))
end

function (f::LinearTransformation)(c::CircularArc)
  CircularArc(f(c.center), f(c.p1), f(c.p2))
end

function (f::Translation)(c::CircularArc)
  CircularArc(f(c.center), f(c.p1), f(c.p2))
end

function (f::AffineTransformation)(c::CircularArc)
  CircularArc(f(c.center), f(c.p1), f(c.p2))
end

function (f::InversionReflection)(c::CircularArc)
  if abs(c.center) ≈ c.radius
    #ToDo!: Case 2 rays!
    return LineSegment(f(c.p1), f(c.p2))
  end

  # "Grandma's recipe" from "Indra's Pearls" to calculate image of a circle
  z = c.center - radius2(c)/conj(c.center)
  CircularArc(f(z), f(c.p1), f(c.p2))
end


function (f::MobiusTransformation)(l::Line)
  if f.c ≈ 0.0
    w1 = f(l.base)
    return Line( w1, angle(w1-f(l.base+exp(l.angle*im))) )
  elseif l.base ≈ -f.d/f.c
    w = f(Inf)
    return Line(w, angle(w-f(Inf)))
  else
    a = angle(l.base + f.d/f.c)
    if a ≈ l.angle || a ≈ (l.angle + pi)
      w = f(l.base)
      return Line(w, angle(w-f(Inf)))
    end
  end

  v = exp(im*l.angle)
  w1 = f(l.base)
  w2 = f(l.base + v)
  w3 = f(l.base - v)
  Circle(circumcenter(w1,w2,w3), circumradius(w1,w2,w3))
end

function (f::LinearTransformation)(l::Line)
  Line(f(l.base), l.angle + angle(f.a))
end

function (f::Translation)(l::Line)
  Line(f(l.base), l.angle)
end

function (f::AffineTransformation)(l::Line)
  Line(f(l.base), l.angle + angle(f.a))
end

function (f::InversionReflection)(l::Line)
  if l.base ≈ 0
    return Line(l.base, l.angle + angle(f.b))
  else
    a = angle(l.base)
    if a ≈ l.angle || a ≈ (l.angle + pi)
      return Line(l.base, l.angle + angle(f.b))
    end
  end

  v = exp(im*l.angle)
  w1 = f(l.base)
  w2 = f(l.base + v)
  w3 = f(l.base - v)
  Circle(circumcenter(w1,w2,w3), circumradius(w1,w2,w3))
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
  CircularArc(circumcenter(w1,w2,w3), w1, w2)
end

function (f::LinearTransformation)(l::LineSegment)
  LineSegment(f(l.p1), f(l.p2))
end

function (f::Translation)(l::LineSegment)
  LineSegment(f(l.p1), f(l.p2))
end

function (f::AffineTransformation)(l::LineSegment)
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
  CircularArc(circumcenter(w1,w2,w3), w1, w2)
end