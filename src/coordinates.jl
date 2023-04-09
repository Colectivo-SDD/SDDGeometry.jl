
_x(p::AbstractVector{<:Real}) = p[1]
_y(p::AbstractVector{<:Real}) = p[2]
_z(p::AbstractVector{<:Real}) = p[3]

_t(p::AbstractVector{<:Real}) = p[3]

_x(z::Number) = real(z)
_y(z::Number) = imag(z)

_angle(p::AbstractVector{<:Real}) = angle(complex(_x(p),_y(p)))
_angle(z::Number) = angle(z)

_radius(p::AbstractVector{<:Real}) = sqrt(_x(p)^2 + _y(p)^2)
_radius(z::Number) = abs(z)

_radius2(p::AbstractVector{<:Real}) = _x(p)^2 + _y(p)^2
_radius2(z::Number) = abs2(z)
