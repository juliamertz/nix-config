{ pkgs, ... }:
let
  devices = {
    dimmer-remote.id = "8700094e4939ca0dc2faf4a236cbbe1c";
    bedroom.id = "212360d38748c989c293c271d081cddb";
    iphone.id =  "2b79a6caae2cf11f8d8bb2b937dd74aa";
  };
in
{
  services.home-assistant = {
    config.input_datetime = {
      only_time = {
        name = "wakeup_time";
        has_date = false;
        has_time = true;
      };
    };

    config.automation = [
      {
        alias = "Hue Dimmer Remote";
        description = "";
        use_blueprint = {
          path = "hue-remote-dimmer-january-2022.yaml";
          input = {
            dimmer_device = devices.dimmer-remote.id;
            on_short_action = [
              {
                condition = "state";
                entity_id = "light.all";
                state = "off";
              }
              {
                service = "light.turn_on";
                target.area_id = "bedroom";
                data.brightness_pct = 100;
              }
            ];
            off_short_action = [
              {
                service = "light.turn_off";
                target.entity_id = "light.all";
                data = { };
              }
            ];
            brightness_down_short_action = [
              {
                service = "light.turn_on";
                target.area_id = "bedroom";
                data.brightness_step_pct = -20;
              }
            ];
            brightness_up_short_action = [
              {
                service = "light.turn_on";
                target.area_id = "bedroom";
                data.brightness_step_pct = 20;
              }
            ];
            off_repeat_action = [
              {
                service = "scene.turn_on";
                target.entity_id = "scene.sleepy";
                metadata = { };
              }
            ];
            # brightness_down_long_action = [ ];
            # brightness_up_long_action = [ ];
            # brightness_up_repeat_action = [ ];
            # brightness_down_repeat_action = [ ];
            # on_long_action = [ ];
            # off_long_action = [ ];
            # on_repeat_action = [ ];
          };
        };
      }
      {
        alias = "Set theme";
        triggers = {
          trigger = "event";
          event_type = "homeassistant";
          event_data.event = "start";
        };
        actions = {
          action = "frontend.set_theme";
          data = {
            name = "Rosé Pine Moon";
            mode = "dark";
          };
        };
      }
      {
        alias = "Home geolocation light triggers";
        description = "";
        trigger = [
          {
            platform = "zone";
            entity_id = "person.julia";
            zone = "zone.home";
            event = "enter";
            id = "enter";
          }
          {
            platform = "zone";
            entity_id = "person.julia";
            zone = "zone.home";
            event = "leave";
            id = "leave";
          }
        ];
        condition = [ ];
        action = [
          {
            "if" = [
              {
                condition = "trigger";
                id = "enter";
              }
            ];
            "then" = [
              {
                service = "light.turn_on";
                data = { };
                target = {
                  entity_id = "light.all";
                };
              }
            ];
            "else" = [
              {
                service = "light.turn_off";
                data = { };
                target = {
                  entity_id = "light.all";
                };
              }
            ];
          }
        ];
        mode = "single";
      }
      {
        alias = "Adjust color temperature at sunset";
        description = "";
        trigger = [
          {
            platform = "sun";
            event = "sunset";
            offset = 0;
          }
        ];
        condition = [
          {
            condition = "state";
            entity_id = "light.all";
            state = "on";
          }
          {
            condition = "state";
            entity_id = "input_text.last_scene";
            state = "daylight";
          }
        ];
        action = [
          {
            service = "scene.turn_on";
            metadata = { };
            target = {
              entity_id = "scene.warm";
            };
          }
        ];
        mode = "single";
      }
      {
        alias = "Wakeup sunrise";
        description = "Turn on lights in the morning and gradually increase the brightness";
        triggers = [
          {
            at = "input_datetime.wakeup_time";
            trigger = "time";
          }
        ];
        conditions = [
          {
            condition = "device";
            type = "is_off";
            device_id = devices.bedroom.id;
            entity_id = "a53e1f8e8d9c8f5d71b6c4cdee66d307";
            domain = "light";
          }
        ];
        actions = [
          {
            action = "light.turn_on";
            target.device_id = devices.bedroom.id;
            metadata = { };
            data = {
              kelvin = 2000;
              brightness_pct = 1;
            };
          }
          {
            action = "light.turn_on";
            target.device_id = devices.bedroom.id;
            metadata = { };
            data = {
              kelvin = 3389;
              brightness_pct = 100;
              transition = 10;
            };
          }
        ];
        mode = "single";
      }
      {
        alias = "Light state activity check";
        description = "Send a notification to phone if lights are turned on while away from home";
        trigger = [
          {
            platform = "state";
            entity_id = [ "light.all" ];
            from = "off";
            to = "on";
          }
        ];
        condition = [
          {
            condition = "not";
            conditions = [
              {
                condition = "zone";
                entity_id = "person.julia";
                zone = "zone.home";
              }
            ];
          }
        ];
        action = [
          {
            device_id = devices.iphone.id;
            domain = "mobile_app";
            type = "notify";
            message = "Lights turned on while away from home";
            title = "Attention required!";
          }
        ];
        mode = "single";
      }
    ];

    blueprints.automation = [
      (pkgs.fetchGist {
        id = "lksnyder0/6ad7bd5db9201f1c26019beb8bbb0ee7";
        file = "hue-remote-dimmer-january-2022.yaml";
        rev = "ec91124ab1894aab0c8b1003fc88955a674cdf87";
        hash = "sha256-Sp2zpVmQRx19gcpE8coCz35UBWmYF17NlLo05jo+iFo=";
      })
    ];
  };
}
