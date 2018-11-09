global key
InitKeyboard();
%Connect to brick
%brick = ConnectBrick('ALI');
%brick.beep()

%Declare variables
SPEED = 65;
LOWER_SPEED = 15;
RAMP_SPEED = 60;
rightMotor = 'A';
leftMotor = 'D';
rampMotor = 'C';
COLORPORT = 2;
COLORCODE = 4;
TOUCHPORT = 3;
ULTRAPORT = 4;

pickUp = 'blue';
dropOff = 'green';
stop = 'red';

brick.SetColorMode(COLORPORT, COLORCODE);
color_rgb = brick.ColorRGB(COLORPORT);

% These are the values that the colorsensor will get
% if it is red, green, blue

redValue = 50;
greenValue = 20; %needs to be less than 15
blueValue = 95;
normalBlueValue = 50;

BACKUP_PAUSE_TIME = 1;
TURNAROUND_PAUSE_TIME = 2;
TURN_PAUSE_TIME = 0.26;
TURN_LEFT_PAUSE_TIME = 1.5;
LEFT_PAUSE_TIME = 1.3;
RAMP_PAUSE_TIME = 2;
CLEAR_WALL_TIME = 1;
STOPLIGHT_PAUSE_TIME = 5;
TURN_LEFT_DISTANCE = 51;
PICKUP_STATE = false;

