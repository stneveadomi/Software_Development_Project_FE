
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

%read initial highscores
[scores names] = xlsread('highscores.xlsx');

%if the game is paused
paused=0;

%this is the time between each refresh of the snake.
speed=0.003;

%if the actual game is running.
currently = 1;

%this determines the direction of the snake UP - 1 , RIGHT - 0 , DOWN - 3 ,
%LEFT - 2
%start snake going in the right direction.
snake_direction = 0;

%this controls how much space between the snake body parts. DONT TOUCH
snake_speed = 0.1;

%creates figure, name disp
disp=figure('units','pixels','Name','Snake the Game','Color','black');
%get screensize and set it to the Position parameter
SCREEN_DIMENSIONS = get(0,'Screensize');
%player's score, by default 0.
PLAYER_SCORE=0;
%running is a boolean variable that breaks the main loop if the game is running or
%not.
running = 1;
%width and height of window, not the actual graph.
WIDTH = 700;
HEIGHT = 700;
%width and height of the graph 0<X<100 and 0<Y<100
GRAPH_WIDTH=50;
GRAPH_HEIGHT=50;
%dimensions in pixels of the screen laid out.
PLOT_DIMENSIONS = [SCREEN_DIMENSIONS(3)/2-WIDTH/2 SCREEN_DIMENSIONS(4)/2-HEIGHT/2 WIDTH HEIGHT];

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
set(gca,'Color','black');
set(gca,'XColor',[1 0 1]);
set(gca,'YColor',[1 0 1]);
set(gca,'LineWidth',2);
set(gca,'Position',[0.1,0.1,0.8,0.8]);
hold on

%display main menu
mainMenu();


%snake body stored in groups of X,Y;
%first body part is the first column, etc.
snake_body = zeros(2,10000);

snake_body = [GRAPH_WIDTH/2, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-snake_speed, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-2*snake_speed, GRAPH_HEIGHT/2;];
growSnake(50);
egg_position=[randi([1,GRAPH_WIDTH-1]),randi([1,GRAPH_HEIGHT-1])];
%initial plot of the snake body, represented by snake_actual. Green squares
%with a marker size of 10.
snake_plot=plot(snake_body(:,1),snake_body(:,2),'go','MarkerSize',12);
set(snake_plot,'MarkerFaceColor','g');

%this plots the egg initially
egg_plot=plot(egg_position(1,1),egg_position(1,2),'rh','MarkerSize',12,'MarkerFaceColor','r');



%used to display text
txt1 = 0;
txt2 = 0;
txt3 = 0;


%display title
title('Snake','Color','white','FontName','Rockwell','FontSize',20);
%set the initial score
setScore()

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
        end
        paused=0;
    end

%draws the snake on the board by resetting the x data and the y data.
    function drawSnake()
        %sets all the x values of the snake body to the x data.
        set(snake_plot, 'XData',snake_body(:,1));
        %sets all the y values of the snake body to the y data.
        set(snake_plot,'YData',snake_body(:,2));
        
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
        %find the difference between the xy value of the 2nd to last segment of
        %the snake and the last segment of the snake. Use this difference to
        %find the position of the new snake segment. Repeat this till the for
        %loop finishes, essentially increase the snake body by value of size.
        diff=snake_body(end-1,:)-snake_body(end,:);
        
        %for i=1 till i=size,
        
        for i=1:size
            snake_body(end+1,:)=snake_body(end,:)-diff;
        end
    end

%This function returns a boolean value if the snake is colliding. If the
%function returns a value of 1 if there is a collision, 0 if there isnt.
    function bool=collision()
        %if the head equals 0 in the x or y or the graph boundaries, return
        % 1 for a collision.
        if(snake_body(1,1)>=GRAPH_WIDTH-0.8||snake_body(1,2)>=GRAPH_HEIGHT-0.8||snake_body(1,1)<=0.8||snake_body(1,2)<=0.8)
            bool=1;
            return;
        end
        if(ismember(snake_body(1,:),snake_body(2:end,:),'rows'))
            bool=1;
            return;
        end
        bool=0;
    end

