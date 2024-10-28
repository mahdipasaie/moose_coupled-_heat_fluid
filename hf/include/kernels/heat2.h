#pragma once
#include "ADTimeKernelValue.h"

class heat2 : public ADTimeKernelValue
{
public:
  static InputParameters validParams();

  heat2(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;
  private:

  const Real _rho;
  const Real _cp;

};