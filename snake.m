
%************************************************
%* Name: Steven Neveadomi Date: 10/27/17 *
%* Seat/Table: 47 File: Class_SDP_Prep_App.m *
%* Instructor: Bixler 11:10 *
%************************************************

%-------MAIN SCRIPT--------

function [] = snake()
close all;
clear all;
clc;

PAUSE=0.1;
%snake body stored in groups of X,Y;
%first body part is the first column, etc.
snake_body = [50, 50; 48, 50; 48, 48;];

%this determines the direction of the snake UP - 1 , RIGHT - 0 , DOWN - 3 ,
%LEFT - 2
%start snake going in the right direction.
snake_direction = 0;

%this controls how much space between the snake body parts. keep at 2.
snake_speed = 2;

%creates figure, name fig
disp=figure('Name','Pong','Color','white');
%get screensize and set it to the Position parameter 
SCREEN_DIMENSIONS = get(0,'Screensize');

running = 1;
%width and height of window
WIDTH = 700;
HEIGHT = 700;
%width and height of the graph
GRAPH_WIDTH=100;
GRAPH_HEIGHT=100;
%dimensions in pixels of the screen laid out.
PLOT_DIMENSIONS = [(SCREEN_DIMENSIONS(3)-WIDTH)/2 (SCREEN_DIMENSIONS(4)-HEIGHT)/2 WIDTH HEIGHT];
%set the figure into the center of screen with proper dimensions
set(disp,'Position',PLOT_DIMENSIONS);
%turn off Resize, toolbar, and menubar (all unnecessary).
set(disp,'Resize','off');
set(disp,'ToolBar','none');
set(disp,'MenuBar','none');
%within the figure, anytime a key is pressed, send the data of the key
%pressed to the KeyPress function created.
set(disp,'KeyPressFcn',@keyPress);
%makes figure boxed in
box on;

%set axii to the graph width and height
axis([0 GRAPH_WIDTH 0 GRAPH_HEIGHT]);
axis manual;
%remove the ticks
set(gca,'YTick', [],'XTick',[]);
hold on
snake_actual=plot(snake_body(:,1),snake_body(:,2),'gs','MarkerSize',10);

function turnCCW
    if(snake_direction==3)
        snake_direction=0;
    else
    snake_direction=snake_direction+1;
    end
end

function turnCW
    if(snake_direction==0)
        snake_direction=3;
    else
    snake_direction=snake_direction-1;
    end
end

function keyPress(src, event)
    switch(event.Key)
        case 'uparrow'
            if(snake_direction==0)
                turnCCW;
            end
            if(snake_direction==2)
                turnCW;
            end
        case 'downarrow'
            if(snake_direction==0)
                turnCW;
            end
            if(snake_direction==2)
                turnCCW;
            end
        case 'leftarrow'
            if(snake_direction==1)
                turnCCW;
            end
            if(snake_direction==3)
                turnCW;
            end
        case 'rightarrow'
            if(snake_direction==1)
                turnCW;
            end
            if(snake_direction==3)
                turnCCW;
            end
    end
end


function drawSnake()
%sets all the x values of the snake body to the x data.
set(snake_actual, 'XData',snake_body(:,1));
%sets all the y values of the snake body to the y data.
set(snake_actual,'YData',snake_body(:,2));

end

function moveSnake()

    snake_body(2:end,:)=snake_body(1:end-1,:);
    if snake_direction==0
    snake_body(1,:)=[snake_body(1,1)+snake_speed,snake_body(1,2)];
    elseif snake_direction==1
    snake_body(1,:)=[snake_body(1,1),snake_body(1,2)+snake_speed];
    elseif snake_direction==2
    snake_body(1,:)=[snake_body(1,1)-snake_speed,snake_body(1,2)];
    else
    snake_body(1,:)=[snake_body(1,1),snake_body(1,2)-snake_speed];
    end
    
end
function setup
%snake body stored in groups of X,Y;
%first body part is the first column, etc.
snake_body = [50, 50; 48, 50; 46, 50;];

%this determines the direction of the snake UP - 1 , RIGHT - 0 , DOWN - 3 ,
%LEFT - 2
%start snake going in the right direction.
snake_direction = 0;

%speed of the snake, in units, default is 1, max is 4 units/s.
snake_speed = 0;

%creates figure, name fig
disp=figure('Name','Pong','Color','white');
%get screensize and set it to the Position parameter 
SCREEN_DIMENSIONS = get(0,'Screensize');

running = 1;
%width and height of window
WIDTH = 700;
HEIGHT = 700;
%width and height of the graph
GRAPH_WIDTH=100;
GRAPH_HEIGHT=100;
%dimensions in pixels of the screen laid out.
PLOT_DIMENSIONS = [(SCREEN_DIMENSIONS(3)-WIDTH)/2 (SCREEN_DIMENSIONS(4)-HEIGHT)/2 WIDTH HEIGHT];
%set the figure into the center of screen with proper dimensions
set(disp,'Position',PLOT_DIMENSIONS);
%turn off Resize, toolbar, and menubar (all unnecessary).
set(disp,'Resize','off');
set(disp,'ToolBar','none');
set(disp,'MenuBar','none');
%makes figure boxed in
box on;

%set axii to the graph width and height
axis([0 GRAPH_WIDTH 0 GRAPH_HEIGHT]);
axis manual;
%remove the ticks
set(disp,'YTick', [],'XTick',[]);
hold on
snake_actual=plot(snake_body(:,1),snake_body(:,2),'gs','MarkerSize',10);
end


%------MAIN---------
while 1

moveSnake();
drawSnake;
pause(PAUSE);

end
end