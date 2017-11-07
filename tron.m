%-------MAIN SCRIPT-------w-
%Any code within this function is automatically executed on start up as
%this function is the name of the script file.
%this function has no parameters and is the startup for the game
function [] = tron
%close all windows, clear all variables, and clear console screen
close all;
clear;
clc;

%this is the time between each refresh of the snake.
speed=0.035;

%main loop of the game, if the game is currently active.
currently = 1;

%this determines the direction of the snake UP - 1 , RIGHT - 0 , DOWN - 3 ,
%LEFT - 2
%start player1 going in the right direction and player2 in the left.
player1_direction = 0;
player2_direction = 2;

%this controls how much space between the line body parts. DONT TOUCH
bike_speed = 1;

%creates figure, name disp
disp=figure('units','pixels','Name','Tron','Color','white');
%get screensize and set it to the Position parameter
SCREEN_DIMENSIONS = get(0,'Screensize');

%player's score, by default 0.
PLAYER1_SCORE=0;
PLAYER2_SCORE=0;
%running is a boolean variable that breaks the main movement loop if there
%is a collision.
running = 1;

%width and height of the graph 0<X<200 and 0<Y<100
GRAPH_WIDTH=200;
GRAPH_HEIGHT=100;

%dimensions in pixels of the screen laid out.
PLOT_DIMENSIONS = SCREEN_DIMENSIONS;

%set the figure into the center of screen with proper dimensions
set(disp,'Position',PLOT_DIMENSIONS);

%turn off Resize, toolbar, and menubar (all unnecessary).
set(disp,'Resize','off');
set(disp,'ToolBar','none');
set(disp,'MenuBar','none');

%within the figure, anytime a key is pressed, send the data of the key
%pressed to the KeyPress function created.
set(disp,'KeyPressFcn',@keyPress);


%https://www.mathworks.com/help/matlab/ref/matlab.graphics.primitive.text-properties.html
title('TRON','Color','k','FontName','Terminal','FontSize',54);

%makes figure boxed in
box on;



%set axii to the graph width and height
axis([0 GRAPH_WIDTH 0 GRAPH_HEIGHT]);
axis manual;
%remove the ticks
XTick=1:GRAPH_WIDTH;
YTick=1:GRAPH_HEIGHT;

set(gca,'YTick', YTick,'XTick',XTick);
set(gca,'Color','black');
set(gca,'XColor','w');
set(gca,'YColor','w');
set(gca,'LineWidth',1);
set(gca,'Position',[0.1,0.1,0.8,0.8]);
set(gca,'TickLength',[0,0]);
grid on
hold on

%snake body stored in groups of X,Y;
%first body part is the first column, etc.
%preallocating space for the lines to save time.
player1_body=zeros(2,10000);
player2_body=zeros(2,10000);
player1_body=[GRAPH_WIDTH/4 GRAPH_HEIGHT/2;GRAPH_WIDTH/4-bike_speed GRAPH_HEIGHT/2];
player2_body=[GRAPH_WIDTH*3/4 GRAPH_HEIGHT/2;GRAPH_WIDTH*3/4+bike_speed GRAPH_HEIGHT/2];

%initial plot of the snake body, represented by snake_actual. Green squares
%with a marker size of 10.
player1_plot=plot(player1_body(:,1),player1_body(:,2),'bs','MarkerSize',12);
set(player1_plot,'MarkerFaceColor','b');

player2_plot=plot(player2_body(:,1),player2_body(:,2),'rs','MarkerSize',12);
set(player2_plot,'MarkerFaceColor','r');

%this function turns the snake counter clock wise
%UP - 1 , RIGHT - 0 , DOWN - 3 ,LEFT - 2
    function newDir=turnCCW(curDir)
        %if the snake direction is 3, set to 0, as adding 1 to it would break
        %the system. Essentially this is turning it clockwise but due to the
        %nature of the direction system, this is necessary.
        if(curDir==3)
            newDir=0;
        else
            %simply just add 1, changes the direction properly (1->2, up->left)
            newDir=curDir+1;
        end
    end

