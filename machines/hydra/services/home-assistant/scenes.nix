{
  lib,
  lights,
  ...
}: let
  colors = {
    rgb = r: g: b: {
      color_mode = "rgb";
      rgb_color = [
        r
        g
        b
      ];
    };
    temperature = val: {
      color_mode = "color_temp";
      color_temp_kelvin = val;
    };
  };

  applyColor = opts:
    (builtins.removeAttrs opts [
      "color"
    ])
    // opts.color;

  mkScene = name: entities: {
    inherit name entities;
    id = lib.strings.toLower name;
  };

  # Apply the same options for each entity passed in
  mkUniformScene = name: entities: opts:
    entities
    |> map (name: {
      inherit name;
      value = opts;
    })
    |> lib.listToAttrs
    |> mkScene name;

  mkLight = opts:
    {
      state = "on";
      brightness = 255;
    }
    // applyColor opts;

  mkUniformLightScene = name: lights: opts:
    mkUniformScene name (map (name: "light.${name}") lights) (mkLight opts);

  mkLightScene = name: lights:
    lib.attrsToList lights
    |> map ({
      name,
      value,
    }: {
      name = "light.${name}";
      value = mkLight value;
    })
    |> lib.listToAttrs
    |> mkScene name;
in
  with colors; [
    (mkUniformLightScene "Daylight" lights {
      color = temperature 3000;
    })
    (mkUniformLightScene "Warm" lights {
      color = temperature 2000;
    })
    (mkLightScene "Soho" {
      bed.color = rgb 255 101 99;
      bed_links.color = rgb 255 43 121;
      bureau.color = rgb 138 23 255;
      bureau_links.color = rgb 255 90 182;
      kast.color = rgb 255 35 108;
    })
    (mkLightScene "Orange" {
      bed.color = rgb 255 99 16;
      bed_links.color = rgb 255 74 54;
      bureau.color = rgb 255 43 107;
      bureau_links.color = rgb 255 108 19;
      kast.color = rgb 255 0 46;
    })
  ]
