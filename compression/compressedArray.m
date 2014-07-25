classdef compressedArray
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        originalSize
        compressionMethod
    end
    properties(Hidden)
        compressedData
    end
    
    methods
        function this=compressedArray(compressedData,originalSize,compressionMethod)
            this.compressedData=compressedData;
            this.originalSize=originalSize;
            this.compressionMethod=compressionMethod;
        end
        
        array=decompress(this) %To be implemented on each sub-class
        
        this=compress(array) %To be implemented on each sub-class
        
    end
    
    methods(Static)
        HC=getHuffmanCode(p)
        
        function [words,remainder]=bits2words(bits) %Gets a string of bits (e.g. '10100010001111010') and parses it as uint64, returning an array of uint64 integers (MSB first). If the number of bits is not a multiple of 64, the last remainder bits are returned as a string.
            N=64;
            words=zeros(floor(length(bits)/N),1,'uint64');
            counter=0;
            while length(bits)>=(N*(counter+1))
                counter=counter+1;
                aux=bits(N*(counter-1)+1:N*counter);
                bb=uint64(0);
                for i=1:N
                    aa=uint64(str2double(aux(i)));
                    bb=2*bb+aa;
                end
                words(counter)=bb;
            end
            remainder=bits(N*counter+1:end);
        end
        
        function bits=words2bits(words,remainder) %Essentially reverses the previous function. Remainder input argument is optional.
            N=64;
           for i=1:length(words)
              for j=1:N
                 aux=floor(words(i)/2^(N-j));
                 bits(N*(i-1)+j)=num2str(aux); %Don't know how to pre-allocate for a char array.
                 words(i)=mod(words(i),(2^(N-j)));
              end
           end
           if nargin>1 && ~isempty(remainder)
               bits(end+1:end+length(remainder))=remainder;
           end
        end
    end
    
end

