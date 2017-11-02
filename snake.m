
%************************************************
%* Name: Steven Neveadomi Date: 10/27/17 *
%* Seat/Table: 47 File: Class_SDP_Prep_App.m *
%* Instructor: Bixler 11:10 *
%************************************************

%-------MAIN SCRIPT--------
%Any code within this function is automatically executed on start up as
%this function is the name of the script file.
%this function has no parameters and is the startup for the game
function [] = snake
%close all windows, clear all variables, and clear console screen
close all;
clear all;
clc;

%this is the time between each refresh of the snake.
speed=0.1;


%this determines the direction of the snake UP - 1 , RIGHT - 0 , DOWN - 3 ,
%LEFT - 2
%start snake going in the right direction.
snake_direction = 0;

%this controls how much space between the snake body parts. keep at 2.
snake_speed = 2;

%creates figure, name disp
disp=figure('Name','Snake the Game','Color','black');
%get screensize and set it to the Position parameter 
SCREEN_DIMENSIONS = get(0,'Screensize');
%running is a boolean variable that breaks the main loop if the game is running or
%not.
running = 1;
%width and height of window, not the actual graph.
WIDTH = 700;
HEIGHT = 700;
%width and height of the graph 0<X<100 and 0<Y<100
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

%snake body stored in groups of X,Y;
%first body part is the first column, etc.
snake_body = [GRAPH_WIDTH/2, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-1, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-2, GRAPH_HEIGHT/2;];

%initial plot of the snake body, represented by snake_actual. Green squares
%with a marker size of 10.
snake_actual=plot(snake_body(:,1),snake_body(:,2),'gs','MarkerSize',10);

%this function turns the snake counter clock wise
%UP - 1 , RIGHT - 0 , DOWN - 3 ,LEFT - 2
function turnCCW
    %if the snake direction is 3, set to 0, as adding 1 to it would break
    %the system. Essentially this is turning it clockwise but due to the
    %nature of the direction system, this is necessary.
    if(snake_direction==3)
        snake_direction=0;
    else
        %simply just add 1, changes the direction properly (1->2, up->left)
    snake_direction=snake_direction+1;
    end
end

%this function turns the snake clock wise
%UP - 1 , RIGHT - 0 , DOWN - 3 ,LEFT - 2
function turnCW
    %must manually set 0 to 3 as subtracting 1 would not work.
    if(snake_direction==0)
        snake_direction=3;
    else
    %if it is not at 0, simply subtract 1 to change dir. properly
    %(2->1, left->up)
    snake_direction=snake_direction-1;
    end
end

%this function is embedded into the figure disp which holds the snake. any
%time the user is selected on this figure and presses a key, this function
%is triggered.
function keyPress(src, event)
    %switch statement, event.Key is the key being pressed.
    switch(event.Key)
        %if the up arrow is pressed
        case 'uparrow'
            %and the snake is going to the right
            if(snake_direction==0)
                %turn the snake upward or counter clock wise
                turnCCW;
            end
            %and the snake is going to the left
            if(snake_direction==2)
                %turn the snake downward or clock wise
                turnCW;
            end
        %if the down arrow is pressed
        case 'downarrow'
            %snake is going to the right
            if(snake_direction==0)
                %turn down or clock wise
                turnCW;
            end
            %snake is goig to the left
            if(snake_direction==2)
                %turn the snake down or counter clock wise
                turnCCW;
            end
        %if the left arrow is pressed    
        case 'leftarrow'
            %snake going up
            if(snake_direction==1)
                %turn left or counter clock wise
                turnCCW;
            end
            %snake going down
            if(snake_direction==3)
                %turn right or clock wise
                turnCW;
            end
        %if the right arrow is pressed
        case 'rightarrow'
            %if the snake is going up
            if(snake_direction==1)
                %turn to the right or clock wise
                turnCW;
            end
            %if the snake is going down
            if(snake_direction==3)
                %turn to the left or counter clock wise
                turnCCW;
            end
        case 'escape'
            running = 0;
        case 'g'
            growSnake(1);
            
    end
end

%draws the snake on the board by resetting the x data and the y data.
function drawSnake()
%sets all the x values of the snake body to the x data.
set(snake_actual, 'XData',snake_body(:,1));
%sets all the y values of the snake body to the y data.
set(snake_actual,'YData',snake_body(:,2));

end

%moves the snake in the proper direction.
function moveSnake()
    %set the entire body excluding the head = to the current position of
    %the head and body minus the last body length, essentially removing the
    %last body segment.
    snake_body(2:end,:)=snake_body(1:end-1,:);
    %now depending on the direction it is going, set the new head position
    %(or first body position) in the correct direction the snake is heading
    %eg if snake is going to the right( dir=0)
    if snake_direction==0
    %set the head to the current head position increased by the snake_speed
    %in the x direction (increasing the x position as it is going right)
    %snake_speed is the distance between each segment.
    snake_body(1,:)=[snake_body(1,1)+snake_speed,snake_body(1,2)];
    %if snake going up
    elseif snake_direction==1
    %set the head to the snake_speed + current y, to make it move up.
    snake_body(1,:)=[snake_body(1,1),snake_body(1,2)+snake_speed];
    %same concepts apply 
    elseif snake_direction==2
    snake_body(1,:)=[snake_body(1,1)-snake_speed,snake_body(1,2)];
    else
    snake_body(1,:)=[snake_body(1,1),snake_body(1,2)-snake_speed];
    end
    
end

%this function receives an integer parameter size which determines how many
%snake segments are added. This function works by finding the difference
%between the second to last body segment and the last segment, then uses
%this difference to find the new position of the new segment. Essentially
%this difference tells the direction of how the snake will grow.
function growSnake(size)
    for i=1:size
    diff=snake_body(end-1,:)-snake_body(end,:);
    snake_body(end+1,:)=snake_body(end,:)-diff;
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
while running

moveSnake();
drawSnake;
pause(speed);

end
close all
end