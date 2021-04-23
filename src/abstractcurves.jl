
abstract type AbstractCurve2D end
abstract type AbstractCircularLinearCurve <: AbstractCurve2D end
abstract type AbstractCircularCurve <: AbstractCircularLinearCurve end
abstract type AbstractLinearCurve <: AbstractCircularLinearCurve end
