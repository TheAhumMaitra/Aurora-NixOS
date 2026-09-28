{ lib }:

let
  fallbackUsername = "aurora";

  passwdFiles = [
    "/mnt/etc/passwd"
    "/etc/passwd"
  ];

  # Split a passwd line into its fields, dropping anything that is not a
  # well-formed entry (blank lines, comments, malformed lines).
  parseLine =
    line:
    let
      fields = lib.splitString ":" line;
      uidField = if builtins.length fields == 7 then lib.elemAt fields 2 else null;
    in
    if uidField != null && lib.match "^[0-9]+$" uidField != null then
      {
        name = lib.elemAt fields 0;
        uid = lib.toInt uidField;
        home = lib.elemAt fields 5;
        shell = lib.elemAt fields 6;
      }
    else
      null;

  accountsFrom = path: lib.filterMap parseLine (lib.splitString "\n" (builtins.readFile path));

  isLoginAccount =
    account:
    account.uid >= 1000
    && account.uid < 65534
    && lib.hasPrefix "/home" account.home
    && !(lib.elem (lib.getBaseNameOf account.shell) [
      "false"
      "nologin"
      "sync"
      "shutdown"
      "halt"
    ]);

  loginAccounts = lib.filter isLoginAccount (
    lib.concatMap accountsFrom (lib.filter builtins.pathExists passwdFiles)
  );

  loginNames = lib.unique (map (account: account.name) loginAccounts);

  username = if loginNames == [ ] then fallbackUsername else lib.head loginNames;
in
{
  inherit username;
}