%this function turns the snake clock wise
%UP - 1 , RIGHT - 0 , DOWN - 3 ,LEFT - 2
    function newDir=turnCW(curDir)
        %must manually set 0 to 3 as subtracting 1 would not work.
        if(curDir==0)
            newDir=3;
        else
            %if it is not at 0, simply subtract 1 to change dir. properly
            %(2->1, left->up)
            newDir=curDir-1;
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
                if(player2_direction==0)
                    %turn the snake upward or counter clock wise
                    player2_direction=turnCCW(player2_direction);
                end
                %and the snake is going to the left
                if(player2_direction==2)
                    %turn the snake downward or clock wise
                    player2_direction=turnCW(player2_direction);
                end
                %if the down arrow is pressed
            case 'downarrow'
                %snake is going to the right
                if(player2_direction==0)
                    %turn down or clock wise
                    player2_direction=turnCW(player2_direction);
                end
                %snake is goig to the left
                if(player2_direction==2)
                    %turn the snake down or counter clock wise
                    player2_direction=turnCCW(player2_direction);
                end
                %if the left arrow is pressed
            case 'leftarrow'
                %snake going up
                if(player2_direction==1)
                    %turn left or counter clock wise
                    player2_direction=turnCCW(player2_direction);
                end
                %snake going down
                if(player2_direction==3)
                    %turn right or clock wise
                    player2_direction=turnCW(player2_direction);
                end
                %if the right arrow is pressed
            case 'rightarrow'
                %if the snake is going up
                if(player2_direction==1)
                    %turn to the right or clock wise
                    player2_direction=turnCW(player2_direction);
                end
                %if the snake is going down
                if(player2_direction==3)
                    %turn to the left or counter clock wise
                    player2_direction=turnCCW(player2_direction);
                end
            case 'w'
                %and the snake is going to the right
                if(player1_direction==0)
                    %turn the snake upward or counter clock wise
                    player1_direction=turnCCW(player1_direction);
                end
                %and the snake is going to the left
                if(player1_direction==2)
                    %turn the snake downward or clock wise
                    player1_direction=turnCW(player1_direction);
                end
                %if the down arrow is pressed
            case 's'
                %snake is going to the right
                if(player1_direction==0)
                    %turn down or clock wise
                    player1_direction=turnCW(player1_direction);
                end
                %snake is goig to the left
                if(player1_direction==2)
                    %turn the snake down or counter clock wise
                    player1_direction=turnCCW(player1_direction);
                end
                %if the left arrow is pressed
            case 'a'
                %snake going up
                if(player1_direction==1)
                    %turn left or counter clock wise
                    player1_direction=turnCCW(player1_direction);
                end
                %snake going down
                if(player1_direction==3)
                    %turn right or clock wise
                    player1_direction=turnCW(player1_direction);
                end
                %if the right arrow is pressed
            case 'd'
                %if the snake is going up
                if(player1_direction==1)
                    %turn to the right or clock wise
                    player1_direction=turnCW(player1_direction);
                end
                %if the snake is going down
                if(player1_direction==3)
                    %turn to the left or counter clock wise
                    player1_direction=turnCCW(player1_direction);
                end
            case 'escape'
                currently = 0;
                running = 0;
            case 'return'
                if ~running
                end
        end
    end

%draws the snake on the board by resetting the x data and the y data.
    function drawLine()
        %sets all the x values of the snake body to the x data.
        set(player1_plot, 'XData',player1_body(:,1));
        %sets all the y values of the snake body to the y data.
        set(player1_plot,'YData',player1_body(:,2));
        
        %sets all the x values of the snake body to the x data.
        set(player2_plot, 'XData',player2_body(:,1));
        %sets all the y values of the snake body to the y data.
        set(player2_plot,'YData',player2_body(:,2))
        
        
    end

%moves the snake in the proper direction.
    function player_body=movePlayers(currentDirection,player_body)
        %now depending on the direction it is going, set the new head position
        %(or first body position) in the correct direction the snake is heading
        player_body(2:end+1,:)=player_body(:,:);
        %eg if snake is going to the right( dir=0)
        if currentDirection==0
            %set the head to the current head position increased by the snake_speed
            %in the x direction (increasing the x position as it is going right)
            %snake_speed is the distance between each segment.
            player_body(1,:)=[player_body(1,1)+bike_speed,player_body(1,2)];
            %if snake going up
        elseif currentDirection==1
            %set the head to the snake_speed + current y, to make it move up.
            player_body(1,:)=[player_body(1,1),player_body(1,2)+bike_speed];
            %same concepts apply
        elseif currentDirection==2
            player_body(1,:)=[player_body(1,1)-bike_speed,player_body(1,2)];
        else
            player_body(1,:)=[player_body(1,1),player_body(1,2)-bike_speed];
        end
        
    end


%This function returns a boolean value if the snake is colliding. If the
%function returns a value of 1 if there is a collision, 0 if there isnt.
    function bool=collision()
        %if the head equals 0 in the x or y or the graph boundaries, return
        % 1 for a collision.
        if(player1_body(1,1)>=GRAPH_WIDTH-0.8||player1_body(1,2)>=GRAPH_HEIGHT-0.8||player1_body(1,1)<=0.8||player1_body(1,2)<=0.8)
            bool=1;
            return;
        end
        if(player2_body(1,1)>=GRAPH_WIDTH-0.8||player2_body(1,2)>=GRAPH_HEIGHT-0.8||player2_body(1,1)<=0.8||player2_body(1,2)<=0.8)
            bool=1;
            return;
        end
        if(isequal(player1_body(1,:),player2_body(1,:)))
            bool=1;
            return;
        end
        for i=2:length(player1_body)
            if(isequal(player1_body(i,:),player1_body(1,:))||isequal(player2_body(i,:),player2_body(1,:)))
                bool=1;
                return;
            end
            diff1=(player1_body(1,:)-player2_body(i,:));
            
            if(diff1(1)<1&&diff1(1)>-1&&diff1(2)<1&&diff1(2)>-1)
                bool=1;
                return;
            end
            diff2=(player2_body(1,:)-player1_body(i,:));
            if(diff2(1)<1&&diff2(1)>-1&&diff2(2)<1&&diff2(2)>-1)
                bool=1;
                return;
            end
        end
        bool=0;
    end


    function setScore()
        xlabel(['PLAYER 1 SCORE: ',num2str(PLAYER1_SCORE),'             PLAYER 2 SCORE: ',num2str(PLAYER2_SCORE)],'FontSize',30,'Color','k','FontName','Terminal');
    end

