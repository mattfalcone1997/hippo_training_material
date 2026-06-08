T_in = 300
D = 0.05
A = ${fparse pi*0.25*D*D}
press = 101325

[ControlLogic]
  [T_inlet]
    type = SetComponentRealValueControl
    component = inlet
    parameter = T
    value = T_inlet
  []
[]

[Postprocessors]
  [T_inlet]
    type = ParsedPostprocessor
    expression = 'if(t<0.1, 300, if(t<0.2, 300+500*t, 350))'
    use_t = true
    execute_on = "INITIAL TIMESTEP_BEGIN"
  []
[]

[GlobalParams]
  initial_p = ${press}
  initial_vel = 2
  initial_T = ${T_in}
  closures = thm_closures
  fp = water
  gravity_vector = '0 -9.81 0'
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    density0 = 1065
  []
[]

[Closures] # defines friction factors and heat transfer coefficients
  [thm_closures]
    type = Closures1PhaseTHM # default Churchill friction factor, DB HTC
  []
[]

[Components]
    [inlet]
        type = InletMassFlowRateTemperature1Phase
        T = ${T_in}
        m_dot = 3.92
        input = pipe1:in
    []
    [pipe1]
        type = FlowChannel1Phase
        position = '0 0 -1'
        orientation = '0 0 1'
        length = 3
        n_elems = 300
        A = ${A}
        D_h = ${D}
    []
    [outlet]
        type =Outlet1Phase
        input = pipe1:out
        p = ${press}
    []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  start_time = 0

  dt = 0.01
  end_time = 1.6

  line_search = basic
  solve_type = NEWTON

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 25

[]

[Outputs]
  [out]
    type = Exodus
    min_simulation_time_interval = 0.01
  []

  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
