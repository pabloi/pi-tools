function [newColor] = modifyColor(color,modifier)

switch modifier
    case 'darken'
        newColor=color.*[.8,.8,.6];
    case 'lighten'
        newColor=1-((1-color).*[.8,.8,.6]);
        %newColor=sqrt(color);
    case 'greyen'
        newColor=color - .2*(color-mean(color));
    case 'saturate'
        newColor=color + .2*(color-mean(color));
end


end

