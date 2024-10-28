#include "heat1.h"

registerMooseObject("hfApp", heat1);

InputParameters
heat1::validParams()
{
    InputParameters params = ADKernelGrad::validParams();
    params.addParam<Real>("thermal_conductivity", 0.026, "thermal_conductivity");
    params.set<bool>("use_displaced_mesh") = true;
    return params;
}

heat1::heat1(const InputParameters & parameters)
  : ADKernelGrad(parameters),
    _tc(getParam<Real>("thermal_conductivity"))
{
}

ADRealGradient
heat1::precomputeQpResidual()
{
  return _tc * _grad_u[_qp];
}

