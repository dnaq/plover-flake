{ ruamel-yaml, prompt-toolkit, pysdl2, setuptools-scm, utils }:
self: super: {
  plover_yaml_dictionary = super.plover_yaml_dictionary.overrideAttrs (old: {
    propagatedBuildInputs = [ ruamel-yaml ];
  });
  plover_console_ui = super.plover_console_ui.overrideAttrs (old: {
    propagatedBuildInputs = [ prompt-toolkit ];
    doCheck = false;
    doInstallCheck = false;
  });
  plover-controller = super.plover-controller.overrideAttrs (old: {
    propagatedBuildInputs = [ pysdl2 ];
    doCheck = false;
    doInstallCheck = false;
  });
  plover_dict_commands = super.plover_dict_commands.overrideAttrs (old: {
    propagatedBuildInputs = [ setuptools-scm ];
  });
  plover_lapwing_aio = super.plover_lapwing_aio.overrideAttrs (old: {
    propagatedBuildInputs = [
      self.plover_stitching
      self.plover_python_dictionary
      self.plover-modal-dictionary
      self.plover_last_translation
      self.plover_dict_commands
    ];
  });
}
