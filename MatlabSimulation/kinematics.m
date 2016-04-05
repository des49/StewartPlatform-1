function [angles_out, q] = kinematics(b, p, s, a, beta, h0, x, y, z, roll, pitch, yaw)

    phi     = roll*pi/180;  % rotation about x_axis
    theta   = pitch*pi/180; % rotation about y_axis
    psi     = yaw*pi/180;   % rotation about z_axis
    
    % define rotation matricies for each of the component directions
    R_z = [...
            cos(psi)    -sin(psi)   0;...
            sin(psi)     cos(psi)   0;...
            0            0          1];
    R_y = [...
            cos(theta)  0   sin(theta);...
            0           1   0;...
           -sin(theta)  0   cos(theta)];
    R_x = [...
            1   0           0;...
            0   cos(phi)   -sin(phi);...
            0   sin(phi)    cos(phi)];
        
    % The full rotation from the base frame to the platform frame
    R = R_z*R_y*R_x;
    
    % The translation vector from the base frame to the platform frame
    T = [x y (z+h0)]';
    
    %% calculate the vectors from the base frame to the connection points on the platform
    for i = 1:6
        q(:,i) = T + R*p(:,i);
    end
    
    %% calculate the "leg" lengths
    l = [];
    for i = 1:6
        l(end+1) = norm(q(:,i) - b(:,i));
    end
    
    angles_out = calculate_alpha(l, s, a, p, b, beta, h0);
end