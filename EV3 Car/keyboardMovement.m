global key
InitKeyboard();

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
        case 'q'
            % Completely stop the motors
            % Brake types: 'Brake' = hard stop
            % 'Coast' = drift to stop
            brick.StopAllMotors('Brake');
            break;
    end
end
CloseKeyboard();