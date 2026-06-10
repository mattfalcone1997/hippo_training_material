T_in = 300
D = 0.05
A = ${fparse pi*0.25*D*D}
press = 101325

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

[ControlLogic]
  [mdot_inlet]
    type = SetComponentRealValueControl
    component = inlet
    parameter = m_dot
    value = mdot_inlt
  []
[]

[Postprocessors]
  [mdot_inlt]
    type = ParsedPostprocessor
    expression = 'if(t<0.6, 3.92, if(t<0.8, 3.92+19.6*(t-0.6), 7.84))'
    use_t = true
    execute_on = "INITIAL TIMESTEP_BEGIN"
  []
[]

[Components]
    [inlet]
        type = InletMassFlowRateTemperature1Phase
        T = 300
        m_dot = 3.92
        input = pipe1:in
    []
    [pipe1]
        type = FlowChannel1Phase
        position = '0 0 -1'
        orientation = '0 0 1'
        length = 3
        n_elems = 100
        A = ${A}
        D_h = ${D}
    []
    [outlet]
        type =Outlet1Phase
        input = pipe1:out
        p = ${press}
    []
[]

[Closures] # defines friction factors and heat transfer coefficients
  [thm_closures]
    type = Closures1PhaseTHM # default Churchill friction factor, DB HTC
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
  end_time = 1.

  line_search = basic
  solve_type = NEWTON

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 25

[]

[Outputs]
  csv=true
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