%this function checks if the snake head is within 1 unit of the marker
%position, if so, grow snake and reset egg.
    function collisionEgg()
        difference=egg_position-snake_body(1,:);
        if (difference(1)<1.4&&difference(1)>-1.4)&&(difference(2)<1.4&&difference(2)>-1.4)
            growSnake(40);
            PLAYER_SCORE=PLAYER_SCORE+10;
            setEgg();
        end
    end

%this function gets a new egg position and updates the egg on the graph
    function setEgg()
        getEggPosition();
        set(egg_plot,'XData',egg_position(1),'YData',egg_position(2));
        rgb=randomColor();
        set(egg_plot,'MarkerEdgeColor',rgb);
        set(egg_plot,'MarkerFaceColor',rgb);
        setScore();
    end

%this function retrieves a random xy coordinate that is not colliding with
%the snake and within bounds, then sets that as the new egg_position.
    function getEggPosition()
        noconflict=1;
        while noconflict
            temp=[randi([1,GRAPH_WIDTH-1]),randi([1,GRAPH_HEIGHT-1])];
            for i=1:length(snake_body)
                difference=snake_body(i,:)-temp;
                if(difference(1)<1.4&&difference(1)>-1.4)&&(difference(2)<1.4&&difference(2)>-1.4)
                    noconflict=0;
                end
            end
            if ~noconflict
                noconflict=1;
            else
                noconflict=0;
            end
        end
        egg_position=temp;
    end

%this function updates the score at the bottom of the
    function setScore()
        xlabel(['SCORE: ',num2str(PLAYER_SCORE)],'FontSize',20,'Color','w','FontName','Cambria');
    end

%this function returns a 1x3 array of random values between 0-1,
%essentially a random RGB value.
    function rgb=randomColor()
        r=randi(10)/10;
        g=randi(10)/10;
        b=randi(10)/10;
        rgb=[r g b];
    end
    
    %this updates the score values from the xl document.
    function updateScores()
        [scores names] = xlsread('highscores.xlsx');
    end

    %this function takes in the index of the new high score and then shifts
    %the scores and names accordingly, also it receives the name value from
    %the user by using a inputdlg.
    function newHighScore(index)
        scores(index+1:end)=scores(index:end-1);
        names(index+1:end)=names(index:end-1);
        scores(index)=PLAYER_SCORE;
        names(index)=inputdlg('Enter your high score name:','Snake');
        writeScores();
        
    end
    
    %this function writes the current values of scores and names to the
    %Excel file in the appropriate columns.
    function writeScores()
        xlswrite('highscores.xlsx',scores,'score','B1:B10');
        xlswrite('highscores.xlsx',names,'score','A1:A10');
    end
    
    %this function creates the string for the score board that will be
    %displayed in a text obj
    function arr=displayScoreBoard()
        arr = sprintf(['=====Top 10 High Scores=====\n',...
               ' 1: ', names{1},'     ',num2str(scores(1)), '\n'...
               ' 2: ', names{2},'     ',num2str(scores(2)), '\n'...
               ' 3: ', names{3},'     ',num2str(scores(3)), '\n'...
               ' 4: ', names{4},'     ',num2str(scores(4)), '\n'...
               ' 5: ', names{5},'     ',num2str(scores(5)), '\n'...
               ' 6: ', names{6},'     ',num2str(scores(6)), '\n'...
               ' 7: ', names{7},'     ',num2str(scores(7)), '\n'...
               ' 8: ', names{8},'     ',num2str(scores(8)), '\n'...
               ' 9: ', names{9},'     ',num2str(scores(9)), '\n'...
               '10: ', names{10},'     ',num2str(scores(10)), '\n']);
               
        return;
    end
    

    function closeMenu()
        snake_body = zeros(2,10000);
        drawSnake;
        set(egg_plot,'XData',-2,'YData',-2);
        txt1=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+10,['Your Score: ',num2str(PLAYER_SCORE)]);
        txt1.Color='green';
        txt1.FontSize=24;
        txt1.FontName='Impact';
        txt1.HorizontalAlignment='center';
        text_3='Sorry, you did not make the score board, try again!';
        for i=1:length(scores)
            if scores(i)<=PLAYER_SCORE
                text_3='Congratulations, you made the Big Ten!';
                newHighScore(i);
                break;
            end
        end
        txt3=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+20,text_3);
        txt3.Color='y';
        txt3.FontSize=18;
        txt3.HorizontalAlignment='center';
        txt2=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2-10,displayScoreBoard());
        txt2.Color='w';
        txt2.FontSize=14;
        txt2.HorizontalAlignment='center';
        %paused=1;
        pause(2);
        %prompt player to see if they would like to play again.
        promptstr=questdlg('Would you like to play again?','Snake','Yes','No','No');
        if isequal(promptstr,'Yes')
            currently=1;
        else
            currently=0;
        end
        
    end

    %this function resets all the important values of the game in order to play
    %another game.
    function reset()
        updateScores();
        snake_direction = 0;
        snake_body = zeros(2,10000);
        snake_body = [GRAPH_WIDTH/2, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-snake_speed, GRAPH_HEIGHT/2; GRAPH_WIDTH/2-2*snake_speed, GRAPH_HEIGHT/2;];
        growSnake(50);
        PLAYER_SCORE = 0;
        setScore();
        txt1.String='';
        txt2.String='';
        txt3.String='';
        drawSnake;
        setEgg();
        running=1;
    end
    
