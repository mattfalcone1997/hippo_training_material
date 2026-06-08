[Mesh]
    type = FoamMesh
    case = 'fluid-openfoam'
    foam_patch = 'interface'
[]

[Variables]
    [dummy]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 999
    []
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
    # end_time = 10
    end_time = 300
    dt = 1.

    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'

    [TimeSteppers]
        [foam]
            type = FoamTimeStepper
        []
    []
[]

[Outputs]
    exodus = true
[]
