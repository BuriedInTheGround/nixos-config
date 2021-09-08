{ self, lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
  inherit (self.attrsets) mapFilterAttrs;
in

rec {

  /* Generate an attribute set of modules by mapping a function f to the
     content of a directory dir.

     Type: mapModules :: (FilePath -> AttrSet) -> DirPath -> AttrSet
  */
  mapModules = f: dir:
    mapFilterAttrs
      # Filter out files starting with "_" and skipped files/directories.
      (itemName: attrSet:
        attrSet != null &&
        !(hasPrefix "_" itemName))
      (itemName: itemType:
        let
          path = "${toString dir}/${itemName}";
        in
        # If the item is a directory, use the default.nix file, if exists.
        if itemType == "directory" && pathExists "${path}/default.nix"
        then nameValuePair itemName (f path)
        # If is a Nix file (default.nix excluded) use it.
        else if itemType == "regular" &&
                itemName != "default.nix" &&
                hasSuffix ".nix" itemName
        then nameValuePair (removeSuffix ".nix" itemName) (f path)
        # Otherwise skip the file/directory.
        else nameValuePair "" null)
      (readDir dir);

  /* Like `mapModules` but return only a list with the values of the attribute
     set.

     Type: mapModules' :: (FilePath -> AttrSet) -> DirPath -> [a]
  */
  mapModules' = f: dir:
    attrValues (mapModules f dir);

  /* Like `mapModules` but recursive into directories.

     Type: mapModulesRec :: (FilePath -> AttrSet) -> DirPath -> AttrSet
  */
  mapModulesRec = f: dir:
    mapFilterAttrs
      # Filter out files starting with "_" and skipped files/directories.
      (itemName: attrSet:
        attrSet != null &&
        !(hasPrefix "_" itemName))
      (itemName: itemType:
        let path = "${toString dir}/${itemName}"; in
        # If the item is a directory, call mapModulesRec recursively.
        if itemType == "directory"
        then nameValuePair itemName (mapModulesRec f path)
        # If is a Nix file (default.nix excluded) use it.
        else if itemType == "regular" &&
                itemName != "default.nix" &&
                hasSuffix ".nix" itemName
        then nameValuePair (removeSuffix ".nix" itemName) (f path)
        # Otherwise skip the file.
        else nameValuePair "" null)
      (readDir dir);

  /* Like `mapModules'` but recursive into directories.

     Type: mapModulesRec' :: ([FilePath] -> AttrSet) -> DirPath -> [a]
  */
  mapModulesRec' = f: dir:
    let
      dirs =
        mapAttrsToList
          (k: _: "${dir}/${k}")
          (filterAttrs
            (itemName: itemType:
              itemType == "directory" && !(hasPrefix "_" itemName))
            (readDir dir));
      files = attrValues (mapModules id dir);
      paths = files ++ concatLists (map (d: mapModulesRec' id d) dirs);
    in
      map f paths;

}
