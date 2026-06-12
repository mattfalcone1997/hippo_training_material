[Mesh]
    type = FoamMesh
    case = 'fluid-openfoam'
    foam_patch = 'interface'
[]

[FoamBCs]
    [solid_heat_flux]
        type = FoamDiffusionFluxBC
        foam_variable = T
        initial_condition = 0
    []
[]

[FoamVariables]
    [fluid_wall_temp]
        type = FoamVariableField
        foam_variable = T
        initial_condition = 300
    []
[]

[Problem]
    type = FoamProblem
[]

[Executioner]
    type = Transient
    start_time = 0
    end_time = 10
    dt = 0.025

    [TimeSteppers]
        [foam]
            type = FoamTimeStepper
        []
    []
[]

[Outputs]
    exodus = true
[]
