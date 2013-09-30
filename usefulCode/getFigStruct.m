function [a,b] = getFigStruct(N)
%UNTITLED Calculate best subfigure divide (a x b) for showing N graphs
%When you want to plot N graphs in a single figure, you first have to
%decide how the plots will be arranged in rows & columns. This function
%determines the optimal number of rows and columns for a 16:9 monitor
%resolution ratio.

%2x1
%2x2
%3x2
%4x2
%4x3
%5x3
%

a=1;
b=1;

while (a*b)<N
   if (((a+1)/b-16/9)^2 > (a/(b+1)-16/9)^2 )
       b=b+1;
   else
       a=a+1;
   end
end

end

