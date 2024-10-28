mu = 1
rho = 1
velocity_interp_method = 'rc'
advected_interp_method = 'average'

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [./rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    pressure = pressure
  [../]
[]

[Mesh]
    [./gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 0.1   # 10 cm in meters
    ymin = 0
    ymax = 0.1   # 10 cm in meters
    nx = 100
    ny = 100
    [../]
[]

[Variables]
  [./vel_x]
    type = INSFVVelocityVariable
  [../]
  [./vel_y]
    type = INSFVVelocityVariable
  [../]
  [./pressure]
    type = INSFVPressureVariable
  [../]
  [./lambda]
    family = SCALAR
    order = FIRST
  [../]
[]

[FVKernels]
  [./mass]
    type = INSFVMassAdvection # ∇·u = 0
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  [../]
  [./u_time]
      type = INSFVMomentumTimeDerivative
      variable = vel_x
      rho = ${rho}
      momentum_component = 'x'
  [../]
  [./mean_zero_pressure] # ∫p dΩ = 0
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  [../]
  [./u_advection] # ρ(u·∇)u
    type = INSFVMomentumAdvection
    variable = vel_x
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  [../]
  [./u_viscosity] # μ∇²u
    type = INSFVMomentumDiffusion
    variable = vel_x
    mu = ${mu}
    momentum_component = 'x'
  [../]
  [./u_pressure] # -∂p/∂x
    type = INSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
    pressure = pressure
  [../]
  [./v_time]
      type = INSFVMomentumTimeDerivative
      variable = vel_y
      rho = ${rho}
      momentum_component = 'y'
  [../]
  [./v_advection] # ρ(u·∇)v
    type = INSFVMomentumAdvection
    variable = vel_y
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  [../]
  [./v_viscosity] # μ∇²v
    type = INSFVMomentumDiffusion
    variable = vel_y
    mu = ${mu}
    momentum_component = 'y'
  [../]
  [./v_pressure] # -∂p/∂y
    type = INSFVMomentumPressure
    variable = vel_y
    momentum_component = 'y'
    pressure = pressure
  [../]
[]

[FVBCs]
  # Moving lid with a parabolic velocity profile in the x-direction
  [./top_x]
    type = INSFVInletVelocityBC
    variable = vel_x
    boundary = 'top'
    function = 'lid_function'
  [../]

  # No-slip boundary conditions for vel_x on other walls
  [./no_slip_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'left right bottom'
    function = 0
  [../]

  # No-slip boundary conditions for vel_y on all walls
  [./no_slip_y]
    type = INSFVNoSlipWallBC
    variable = vel_y
    boundary = 'left right top bottom'
    function = 0
  [../]
[]

[Functions]
  [./lid_function]
    type = ParsedFunction
    expression = '4*x*(1-x)'
  [../]
[]

# [Executioner]
#   type = Steady
#   solve_type = 'NEWTON'
#   petsc_options_iname = '-pc_type -pc_factor_shift_type'
#   petsc_options_value = 'lu NONZERO'
#   nl_rel_tol = 1e-12
# []

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  nl_max_its = 10
  end_time = 15
  dtmax = 2e-2
  dtmin = 1e-5
  scheme = 'bdf2'
  
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
    optimal_iterations = 6
    growth_factor = 1.5
  [../]
[../]


# [Outputs]
#   exodus = true
# []

[Outputs]
  [exodus]
    type = Exodus
    output_material_properties = true
    show_material_properties = 'mu'
  []
  checkpoint = true
  perf_graph = true
[]
