_: [
  {
    path = "default";
    title = "Home";
    cards = [];
    sections = [
      {
        type = "grid";
        cards = [
          {
            type = "heading";
            heading = "Home";
          }
          {
            type = "custom:clock-weather-card";
            entity = "weather.home";
            weather_icon_type = "fill";
            animated_icon = true;
            time_pattern = "HH:mm";
            time_format = 12;
            date_pattern = "ccc, d.MM.yy";
            hide_forecast_section = true;
            hourly_forecast = false;
          }
          {
            show_current = false;
            show_forecast = true;
            type = "weather-forecast";
            entity = "weather.home";
            forecast_type = "daily";
          }
          {
            type = "tile";
            entity = "device_tracker.julia_iphone_12";
          }
        ];
      }
      {
        type = "grid";
        cards = [
          {
            type = "heading";
            heading = "Scenes";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "scene.daylight";
            tap_action = {
              action = "toggle";
            };
            name = "Daylight";
            icon_color = "yellow";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "scene.warm";
            tap_action = {
              action = "toggle";
            };
            name = "Warm";
            icon_color = "yellow";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "scene.orange";
            icon_color = "orange";
            icon = "mdi:sun-wireless-outline";
            tap_action = {
              action = "toggle";
            };
            name = "Orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "scene.soho";
            tap_action = {
              action = "toggle";
            };
            name = "Soho";
            icon_color = "purple";
          }
          {
            type = "heading";
            heading = "Lights";
          }
          {
            type = "custom:mushroom-light-card";
            entity = "light.all";
            use_light_color = false;
            show_brightness_control = true;
            show_color_temp_control = false;
            collapsible_controls = false;
            layout = "horizontal";
            fill_container = true;
            icon_color = "orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "light.bed";
            tap_action = {
              action = "toggle";
            };
            icon_color = "orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "light.bed_links";
            tap_action = {
              action = "toggle";
            };
            icon_color = "orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "light.bureau_links";
            tap_action = {
              action = "toggle";
            };
            icon_color = "orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "light.bureau";
            tap_action = {
              action = "toggle";
            };
            icon_color = "orange";
          }
          {
            type = "custom:mushroom-entity-card";
            entity = "light.kast";
            tap_action = {
              action = "toggle";
            };
            icon_color = "orange";
          }
        ];
      }
    ];
    type = "sections";
    max_columns = 3;
  }
]
