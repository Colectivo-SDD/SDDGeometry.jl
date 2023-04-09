
"""
Euclidean distance between two points in \$\\mathbb{R}^2\$ (or \$\\mathbb{C}\$):

\$d((x_1,y_1),(x_2,y_2))=\\sqrt{(x_1-x_2)^2 + (y_1-y_2)^2}\$

\$d(z_1,z_2)=|z_1-z_2|\$

"""
euclideandistance2D(p1, p2) = sqrt((_x(p1)-_x(p2))^2 + (_y(p1)-_y(p2))^2)

"""
Euclidean distance between two points in \$\\mathbb{R}^3\$:

\$d((x_1,y_1,z_1),(x_2,y_2,z_2))=\\sqrt{(x_1-x_2)^2 + (y_1-y_2)^2  + (z_1-z_2)^2}\$

"""
euclideandistance3D(p1::AbstractVector{<:Real}, p2::AbstractVector{<:Real}) =
  sqrt((x_(p1)-_x(p2))^2 + (_y(p1)-_y(p2))^2  + (_z(p1)-_z(p2))^2)
    

"""
Manhattan distance between two points in \$\\mathbb{R}^2\$ (or \$\\mathbb{C}\$):

\$d_{manhattan}((x_1,y_1),(x_2,y_2))=|x_1-x_2|+|y_1-y_2|\$

"""
manhattandistance2D(p1, p2) = abs(_x(p1)-_x(p2)) + abs(_y(p1)-_y(p2))

"""
Manhattan distance between two points in \$\\mathbb{R}^3\$:

\$d_{manhattan}((x_1,y_1,z_1),(x_2,y_2,z_2))=|x_1-x_2|+|y_1-y_2|+|z_1-z_2|\$

"""
manhattandistance3D(p1::AbstractVector{<:Real}, p2::AbstractVector{<:Real}) =
  abs(_x(p1)-_x(p2)) + abs(_y(p1)-_y(p2)) + abs(_z(p1)-_z(p2))


"""
Max distance between two points in \$\\mathbb{R}^2\$ (or \$\\mathbb{C}\$):

\$d_{max}((x_1,y_1),(x_2,y_2))=\\max\\{|x_1-x_2|,|y_1-y_2|\\}\$

"""
maxdistance2D(p1, p2) = max(abs(_x(p1)-_x(p2)), abs(_y(p1)-_y(p2)))

"""
Max distance between two points in \$\\mathbb{R}^3\$:

\$d_{max}((x_1,y_1,z_1),(x_2,y_2,z_2))=\\max\\{|x_1-x_2|,|y_1-y_2|,|z_1-z_2|\\}\$

"""
maxdistance3D(p1::AbstractVector{<:Real}, p2::AbstractVector{<:Real}) =
    max(abs(p1[1]-p2[1]), abs(p1[2]-p2[2]), abs(p1[3]-p2[3]))
