{ lib, ... }:

with builtins;
with lib;

{

  /* Do the inverse of builtins.listToAttrs.

     Type: attrsToList :: AttrSet -> [ { name :: String; value :: a; } ]

     Example:
       attrsToList { x = "a"; y = 2; }
       // => [ { name = "x"; value = "a"; } { name = "y"; value = 2; } ]
  */
  attrsToList = set:
    mapAttrsToList (name: value: { inherit name value; }) set;

  /* Apply mapAttrs' with a function f to change attribute names and values of
     set. Then apply filterAttrs to the resulting set to filter out the
     attributes for which the predicate pred return false.

     Type: mapFilterAttrs ::
             (String -> a -> Bool)
             -> (String -> a -> { name :: String; value :: a; })
             -> AttrSet -> AttrSet

     Example:
       mapFilterAttrs
         (n: v:
           n == "foo_x")
         (n: v:
           nameValuePair ("foo_" + n) ("bar-" + v))
         { x = "a"; y = "b"; }
       // => { foo_x = "bar-a"; }

       mapFilterAttrs
         (n: v:
           n == "foo_y")
         (n: v:
           nameValuePair ("foo_" + n) (10 + v))
         { x = 1; y = 2; }
       // => { foo_y = 12; }
  */
  mapFilterAttrs = pred: f: set: filterAttrs pred (mapAttrs' f set);

  /* Generate an attribute set by mapping a function over a list.

     Type: genAttrs' :: [a] -> (a -> { name :: String; value :: b; }) -> AttrSet

     Example:
       genAttrs' [ "a" "b" "c" ] (x: nameValuePair (toString x) ("foo-" + x))
       // => { "a" = "foo-a"; "b" = "foo-b"; "c" = "foo-c"; }
  */
  genAttrs' = list: f: listToAttrs (map f list);

  /* Return true if the function pred returns true for at least one attribute
     of the set, and false otherwise.

     Type: anyAttrs :: (String -> a -> Bool) -> AttrSet -> Bool

     Example:
       anyAttrs (n: v: n == "foo") { "foo" = "bar"; "x" = "a"; } // => true
       anyAttrs (n: v: n == "y") { "foo" = "bar"; "x" = "a"; } // => false
       anyAttrs (n: v: v == "bar") { "foo" = "bar"; "x" = "a"; } // => true
  */
  anyAttrs = pred: set:
    any (attr: pred attr.name attr.value) (attrsToList set);

  /* Return the number of attributes in set for which the function pred returns
     true.

     Type: countAttrs :: (String -> a -> Bool) -> AttrSet -> Int

     Example:
       countAttrs (n: v: n == "foo") { "foo" = "bar"; "x" = "a"; } // => 1
       countAttrs (n: v: n == "y") { "foo" = "bar"; "x" = "a"; } // => 0
       countAttrs (n: v: v == "a") { "foo" = "a"; "bar" = "a"; } // => 2
  */
  countAttrs = pred: set:
    count (attr: pred attr.name attr.value) (attrsToList set);

}
