classdef diffCompressedArray <  compressedArray
    %subclass of compressedArray. Compression is done first by computing
    %the diff of the array along one of its dimensions. The first slice
    %along that dimension is stored as-is, and for the following slices the
    %data is compressed according to simpleCodedArray.
    
    %In the future could implement storing more than just the first slice
    %as is, to minimize computation time if the matrix is to be restored
    %only partially.
    %Because of the diff, there is a double exponential default codeTable.
    
    properties
    end
    properties(Constant)
        compressionMethod='diff';
    end
    properties(Hidden)
        codeTable
        compressionDim
    end
        
    
    methods
        function this=diffCompressedArray(compressedData,originalSize,compressionDim,codeTable)
           this@compressedArray(compressedData,originalSize,'diff');
           this.compressionDim=compressionDim;
           this.codeTable=codeTable; %Needs to be an empty array in the case that the default code table is used (default: first bit is sign, [magnitude-1] (needs to be integer) is stored in # of trailing 1's, 0 is closing bit.
        end
        
        function array=decompress(this)
            permutedSize=[this.originalSize(this.compressionDim) this.originalSize([[1:this.compressionDim-1],[this.compressionDim+1:length(this.originalSize)]])];
            array=zeros(permutedSize);
            array(1,:)=this.compressedData(1,:);
            if isempty(this.codeTable)
                for i=2:permutedSize(1)
                   array(i,:)=array(i-1,:)+... 
                end
            else
                
            end
            
        end
    end
    
end

