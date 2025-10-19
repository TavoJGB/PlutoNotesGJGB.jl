module GJGB_Notes

    # Packages
    using HypertextLiteral: @htl, @htl_str # necesario para cita()
    using Markdown
    using Parameters

    # Load dependencies
    include("./dep/Structs.jl")
    export Español, English, Français, Ejercicio
    include("./dep/Aux_Functions.jl")
    export cita, resaltar, enlace, corregir
    export concepto, peligro, atencion, truco, recuerdo
    
end
