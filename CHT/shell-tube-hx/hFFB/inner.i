[Mesh]
    type = FoamMesh
    case = 'fluid-inner-openfoam'
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
    [fluid_htc]
        type = FoamHeatTransferCoeff
        bulk_temperature_uo = bulk_t
        boundary = interface
    []
[]

[UserObjects]
    [bulk_t]
        type = AdjacentCellBulkTemperature
        boundary = interface
        execute_on = 'initial timestep_end'
    []
[]


[Problem]
    type = FoamProblem
[]

[Executioner]
    type = Transient
    start_time = 0
    end_time = 500
    dt = 1.

    [TimeSteppers]
        [foam]
            type = FoamTimeStepper
        []
    []
[]

[Outputs]
    exodus = false
[]
