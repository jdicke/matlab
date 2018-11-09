global key
InitKeyboard();

%brick = ConnectBrick('ALI');
brick.beep()

%blue > 105
%green < 15
%red > 85

%Normally
%red is at around 51
%green is at around 28
%blue is around 92

redValue = 100;
greenValue = 20; %needs to be less than 15
blueValue = 105;

COLORPORT = 2;
COLORCODE = 4;

while key ~= 'q'
    pause(0.1);
    
    brick.SetColorMode(COLORPORT, COLORCODE);
    color_rgb = brick.ColorRGB(COLORPORT);
    
    disp("RED: " + color_rgb(1));
    disp("GREEN: " + color_rgb(2));
    disp("BLUE: " + color_rgb(3));
    disp("___________");
    
    pause(1)
    
    if color_rgb(1) > redValue
       %Comes to a stop light
       disp("at a stoplight");
    elseif color_rgb(2) < greenValue && color_rgb(1) < redValue && color_rgb(3) < 50
        %At the drop off location
        disp("at a drop off location");
    elseif color_rgb(3) > blueValue && color_rgb(1) < 50
        %At the pick up location
        disp("at a pick up location");
    end

end
CloseKeyboard();