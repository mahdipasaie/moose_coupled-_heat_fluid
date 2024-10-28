#pragma once
#include "ADKernelGrad.h"


class heat1 : public ADKernelGrad
{
public:
  static InputParameters validParams();

  heat1(const InputParameters & parameters);

protected:
  ADRealGradient precomputeQpResidual() override;
  const Real _tc;
};