%this function displays the main menu and waits for the user to enter a key
%in order to continue.
    function mainMenu
        %mtxt1,2,3,4 all are various text strings to be displayed.
        mainlogo='SNAKE';
        %place the text on the figure
        mtxt1=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+20,mainlogo);
        %more properties of each text
        mtxt1.Color='w';
        mtxt1.FontSize=40;
        mtxt1.HorizontalAlignment='center';
        mtxt1.FontName='Rockwell';
        %this continues for the rest.
        credits = 'Created by Steven Neveadomi, Bryce Pember, Lillian Ostrander, and Tori Aber';
        mtxt2=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+14,credits);
        mtxt2.Color='green';
        mtxt2.FontSize=10;
        mtxt2.FontWeight='bold';
        mtxt2.HorizontalAlignment='center';
        mtxt2.FontName='Rockwell';
        instructions = sprintf('Objective: Eat as many eggs as possible while\n your snake grows longer and longer.\nAvoid running into the walls or into yourself.\n Compete with friends to see\n who can achieve the highest score.\n\nInstructions: Use the arrow keys to \nchange the direction of the snake.\nPress the escape key to instantly end your game.');
        mtxt3=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2,instructions);
        mtxt3.Color='white';
        mtxt3.FontSize=16;
        mtxt3.FontWeight='bold';
        mtxt3.HorizontalAlignment='center';
        mtxt3.FontName='Rockwell';
        startmsg = sprintf('PRESS ANY KEY TO BEGIN');
        mtxt4=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2-15,startmsg);
        mtxt4.Color='[1 1 0]';
        mtxt4.FontSize=20;
        mtxt4.FontWeight='bold';
        mtxt4.HorizontalAlignment='center';
        mtxt4.FontName='Terminal';
        %pause the game until a key is entered.
        paused=1;
        while paused
            pause(0.1);
            %while paused, make the enter button flash random colors
            mtxt4.Color=randomColor();
        end
        %after entering a key, clear out the text and begin the game.
        mtxt1.String='';
        mtxt2.String='';
        mtxt3.String='';
        mtxt4.String='';
    end
    
    %this function uses text to countdown on the screen.
    function countDown()
        txt=text(GRAPH_WIDTH/2,GRAPH_HEIGHT/2+10,'3');
        txt.Color = 'red';
        txt.FontSize = 64;
        txt.FontName = 'IMPACT';
        txt.HorizontalAlignment = 'center';
        pause(1);
        set(txt,'String','2');
        txt.Color = 'yellow';
        pause(1);
        set(txt,'String','1');
        txt.Color = 'g';
        pause(1);
        txt.Color = 'w';
        set(txt,'String','GO!');
        pause(0.5);
        set(txt,'String','');
    end


%------MAIN---------
%while currently running the game itself



while currently
    
%while mid game
countDown();
while running
    
    moveSnake();
    drawSnake;
    if (collision())
        %[y,Fs]=audioread('0477.wav');
        %sound(y,Fs);
        running=0;
    end
    collisionEgg();
    pause(speed);
end

closeMenu();
reset();
end

close all;
end

