global key
InitKeyboard();
%Connect to brick
%brick = ConnectBrick('ALI');
%brick.beep()

%Declare variables
SPEED = 50;
SPEED_TURNING = 65;
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

BACKUP_PAUSE_TIME = 1.5;
TURNAROUND_PAUSE_TIME = 2;
TURN_PAUSE_TIME = 1.3; %was 0.26 at 65 speed
TURN_LEFT_PAUSE_TIME = 1.3; %was 1.5 at 65 speed
LEFT_PAUSE_TIME = 3;
RAMP_PAUSE_TIME = 2;
CLEAR_WALL_TIME = 1;
STOPLIGHT_PAUSE_TIME = 5;
TURN_LEFT_DISTANCE = 51;
PICKUP_STATE = false;
ramp = false;

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
       pause(1);
       
    elseif color_rgb(3) > blueValue && PICKUP_STATE == 1 && color_rgb(1) < 10 && color_rgb(2) < 20
        
        disp("at a drop off location");
        PICKUP_STATE = false;
        brick.StopAllMotors(1);
        
        while 1
            pause(0.1);
            switch key
                case 'uparrow'
                    % Move forward
                    disp('W pressed');
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                case 'downarrow'
                    % Move backward (negative speed)
                    disp('S pressed');
                    brick.MoveMotor(rightMotor, -SPEED);
                    brick.MoveMotor(leftMotor, -SPEED);
                case 'leftarrow'
                    % Move Left
                    disp('A pressed');
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, LOWER_SPEED);
                case 'rightarrow'
                    % Move Right
                    disp('D pressed');
                    brick.MoveMotor(rightMotor, LOWER_SPEED);
                    brick.MoveMotor(leftMotor, SPEED); 
                case 'r'                 
                    if ~ramp
                        % Open ramp
                        brick.MoveMotor(rampMotor, -RAMP_SPEED);
                        pause(RAMP_PAUSE_TIME);
                        brick.StopAllMotors(1);
                        ramp = true;
                    else
                        %Close ramp
                        brick.MoveMotor(rampMotor, RAMP_SPEED);
                        pause(RAMP_PAUSE_TIME);
                        brick.StopAllMotors(1);
                        ramp = false;
                    end
                case 's'
                    brick.StopAllMotors(1);     
                case 't'
                    % Completely stop the motors
                    % Brake types: 'Brake' = hard stop
                    % 'Coast' = drift to stop
                    brick.StopAllMotors('Brake');
                    break;
            end
        end
        
    elseif color_rgb(2) < greenValue && color_rgb(1) < 10 && color_rgb(3) < normalBlueValue && ~PICKUP_STATE
        
        disp("at a pick up location");
        PICKUP_STATE = true;
        brick.StopAllMotors(1);
        
        while 1
            pause(0.1);
            switch key
                case 'uparrow'
                    % Move forward
                    disp('W pressed');
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                case 'downarrow'
                    % Move backward (negative speed)
                    disp('S pressed');
                    brick.MoveMotor(rightMotor, -SPEED);
                    brick.MoveMotor(leftMotor, -SPEED);
                case 'leftarrow'
                    % Move Left
                    disp('A pressed');
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, LOWER_SPEED);
                case 'rightarrow'
                    % Move Right
                    disp('D pressed');
                    brick.MoveMotor(rightMotor, LOWER_SPEED);
                    brick.MoveMotor(leftMotor, SPEED); 
                case 'r'                 
                    if ~ramp
                        % Open ramp
                        brick.MoveMotor(rampMotor, -RAMP_SPEED);
                        pause(RAMP_PAUSE_TIME);
                        brick.StopAllMotors(1);
                        ramp = true;
                    else
                        %Close ramp
                        brick.MoveMotor(rampMotor, RAMP_SPEED);
                        pause(RAMP_PAUSE_TIME);
                        brick.StopAllMotors(1);
                        ramp = false;
                    end
                case 's'
                    brick.StopAllMotors(1);     
                case 't'
                    % Completely stop the motors
                    % Brake types: 'Brake' = hard stop
                    % 'Coast' = drift to stop
                    brick.StopAllMotors('Brake');
                    break;
            end
        end
        
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

               disp('Turning left after touch sensor!');
               %first back up
               brick.StopAllMotors('Coast');
                brick.MoveMotor(rightMotor, -SPEED);
                brick.MoveMotor(leftMotor, -SPEED);
                pause(BACKUP_PAUSE_TIME);
               %begin turning left
               brick.MoveMotor(leftMotor, LOWER_SPEED);
               brick.MoveMotor(rightMotor, SPEED_TURNING);
               pause(TURN_LEFT_PAUSE_TIME);
               brick.StopAllMotors(1);
               pause(1);
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
                brick.MoveMotor(leftMotor, SPEED_TURNING);
                pause(TURN_PAUSE_TIME);
                brick.StopAllMotors(1);
                if color_rgb(1) > redValue && color_rgb(2) < 10 && color_rgb(3) < 10
                    %Comes to a stop light
                    disp("at a stoplight");
                    brick.StopAllMotors(1);
                    pause(STOPLIGHT_PAUSE_TIME);
                    brick.MoveMotor(rightMotor, SPEED);
                    brick.MoveMotor(leftMotor, SPEED);
                    pause(1.5);
                else
                    pause(1);
                end
           end
       end
       
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
           pause(1);
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

           brick.StopAllMotors('Coast');
           %pause(CLEAR_WALL_TIME);
           disp('Turning left!');
           %first back up
            brick.MoveMotor(rightMotor, -SPEED);
            brick.MoveMotor(leftMotor, -SPEED);
            pause(BACKUP_PAUSE_TIME);
           %begin turning left
           brick.MoveMotor(leftMotor, LOWER_SPEED);
           brick.MoveMotor(rightMotor, SPEED_TURNING);
           pause(TURN_LEFT_PAUSE_TIME);
           brick.StopAllMotors(1);
           pause(1);
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

            

