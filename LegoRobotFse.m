
dave = 0;
while dave == 0
str = input("enter command: ", 's');
if str == 'a'
   brick.MoveMotor(1, 25);
   brick.MoveMotor(2,-25);
else if str == 'd'
        brick.MoveMotor(1,-25);
        brick.MoveMotor(2,25);
    else if str == 's'
            brick.MoveMotor(2,-80.5);
            brick.MoveMotor(1, -80);
        else if str == 'w'
                brick.MoveMotor(2,80.5);
                brick.MoveMotor(1, 80);
            else if str == 'q'
                brick.MoveMotor(4,25);
                else if str == 'e'
                        brick.MoveMotor(4,-25);
                    else if str == 'x'
                            brick.StopMotor(1-2);
                            brick.StopMotor(3);
                            
                        else if str == 'i'
                            dave = 1;
            
            end
        end
                end
            end
end
end
end
end
end
brick.StopMotor(1-2);
