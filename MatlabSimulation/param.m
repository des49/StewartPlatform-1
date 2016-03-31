clear;% for calculating the parameters and home positions, we'll let the following be true
x       = 0;
y       = 0;
z       = 0;
roll    = 0;
pitch   = 0;
yaw     = 0;

% convert the roll pitch and yaw angles from degrees to radians
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
T = [x y z]';

% define known constants of the system
s    = 4.000;                  % inches: length of arm connecting servo arm and platform
a    = 0.625;                  % inches: length of servo arm from center of rotation to connection rod pivot point
radius_base = 1.250;        % inches: radius of the circle that determines location of base servos centers
angle_base  = 100*pi/180;   % radians: angle between servo locations on base on any given side of the triangular mount
radius_plat = 0.85;        % inches: radius of the circle that determines mounting location on platform 
angle_plat  = 20*pi/180;    % radians: angle between mounting locations on platform
beta        = [0, (0)+pi, (120*pi/180), (120*pi/180)+pi, (240*pi/180), (240*pi/180)+pi]';

%% generate servo locations in the base frame
local_x =  radius_base*sin(angle_base/2);
local_y = -radius_base*cos(angle_base/2);
b = [];
b(:,end+1) = [-local_x, local_y, 0]'; % servos(1) is bottom left
b(:,end+1) = [ local_x, local_y, 0]';  % servos(2) is bottom right
% rotate those coordinates 120 degrees about the z axis
R_120 = [...
        cos(120*pi/180)    -sin(120*pi/180)   0;...
        sin(120*pi/180)     cos(120*pi/180)   0;...
        0                   0                 1];
b(:,end+1) = R_120*[-local_x, local_y, 0]'; % servos(3) is bottom of right side
b(:,end+1) = R_120*[ local_x, local_y, 0]'; % servos(4) is top of right side
% rotate original coordinates 240 degrees
R_240 = [...
        cos(240*pi/180)    -sin(240*pi/180)   0;...
        sin(240*pi/180)     cos(240*pi/180)   0;...
        0                   0                 1];
b(:,end+1) = R_240*[-local_x, local_y, 0]'; % servos(3) is bottom of right side
b(:,end+1) = R_240*[ local_x, local_y, 0]'; % servos(4) is top of right side
% check the servo locations and order - passed
%     figure()
%     plot(b(1,:), b(2,:))

%% similarly, generate the connection locations in the platform frame
local_x =  radius_plat*sin(angle_plat/2);
local_y = -radius_plat*cos(angle_plat/2);
p = [];
p(:,end+1) = [-local_x, local_y, 0]'; % servos(1) is bottom left
p(:,end+1) = [ local_x, local_y, 0]';  % servos(2) is bottom right
% rotate those coordinates 120 degrees about the z axis
R_120 = [...
        cos(120*pi/180)    -sin(120*pi/180)   0;...
        sin(120*pi/180)     cos(120*pi/180)   0;...
        0                   0                 1];
p(:,end+1) = R_120*[-local_x, local_y, 0]'; % servos(3) is bottom of right side
p(:,end+1) = R_120*[ local_x, local_y, 0]'; % servos(4) is top of right side
% rotate original coordinates 240 degrees
R_240 = [...
        cos(240*pi/180)    -sin(240*pi/180)   0;...
        sin(240*pi/180)     cos(240*pi/180)   0;...
        0                   0                 1];
p(:,end+1) = R_240*[-local_x, local_y, 0]'; % servos(3) is bottom of right side
p(:,end+1) = R_240*[ local_x, local_y, 0]'; % servos(4) is top of right side
% check the platform connection locations and order - passed
%     figure()
%     plot(p(1,:), p(2,:), 'r')

%% calculate the "home" height h0 and add it to the translation vector
h0 = sqrt(s^2 + a^2 - (p(1,1) - b(1,1))^2 - (p(2,1) - b(2,1))^2) - p(3,1);
T = T + [0 0 h0]';

%% calculate the vectors from the base frame to the connection points on the platform
for i = 1:6
    q(:,i) = T + R*p(:,i);
end

% check the relative locations of the platform and the base
%     figure()
%     plot3(b(1,:), b(2,:), b(3,:))
%     hold on
%     plot3(q(1,:), q(2,:), q(3,:))

%% calculate the effective "leg" lengths at the home position
% these aren't the real leg lengths "s", they are the length "l" from the
% center of the servo rotation to the the connection point on the platform
l0 = [];
for i = 1:6
    l0(end+1) = norm(q(:,i) - b(:,i));
end

%% calculate alpha for the home position
alpha0 = calculate_alpha(l0, s, a, p, b, beta, h0);

%% how to calculate the alpha for any position
x       = 0;
y       = 0;
z       = 0;
roll    = 10;
pitch   = 10;
yaw     = 10;
alpha = kinematics(b, p, s, a, beta, h0, x, y, z, roll, pitch, yaw)
alpha2 = arduinoKinematics(b, p, s, a, beta, h0, x, y, z, roll, pitch, yaw)

% %% calculate the range of motion in home each direction
% max_x = 0;
% max_y = 0;
% max_z = 0;
% max_roll = 0;
% max_pitch = 0;
% max_yaw = 0;
% alpha = [0 0 0 0 0 0];
% while(imag(alpha) == zeros(1,6))
%     max_x = max_x + 0.01;
%     alpha = kinematics(b, p, s, a, beta, h0, max_x, 0, 0, 0, 0, 0);
% end
% max_x = max_x - 0.01;
% alpha = [0 0 0 0 0 0];
% while(imag(alpha) == zeros(1,6))
%     max_y = max_y + 0.01;
%     alpha = kinematics(b, p, s, a, beta, h0, 0, max_y, 0, 0, 0, 0);
% end
% max_y = max_y - 0.01;
% alpha = [0 0 0 0 0 0];
% while(imag(alpha) == zeros(1,6))
%     max_z = max_z + 0.01;
%     alpha = kinematics(b, p, s, a, beta, h0, 0, 0, max_z, 0, 0, 0);
% end
% max_z = max_z - 0.01;
% alpha = [0 0 0 0 0 0];
% while(imag(alpha) == zeros(1,6))
%     max_roll = max_roll + 0.01;
%     alpha = kinematics(b, p, s, a, beta, h0, 0, 0, 0, max_roll, 0, 0);
% end
% max_roll = max_roll - 0.01;
% alpha = [0 0 0 0 0 0];
% while(imag(alpha) == zeros(1,6))
%     max_pitch = max_pitch + 0.01;
%     alpha = kinematics(b, p, s, a, beta, h0, 0, 0, 0, 0, max_pitch, 0);
% end
% max_pitch = max_pitch - 0.01;