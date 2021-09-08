{ lib, ... }:

let
  inherit (lib) mkOption types;
in

rec {

  /* Create an Option attribute set with the specified default value and type.

     Type: mkOpt :: a -> Type -> Option

     Example:
       mkOpt "foo" lib.types.str
       // => { _type = "option"; default = "foo"; type = { ... }; }
  */
  mkOpt = default: type:
    mkOption { inherit default type; };

  /* Like `mkOpt` but accept also a description.

     Type: mkOpt' :: a -> String -> Type -> Option

     Example:
       mkOpt' "foo" "The value of bar." lib.types.str
       // => { _type = "option"; default = "foo"; description = "The value of bar."; type = { ... }; }
  */
  mkOpt' = default: description: type:
    mkOption { inherit default description type; };

  /* Create a boolean Option attribute set with the specified default value.

     Type: mkBoolOpt :: Bool -> Option

     Example:
       mkBoolOpt false // => { _type = "option"; default = false; example = true; type = { ... }; }
  */
  mkBoolOpt = default: mkOption {
    inherit default;
    example = true;
    type = types.bool;
  };

}