%This function will only be called when a collision has occured, this
%function checks which player has made the collision and then increases the
%other players score by 1.
    function addScore()
        if(isequal(player1_body(1,:),player2_body(1,:)))
            %tie
            return;
        end
        if(player1_body(1,1)>=GRAPH_WIDTH-0.8||player1_body(1,2)>=GRAPH_HEIGHT-0.8||player1_body(1,1)<=0.8||player1_body(1,2)<=0.8)
            PLAYER2_SCORE=PLAYER2_SCORE+1;
            return;
        end
        if(player2_body(1,1)>=GRAPH_WIDTH-0.8||player2_body(1,2)>=GRAPH_HEIGHT-0.8||player2_body(1,1)<=0.8||player2_body(1,2)<=0.8)
            PLAYER1_SCORE=PLAYER1_SCORE+1;
            return;
        end
        for i=2:length(player1_body)
            if(isequal(player1_body(i,:),player1_body(1,:))||isequal(player2_body(i,:),player1_body(1,:)))
                PLAYER2_SCORE=PLAYER2_SCORE+1;
                return;
            end
            if(isequal(player2_body(i,:),player2_body(1,:))||isequal(player1_body(i,:),player2_body(1,:)))
                PLAYER1_SCORE=PLAYER1_SCORE+1;
                return;
            end
            diff1=(player1_body(1,:)-player2_body(i,:));
            
            if(diff1(1)<1&&diff1(1)>-1&&diff1(2)<1&&diff1(2)>-1)
                PLAYER2_SCORE=PLAYER2_SCORE+1;
                return;
            end
            diff2=(player2_body(1,:)-player1_body(i,:));
            if(diff2(1)<1&&diff2(1)>-1&&diff2(2)<1&&diff2(2)>-1)
                PLAYER1_SCORE=PLAYER1_SCORE+1;
                return;
            end
        end
    end

    function rgb=randomColor()
        r=randi(10)/10;
        g=randi(10)/10;
        b=randi(10)/10;
        rgb=[r g b];
    end

    function countDown()
        txt=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2,'READY!');
        txt.Color = 'red';
        txt.FontSize = 64;
        txt.HorizontalAlignment = 'center';
        pause(1.5);
        set(txt,'String','SET!');
        txt.Color = 'yellow';
        pause(1);
        set(txt,'String','plz send nudes');
        txt.Color = 'green';
        pause(0.5);
        set(txt,'String','');
    end
    
    function closeMenu()
        winner='0';
        if PLAYER1_SCORE>PLAYER2_SCORE
            winner = '1';
        else
            winner = '2';
        end
        txt1=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+20,['THE WINNER IS PLAYER',winner]);
        txt1.Color='white';
        txt1.FontSize=54;
        txt2=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+20,'Play again? Hit return to play again or escape to quit.');
        txt2.Color='white';
        txt2.FontSize=54;
        PLAYER1_SCORE =0;
        PLAYER2_SCORE =0;
    end

    function reset()
        player1_direction = 0;
        player2_direction = 2;
        player1_body=zeros(2,10000);
        player2_body=zeros(2,10000);
        player1_body=[GRAPH_WIDTH/4 GRAPH_HEIGHT/2;GRAPH_WIDTH/4-bike_speed GRAPH_HEIGHT/2];
        player2_body=[GRAPH_WIDTH*3/4 GRAPH_HEIGHT/2;GRAPH_WIDTH*3/4+bike_speed GRAPH_HEIGHT/2];        
    end
%------MAIN---------
while currently
    
    setScore();
    if(PLAYER1_SCORE+PLAYER2_SCORE>4)
        closeMenu();
        tron();
    else
        reset();
        drawLine;
        countDown();
        running=1;
    end
    while running
        
        player1_body=movePlayers(player1_direction,player1_body);
        player2_body=movePlayers(player2_direction,player2_body);
        drawLine;
        if (collision())
            addScore();
            setScore();
            running=0;
        end
        pause(speed);
    end
    
end
close all
end
