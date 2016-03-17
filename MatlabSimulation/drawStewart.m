function drawStewart(uu,V,F,patchcolors)
    % bring in inputs

    % plot the 3D view of the system
    
    % process inputs to function
    theta1      = uu(1); % roll  angle about x-axis
    theta2      = uu(2); % pitch angle about y-axis
    theta3      = uu(3); % yaw   angle about z-axis
    x           = uu(4); % translation in x
    y           = uu(5); % translation in y
    z           = uu(6); % translation in z
    t           = uu(7); % current time
    ball_rel_x  = uu(8); % ball relative x position
    ball_rel_y  = uu(9); % ball relative y position

    % define persistent variables 
    persistent Stewart_Handle;
    persistent Ball_Handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        % draw the isometric view of the system
        figure(1), clf
        [Vertices,Faces,facecolors] = defineStewartSystem;
        [Stewart_Handle, Ball_Handle] = drawIsoView(Vertices,Faces,facecolors,...
                                               theta1,theta2,theta3,x,y,z,...
                                               [],'normal');                                 
        title('Iso View')
        xlabel('X Position')
        ylabel('Y Position')
        zlabel('Z Position')
        view(32,47)  % set the vieew angle for figure
        graph_size = 50;
        axis([-graph_size,graph_size,-graph_size,graph_size,-graph_size,graph_size]);
        hold on
        
        % draw the planar view of the system
        figure(1), clf
        Planar_View_Handle = drawPlanarView(Vertices,Faces,facecolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');                                 
        title('Planar View')
        xlabel('X Position')
        ylabel('Y Position')
        graph_size = 50;
        axis([-graph_size,graph_size,-graph_size,graph_size]);
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawVehicleBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           vehicle_handle);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function defineStewartSystem
% determines where the starting location of the system is to initialize the
% handles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function defineStewartSystem

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function drawIsoView
% draws the isometric view of they system updating the handles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handle_stew, handle_ball] = drawIsoView(V,F,faces,...
                                               theta1, theta2, theta3, x, y, z,...
                                               handle_stew, handle_ball, mode)
end

%%%%%%%%%%%%%%%%%%%%%%%
function pts=rotate(pts,theta1,theta2,theta3)

  % define rotation matrix (right handed)
  R_roll = [...
          1, 0, 0;...
          0, cos(theta1), sin(theta1);...
          0, -sin(theta1), cos(theta1)];
  R_pitch = [...
          cos(theta2), 0, -sin(theta2);...
          0, 1, 0;...
          sin(theta2), 0, cos(theta2)];
  R_yaw = [...
          cos(theta3), sin(theta3), 0;...
          -sin(theta3), cos(theta3), 0;...
          0, 0, 1];
  R = R_roll*R_pitch*R_yaw;  
    % note that R above either leaves the vector alone or rotates
    % a vector in a left handed rotation.  We want to rotate all
    % points in a right handed rotation, so we must transpose
  R = R';

  % rotate vertices
  pts = R*pts;
  
end
% end rotateVert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function pts = translate(pts,x,y,z)

  pts = pts + repmat([x;y;z],1,size(pts,2));
  
end
% end translate