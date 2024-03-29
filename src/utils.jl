
"""
    dot(x1,y1,x2,y2) -> Real

Calculate the dot product between two vectors.
"""
dot(x1::Real, y1::Real, x2::Real, y2::Real) = x1*x2 + y1*y2

"""
    dot(z1,z2) -> Real

Calculate the dot product between two complex number (like 2D vectors).
"""
dot(z1::Number, z2::Number) = real(z1)*real(z2) + imag(z1)*imag(z2)


"""
    perp(x,y) -> Tuple{Real,Real}

Return the pependicular vector to \$(x,y)\$.
"""
perp(x::Real, y::Real) = -y, x

"""
    perp(p) -> SVector

Return the pependicular vector to \$(x,y)\$.
"""
perp(p::AbstractVector{<:Real}) = [-y, x]

"""
    perp(z) -> Complex

Return the pependicular complex number to \$z\$.
"""
perp(z::Number) = complex(-imag(z), real(z))


"""

\$ ||(x_1,y_1,z_1)\\times (x_2,y_2,z_2)|| \$
"""
tripledet(x1::Real, y1::Real, x2::Real, y2::Real, x3::Real, y3::Real) =
  x1*(y2-y3)-y1*(x2-x3)+x2*y3-y2*y3 # ???

"""
"""
tripledet(z1::Number, z2::Number, z3::Number) =
  tripledet(real(z1), imag(z1), real(z2), imag(z2), real(z3), imag(z3))

#=
ToDo!
circumcenter
circumradius
=#


"""
    complexU(θ::Real) -> Complex

Create an unitarian complex number with argument \$\\theta\$.
"""
complexU(θ::Real) = complex(cos(θ),sin(θ))

"""
    complexpolar(r::Real, θ::Real) -> Complex

Create complex number with modulus \$r\$ and argument \$\\theta\$.
"""
complexpolar(r::Real, θ::Real) = complex(r*cos(θ),r*sin(θ))
