# TODO lid handling + battery conservation
{
 services.logind.settings.Login = {
    HandlelidSwitch = "suspend";
    HandlelidSwitchExternalPower = "ignore";
  };
}
