function matriz=readMultArrayCSV(filename)
%readMultArrayCSV Reads a comma separated file which has multiple arrays
%Takes a filename as input, and reads the file, assuming that the first two
%lines are overhead, the third line is the name of columns, and the fourth
%starts the data, until a blank line or the eof. If a blank line, the
%process starts again from the next line.

%Open file
fid1 = fopen(filename, 'r');
A=textscan(fid1, '%s','Delimiter','\n'); %Separate lines
fclose(fid1);
B=A{1,1}; %For some reason this is necessary

endFile=false;
i=1;
matCount=1;
while ~endFile
    endLoop=false;
    %Initial loop to read empty lines at the beginning
    while (i<=length(B))&&isempty(B{i})
       i=i+1; 
    end
    if i>length(B) %End of file
        endLoop=true;
        if matCount==1
            disp('Error: empty csv file')
            return
        end
    end 
    %Read rows until empty line or eof.
    j=1;
    while ~endLoop
        if (i<=length(B))&&~isempty(B{i})
            matriz{matCount}.Row{j} = textscan(B{i}, '%s', 'Delimiter', ','); 
        else
            endLoop=true;
        end
       i=i+1;
       j=j+1;
    end
    if ~(i>length(B))
        matCount=matCount+1;        
    else
        endFile=true;
    end
    clear Row
end



end

