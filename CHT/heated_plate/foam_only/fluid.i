[Mesh]
    type = FoamMesh
    case = 'fluid-openfoam'
    foam_patch = 'interface'
[]

[Problem]
    type = FoamProblem
[]

[Executioner]
    type = Transient
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
