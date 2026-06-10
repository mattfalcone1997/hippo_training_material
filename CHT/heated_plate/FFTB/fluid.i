[Mesh]
    type = FoamMesh
    case = 'fluid-openfoam'
    foam_patch = 'interface'
[]

[FoamBCs]
    [solid_wall_temp]
        type = FoamFixedValueBC
        foam_variable = T
        initial_condition = 300
    []
[]

[FoamVariables]
    [fluid_heat_flux]
        type = FoamFunctionObject
        foam_variable = "wallHeatFlux"
        initial_condition = 0
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
    # end_time = 50
    # dt = 0.1

    [TimeSteppers]
        [foam]
            type = FoamTimeStepper
        []
    []
[]

[Outputs]
    exodus = true
[]
