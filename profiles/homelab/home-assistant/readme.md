# Home assistant setup

Most of the configuration is declerative but not all integrations can be fully set up automatically
The steps required to get up and running on a fresh installation are detailed below in no specific order

## Accuweather

Set up the `accuweather` integeration and supply [your api key](https://developer.accuweather.com/user/me/apps)

## Localtuya
                                                                                                                      
[Configuring the integration](https://github.com/rospogrigio/localtuya#adding-the-integration)         
                                                                                                                      
### Entity configuration cheatsheet                                                                                   
- `id`: 20 # Usually 1 or 20                                                                                          
- `brightness`: 3 | 22 (Optional, usually 3 or 22, default: "none"#)                                                  
- `color_temp`: 4 | 23 (Optional, usually 4 or 23, default: "none")                                                   
- `brightness_lower`: 0 (Optional, usually 0 or 29, default: 29)                                                      
- `brightness_upper`: 255 (Optional, usually 255 or 1000, default: 1000)                                              
- `color_mode`: 2 | 21 (Optional, usually 2 or 21, default: "none")                                                   
- `color`: 5 | 24 (Optional, usually 5 (RGB_HSV) or 24(HSV), default: "none")                                         
- `color_temp_min_kelvin`: 2700 (Optional, default: 2700)                                                             
- `color_temp_max_kelvin`: 6500 (Optional, default: 6500)  
