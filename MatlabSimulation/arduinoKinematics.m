function [angles_out, q] = arduinoKinematics(b, p, s, a, beta, h0, x, y, z, roll, pitch, yaw)    
    phi     = roll*pi/180;  % rotation about x_axis
    theta   = pitch*pi/180; % rotation about y_axis
    psi     = yaw*pi/180;   % rotation about z_axis
    
    % start with the expanded form of the rotation matrix right off the
    % bat. Store it in a 3x3 array so you can access each value
    R = [...
            cos(psi)*cos(theta),    (-sin(psi)*cos(phi))+(cos(psi)*sin(theta)*sin(phi)),    ( sin(psi)*sin(phi))+(cos(psi)*sin(theta)*cos(phi));...
            sin(psi)*cos(theta),    ( cos(psi)*cos(phi))+(sin(psi)*sin(theta)*sin(phi)),    (-cos(psi)*sin(phi))+(sin(psi)*sin(theta)*cos(phi));...
           -sin(theta),               cos(theta)*sin(phi),                                                      cos(theta)*cos(phi);];
    
    % The translation vector from the base frame to the platform frame
    T = [x y (z+h0)]';
    
    %% calculate the vectors from the base frame to the connection points on the platform
    for i = 1:6
        % instead of doing matrix multiplication, expande it out for each
        % index of the vector you are forming
        q(1,i) = T(1) + R(1,1)*p(1,i) + R(1,2)*p(2,i) + R(1,3)*p(3,i);
        q(2,i) = T(2) + R(2,1)*p(1,i) + R(2,2)*p(2,i) + R(2,3)*p(3,i);
        q(3,i) = T(3) + R(3,1)*p(1,i) + R(3,2)*p(2,i) + R(3,3)*p(3,i);
    end
    
    %% calculate the "leg" lengths
    l = [];
    for i = 1:6
        % this time carry out the norm manually
        l(end+1) = sqrt((q(1,i) - b(1,i))^2 + (q(2,i) - b(2,i))^2 + (q(3,i) - b(3,i))^2);
    end
    
    angles_out = calculate_alpha(l, s, a, p, b, beta, h0);