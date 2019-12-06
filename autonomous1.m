brick.beep;

brick.StopAllMotors("Brake");
brick.SetColorMode(2,2);

droppedOff = 0;
pickedUp = 0;

StopLight = 0;
timeTurn90 = 3.2;%%Find
timeTurn180 = timeTurn90*2;
timeForward = .8;
timeBackward = 1.6; %%Find
currentTime = 0;
speedl = 80.5;
speedr = 79.5;
speedTurn = 15;%%Find
wallDist = 40;

rightDist = 0;
leftDist = 0;
forwardDist = 0;

turnBackwards = 0;

hasTurnedRight = 0;
hasTurnedLeft = 0;
hasGoneForward = 0;
valid = 0;
previous = "left";

while droppedOff == 0
    valid = 0;
    turnBackwards = 0;
    color = brick.ColorCode(2);
    disp(color);
    if color == 5 && stopLight == 0 %%Stop Sign
        fprintf("color red\n");
        brick.StopMotor(3);
        pause(4);
        stopLight = 1;
    else if color == 2 && pickedUp == 0 %%Pick Up Person
            fprintf("\ncolor blue, pick-up point\n");
            reading = brick.TouchPressed(3);
            while reading == 0
                brick.MoveMotor(2,speedl);
                brick.MoveMotor(1, speedr);
                reading = brick.TouchPressed(3);
            end
            brick.StopMotor(1-2)
            brick.MoveMotor(2,-speedl/2);
            brick.MoveMotor(1,-speedr/2);
            pause(timeBackward/2);
            brick.StopMotor(1-2);
            brick.StopMotor(3);
            brick.MoveMotor(4,20);
            pause(2);
            brick.StopMotor(4);
            brick.StopMotor(1-4);
            brick.MoveMotor(1,speedTurn);
            brick.MoveMotor(2,-speedTurn);
            pause(timeTurn180);
            brick.StopMotor(1-2);
            hasTurnedRight = 0;
            hasTurnedLeft = 0;
            hasGoneForward = 0;
            pickedUp = 1;
        else if color == 1 && pickedUp == 1
                pause(1);
                brick.StopMotor(3);
                brick.StopMotor(1-2);
                fprintf("\npicked up, Green, drop-off point\n");
                brick.MoveMotor(4,-20);
                pause(2);
                brick.StopMotor(4)
                brick.StopMotor(1-4);
                brick.MoveMotor(3,-750);
                pause(3);
                brick.StopMotor(3);
                brick.StopMotor(1-2);
                brick.beep;
                hasTurnedRight = 0;
                hasTurnedLeft = 0;
                hasGoneForward = 0;
                droppedOff = 1;
            else if currentTime < timeForward
                    valid = 0;
                    fprintf("\njust keep swimming\n");
                    brick.MoveMotor(2,speedl);
                    brick.MoveMotor(1, speedr);
                    pause(.1);
                    currentTime = currentTime + .1;
                else while (valid == 0)
                    rightDist = 0;
                    leftDist = 0;
                    forwardDist = 0;
                    fprintf("\nMaking Decision, Measuring Distances\n");
                    stopLight = 0;
                    currentTime = 0;
                    brick.StopMotor(3);
                    forwardDist = brick.UltrasonicDist(4);
                    disp(forwardDist);
                   
                    brick.MoveMotor(1,-speedTurn);
                    brick.MoveMotor(2,speedTurn);
                    pause(timeTurn90);
                    brick.StopMotor(1-2);
                    rightDist = brick.UltrasonicDist(4);
                    disp(rightDist);
                   
                    brick.MoveMotor(1,speedTurn);
                    brick.MoveMotor(2,-speedTurn);
                    pause(timeTurn180);
                    brick.StopMotor(1-2);
                    leftDist = brick.UltrasonicDist(4);
                    disp(leftDist);
                   
                    if rightDist < wallDist
                        rightWall = 1;
                        fprintf("\nthere is a right wall\n");
                    else
                        rightWall = 0;
                    end
                   
                    if leftDist < wallDist
                        leftWall = 1;
                        fprintf("\nthere is a left wall\n");
                    else
                        leftWall = 0;
                    end
                   
                    if forwardDist < wallDist
                        frontWall = 1;
                        fprintf("\nthere is a front wall\n");
                    else
                        frontWall = 0;
                    end
                   
                   
                    if rightWall==1 && leftWall==1 && frontWall==1
                        fprintf("\nbackward descision\n");
                        brick.MoveMotor(1, -speedTurn);
                        brick.MoveMotor(2, speedTurn);
                        pause(timeTurn90);
                        brick.StopMotor(1-2);
                        brick.MoveMotor(2,-speedl);
                        brick.MoveMotor(1, -speedr);
                        pause(timeBackward);
                        brick.StopMotor(1-2);
                        brick.MoveMotor(1, -speedTurn)
                        brick.MoveMotor(2, speedTurn);
                        pause(timeTurn180);
                        turnBackwards = 1;
                    else if rightWall==1 && leftWall==1
                             brick.MoveMotor(1,-speedTurn)
                             brick.MoveMotor(2, speedTurn)
                             pause(timeTurn90);
                             brick.StopMotor(1-2);
                             previous = "forward";
                             valid = 1;
                        else if rightWall==1 && frontWall==1
                                brick.beep();
                                valid = 1;
                                previous = "left";

                            else if leftWall==1 && frontWall==1
                                    brick.MoveMotor(1, -speedTurn)
                                    brick.MoveMotor(2, speedTurn);
                                    pause(timeTurn180);
                                    valid = 1;
                                    previous = "right";
                                else if rightWall==1
                                        if hasGoneForward == 0
                                            brick.MoveMotor(2, speedTurn);
                                            brick.MoveMotor(1, -speedTurn);
                                            pause(timeTurn90);
                                            brick.StopMotor(1-2);
                                            hasGoneForward = 1;
                                            valid = 1;
                                            previous = "forward";
                                        else if hasTurnedLeft == 0
                                                brick.beep();
                                                hasTurnedLeft = 1;
                                                valid = 1;
                                                previous = "left";
                                            else
                                                hasGoneForward = 0;
                                                hasTurnedLeft = 0;
                                                brick.MoveMotor(2, speedTurn);
                                                brick.MoveMotor(1, -speedTurn);
                                                pause(timeTurn90);
                                                brick.StopMotor(1-2);
                                                hasGoneForward = 1;
                                                valid = 1;
                                                previous = "forward";
                                            end
                                        end
                                    else if leftWall==1
                                            if hasGoneForward == 0
                                                brick.MoveMotor(2, speedTurn)
                                                brick.MoveMotor(1, -speedTurn)
                                                pause(timeTurn90);
                                                brick.StopMotor(1-2)
                                                previous = "forward";
                                                hasGoneForward = 1;
                                                valid = 1;
                                            else if hasTurnedRight == 0
                                                    brick.MoveMotor(2, speedTurn)
                                                    brick.MoveMotor(1, -speedTurn)
                                                    pause(timeTurn180);
                                                    brick.StopMotor(1-2)
                                                    previous = "right";
                                                    hasTurnedRight = 1;
                                                    valid = 1;
                                                else
                                                    hasGoneForward = 0;
                                                    hasTurnedRight = 0;
                                                    brick.MoveMotor(2, speedTurn)
                                                    brick.MoveMotor(1, -speedTurn)
                                                    pause(timeTurn90);
                                                    brick.StopMotor(1-2)
                                                    previous = "forward";
                                                    hasGoneForward = 1;
                                                    valid = 1;
                                                end
                                            end
                                        else if frontWall==1
                                                if hasTurnedRight == 0
                                                    brick.MoveMotor(2, speedTurn)
                                                    brick.MoveMotor(1, -speedTurn)
                                                    pause(timeTurn180);
                                                    brick.StopMotor(1-2)
                                                    valid = 1;
                                                    hasTurnedRight = 1;
                                                    previous = "right";
                                                else if hasTurnedLeft == 0
                                                        brick.beep()
                                                        hasTurnedLeft = 1;
                                                        valid = 1;
                                                        previous = "left";
                                                    else
                                                        hasTurnedRight = 0;
                                                        hasTurnedLeft = 0;
                                                        brick.MoveMotor(2, speedTurn)
                                                        brick.MoveMotor(1, -speedTurn)
                                                        pause(timeTurn180);
                                                        brick.StopMotor(1-2)
                                                        valid = 1;
                                                        hasTurnedRight = 1;
                                                        previous = "right";
                                                   
                                                    end
                                               
                                                end
                                            else
                                                if hasGoneForward ==0
                                                    brick.MoveMotor(2, speedTurn)
                                                    brick.MoveMotor(1, -speedTurn)
                                                    pause(timeTurn90);
                                                    brick.StopMotor(1-2)
                                                    valid = 1;
                                                    previous = "forward";
                                                    hasGoneForward = 1;
                                                else if hasTurnedRight == 0
                                                        brick.MoveMotor(2, speedTurn)
                                                        brick.MoveMotor(1, -speedTurn)
                                                        pause(timeTurn180);
                                                        brick.StopMotor(1-2)
                                                        valid = 1;
                                                        hasTurnedRight = 1;
                                                        previous = "right";
                                                    else if hasTurnedLeft == 0
                                                            brick.beep();
                                                            hasTurnedLeft = 1;
                                                            valid = 1;
                                                            previous = "left";
                                                        else
                                                            hasTurnedLeft = 0;
                                                            hasTurnedRight = 0;
                                                            hasGoneForward = 0;
                                                            brick.MoveMotor(2, speedTurn)
                                                            brick.MoveMotor(1, -speedTurn)
                                                            pause(timeTurn90);
                                                            brick.StopMotor(1-2)
                                                            valid = 1;
                                                            previous = "forward";
                                                            hasGoneForward = 1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    end
                end
            end
        end
    end
            end
        end
    end
end
brick.StopAllMotors('Brake');