%Autonomous car code
%{
This code lets our car drive autonomously. The color sensor is for the
stoplight, pickup, and dropoff locations. All variables are defined above.
%}
while key ~= 'q'
    color_rgb = brick.ColorRGB(COLORPORT);
    
    if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
        
       %Comes to a stop light
       disp("at a stoplight");
       brick.StopAllMotors(1);
       pause(STOPLIGHT_PAUSE_TIME);
       brick.MoveMotor(rightMotor, SPEED);
       brick.MoveMotor(leftMotor, SPEED);
       pause(1.5);
       
    elseif color_rgb(2) < greenValue && color_rgb(1) < 10 && color_rgb(3) < normalBlueValue && PICKUP_STATE == 1
        
        %At the drop off location
        disp("at a drop off location");
        PICKUP_STATE = false;
        brick.StopAllMotors(1);
        %Spin 180 to face back to the person to pickup.
        brick.MoveMotor(rightMotor, SPEED);
        brick.MoveMotor(leftMotor, 0);
        pause(TURNAROUND_PAUSE_TIME);
        brick.StopAllMotors(1);
        pause(1);
        %Open Ramp POSITIVE value is CLOSE
        brick.MoveMotor(rampMotor, -RAMP_SPEED);
        pause(RAMP_PAUSE_TIME);
        %backup to pickup person
        brick.MoveMotor(rightMotor, -SPEED);
        brick.MoveMotor(leftMotor, -SPEED);
        pause(BACKUP_PAUSE_TIME+5);
        brick.StopAllMotors(1);
        %Close Ramp
        brick.MoveMotor(rampMotor, RAMP_SPEED);
        pause(5);
        brick.StopAllMotors(1);
        %Now go off in the world and pickup
        brick.MoveMotor(rightMotor, SPEED);
        brick.MoveMotor(leftMotor, SPEED);
        pause(BACKUP_PAUSE_TIME+1);
        
    elseif color_rgb(3) > blueValue && ~PICKUP_STATE && color_rgb(1) < 10 && color_rgb(2) < 20
        
        %At the pick up location
        disp("at a pick up location");
        PICKUP_STATE = true;
        brick.StopAllMotors(1);
        %Spin 180 to face back to the person to pickup.
        brick.MoveMotor(rightMotor, SPEED);
        brick.MoveMotor(leftMotor, 0);
        pause(TURNAROUND_PAUSE_TIME);
        brick.StopAllMotors(1);
        pause(1);
        %Open Ramp
        brick.MoveMotor(rampMotor, -RAMP_SPEED);
        pause(RAMP_PAUSE_TIME);
        %backup to pickup person
        brick.MoveMotor(rightMotor, -SPEED);
        brick.MoveMotor(leftMotor, -SPEED);
        pause(BACKUP_PAUSE_TIME);
        brick.StopAllMotors(1);
        %Close Ramp
        brick.MoveMotor(rampMotor, RAMP_SPEED);
        pause(RAMP_PAUSE_TIME);
        brick.StopAllMotors(1);
        %Now go dropoff
        brick.MoveMotor(rightMotor, SPEED);
        brick.MoveMotor(leftMotor, SPEED);
        pause(BACKUP_PAUSE_TIME+1);
        
    else
    
        if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
           %Comes to a stop light
           disp("at a stoplight");
           brick.StopAllMotors(1);
           pause(STOPLIGHT_PAUSE_TIME);
           brick.MoveMotor(rightMotor, SPEED);
           brick.MoveMotor(leftMotor, SPEED);
           pause(1.5);
        end
       % Normal Moving State
       brick.MoveMotor(rightMotor, SPEED);
       brick.MoveMotor(leftMotor, SPEED);
       
       touchSensorReading = brick.TouchPressed(TOUCHPORT);
       
       distance = brick.UltrasonicDist(ULTRAPORT);
       
       if touchSensorReading
           
           if (distance > TURN_LEFT_DISTANCE+6)
               brick.beep();
               %These next three lines make sure that it clears the wall
               %before turning left.
               %brick.MoveMotor(leftMotor, SPEED);
               %brick.MoveMotor(rightMotor, SPEED);
               %pause(CLEAR_WALL_TIME);
               disp('Turning left after touch sensor!');
               %first back up
               brick.StopAllMotors('Coast');
                brick.MoveMotor(rightMotor, -SPEED);
                brick.MoveMotor(leftMotor, -SPEED);
                pause(BACKUP_PAUSE_TIME);
               %begin turning left
               brick.MoveMotor(leftMotor, LOWER_SPEED);
               brick.MoveMotor(rightMotor, SPEED);
               pause(TURN_LEFT_PAUSE_TIME);
               if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
                    %Comes to a stop light
                    disp("at a stoplight");
                    brick.StopAllMotors(1);
                    pause(STOPLIGHT_PAUSE_TIME);
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                    pause(1.5);
               end
               brick.MoveMotor(leftMotor, SPEED);
               brick.MoveMotor(rightMotor, SPEED);
                if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
                   %Comes to a stop light
                   disp("at a stoplight");
                   brick.StopAllMotors(1);
                   pause(STOPLIGHT_PAUSE_TIME);
                   brick.MoveMotor(rightMotor, SPEED);
                   brick.MoveMotor(leftMotor, SPEED);
                   pause(1.5);
               else
                    pause(LEFT_PAUSE_TIME);
               end
           else
               disp('Hit wall, moving right.');
               % touched so backup
                brick.StopAllMotors('Coast');
                brick.MoveMotor(rightMotor, -SPEED);
                brick.MoveMotor(leftMotor, -SPEED);
                pause(BACKUP_PAUSE_TIME); %let motors move for paused_time
                % turn right
                brick.MoveMotor(rightMotor, LOWER_SPEED);
                brick.MoveMotor(leftMotor, SPEED);
                pause(TURN_PAUSE_TIME);
                if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
                    %Comes to a stop light
                    disp("at a stoplight");
                    brick.StopAllMotors(1);
                    pause(STOPLIGHT_PAUSE_TIME);
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                    pause(1.5);
                end
           end
       end
       
       pause(1);
       
       distance = brick.UltrasonicDist(ULTRAPORT);
       
       
       if (distance > TURN_LEFT_DISTANCE)
           pause(0.1);
            if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
               %Comes to a stop light
               disp("at a stoplight");
               brick.StopAllMotors(1);
               pause(STOPLIGHT_PAUSE_TIME);
               brick.MoveMotor(rightMotor, SPEED);
               brick.MoveMotor(leftMotor, SPEED);
               pause(1.5);
           end
           brick.beep();
           pause(0.5);
           if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
               %Comes to a stop light
               disp("at a stoplight");
               brick.StopAllMotors(1);
               pause(STOPLIGHT_PAUSE_TIME);
               brick.MoveMotor(rightMotor, SPEED);
               brick.MoveMotor(leftMotor, SPEED);
               pause(1.5);
           end
           %These next three lines make sure that it clears the wall
           %before turning left.
           %brick.MoveMotor(leftMotor, SPEED);
           %brick.MoveMotor(rightMotor, SPEED);
           brick.StopAllMotors('Coast');
           %pause(CLEAR_WALL_TIME);
           disp('Turning left!');
           %first back up
            brick.MoveMotor(rightMotor, -SPEED);
            brick.MoveMotor(leftMotor, -SPEED);
            pause(BACKUP_PAUSE_TIME);
           %begin turning left
           brick.MoveMotor(leftMotor, LOWER_SPEED);
           brick.MoveMotor(rightMotor, SPEED);
           if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
               %Comes to a stop light
               disp("at a stoplight");
               brick.StopAllMotors(1);
               pause(STOPLIGHT_PAUSE_TIME);
               brick.MoveMotor(rightMotor, SPEED);
               brick.MoveMotor(leftMotor, SPEED);
               pause(1.5);
           end
           pause(TURN_LEFT_PAUSE_TIME);
           if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
                    %Comes to a stop light
                    disp("at a stoplight");
                    brick.StopAllMotors(1);
                    pause(STOPLIGHT_PAUSE_TIME);
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                    pause(1.5);
           end
           brick.MoveMotor(leftMotor, SPEED);
           brick.MoveMotor(rightMotor, SPEED);
           if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
               %Comes to a stop light
               disp("at a stoplight");
               brick.StopAllMotors(1);
               pause(STOPLIGHT_PAUSE_TIME);
               brick.MoveMotor(rightMotor, SPEED);
               brick.MoveMotor(leftMotor, SPEED);
               pause(1.5);
           else
               pause(LEFT_PAUSE_TIME);
           end
       end 
    end
end
%end
brick.StopAllMotors('Brake'); 
CloseKeyboard();
%DisconnectBrick(brick);

            

