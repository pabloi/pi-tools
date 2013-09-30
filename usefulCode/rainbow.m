function [rgb] = rainbow(color)

%Gets a color string and returns the corresponding RGB code

switch color
    case 'black'
        rgb=[0,0,0];
    case 'blue'
        rgb=[0,0,1];
    case 'white'
        rgb=[1,1,1];
    case 'red'
        rgb=[1,0,0];
    case 'green'
        rgb=[0,1,0];
    case 'dark green'
        rgb=[0,.5,0];
    case 'light blue'
        rgb=[0,.6,1];
    case 'yellow'
        rgb=[0,1,1];
    case 'magenta'
        rgb=[1,0,1];
    case 'orange'
        rgb=[1,.5,0];
    case 'dark orange'
        rgb=[1,.2,0];
    case 'light gray'
        rgb=[.5,.5,5];
    case 'dark gray'
        rgb=[.2,.2,.2];
    case 'purple'
        rgb=[.5,0,1];
    case 'dark yellow'
        rgb=[.8,.8,0];
    case 'rainbow'
        rgb(:,1)=rainbow('red');
        rgb(:,2)=rainbow('orange');
        rgb(:,3)=rainbow('yellow');
        rgb(:,4)=rainbow('green');
        rgb(:,5)=rainbow('light blue');
        rgb(:,6)=rainbow('blue');
        rgb(:,7)=rainbow('purple');
    otherwise
        rgb=[0,0,0]; %Default to black
        disp('Warning in rainbow: unknown string, defaulting to black')
end

