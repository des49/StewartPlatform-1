function drawSystem(uu,P)
    
    alpha       = [];
    roll        = uu(1);
    pitch       = uu(2);
    yaw         = uu(3);
    x           = uu(4);
    y           = uu(5);
    z           = uu(6);
    t            = uu(7);
    
    % do the kinematics
    [alpha, q] = kinematics(P.b, P.p, P.s, P.a, P.beta, P.h0, x, y, z, roll, pitch, yaw);
    
    % check the relative locations of the platform and the base
    P.b(:,end+1) = P.b(:,1);
    q(:,end+1) = q(:,1);
    
    persistent servoHandles;
    persistent baseHandle;
    persistent platformHandle;
    persistent ballHandle;
    
    if(t == 0)
        servoHandles    = [];
        figure(1), clf
        baseHandle = plot3(P.b(1,:), P.b(2,:), P.b(3,:), 'b');
        hold on
        platformHandle = plot3(q(1,:), q(2,:), q(3,:), 'g');
        xlabel('x')
        ylabel('y')
        zlabel('z')
        servoHandles = plotAllServoArms(P.b, P.a, q, P.beta, alpha, servoHandles);
        axis([-4,4,-4,4,-2,6]);
    else
        set(baseHandle,'XData',P.b(1,:),'YData',P.b(2,:),'ZData',P.b(3,:));
        set(platformHandle,'XData',q(1,:),'YData',q(2,:),'ZData',q(3,:));
        servoHandles = plotAllServoArms(P.b, P.a, q, P.beta, alpha, servoHandles); 
    end
end

function handle = plotServoArm(b_i, a, q_i, beta_i, alpha_i, handle)
    %given a the input variables, plot a servo arm in it's proper
    %orientation
    a_i = b_i + [cos(beta_i)*cos(alpha_i)*a;...
                  sin(beta_i)*cos(alpha_i)*a;...
                  sin(alpha_i)*a;];
              
    x = [b_i(1), a_i(1), q_i(1)]';
    y = [b_i(2), a_i(2), q_i(2)]';
    z = [b_i(3), a_i(3), q_i(3)]';
    
    length = norm(q_i - a_i);
%     if(abs(length-4.0) > .1)
%         msgID = 'MYFUN:BadIndex';
%         msg = 'link leg equals  ';
%         msg = strcat(msg,num2str(length));
%         msg = strcat(msg,' inches.');
%         baseException = MException(msgID,msg);
%         throw(baseException);
%     end
    
    if(isempty(handle))
        handle = plot3(x, y, z, 'r');
        hold on
    else
        set(handle,'XData',x,'YData',y,'ZData',z);
    end
end

function servoHandles = plotAllServoArms(b, a, q, beta, alpha, servoHandles)
    if(isempty(servoHandles))
        servoHandles(end+1) = plotServoArm(b(:,1), a, q(:,1), beta(1), alpha(1), []);
        servoHandles(end+1) = plotServoArm(b(:,2), a, q(:,2), beta(2), alpha(2), []);
        servoHandles(end+1) = plotServoArm(b(:,3), a, q(:,3), beta(3), alpha(3), []);
        servoHandles(end+1) = plotServoArm(b(:,4), a, q(:,4), beta(4), alpha(4), []);
        servoHandles(end+1) = plotServoArm(b(:,5), a, q(:,5), beta(5), alpha(5), []);
        servoHandles(end+1) = plotServoArm(b(:,6), a, q(:,6), beta(6), alpha(6), []);
    else
        servoHandles(1) = plotServoArm(b(:,1), a, q(:,1), beta(1), alpha(1), servoHandles(1));
        servoHandles(2) = plotServoArm(b(:,2), a, q(:,2), beta(2), alpha(2), servoHandles(2));
        servoHandles(3) = plotServoArm(b(:,3), a, q(:,3), beta(3), alpha(3), servoHandles(3));
        servoHandles(4) = plotServoArm(b(:,4), a, q(:,4), beta(4), alpha(4), servoHandles(4));
        servoHandles(5) = plotServoArm(b(:,5), a, q(:,5), beta(5), alpha(5), servoHandles(5));
        servoHandles(6) = plotServoArm(b(:,6), a, q(:,6), beta(6), alpha(6), servoHandles(6));
    end
end