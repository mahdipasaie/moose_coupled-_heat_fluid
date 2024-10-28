#include "hfApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
hfApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

hfApp::hfApp(InputParameters parameters) : MooseApp(parameters)
{
  hfApp::registerAll(_factory, _action_factory, _syntax);
}

hfApp::~hfApp() {}

void
hfApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<hfApp>(f, af, s);
  Registry::registerObjectsTo(f, {"hfApp"});
  Registry::registerActionsTo(af, {"hfApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
hfApp::registerApps()
{
  registerApp(hfApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
hfApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hfApp::registerAll(f, af, s);
}
extern "C" void
hfApp__registerApps()
{
  hfApp::registerApps();
}
