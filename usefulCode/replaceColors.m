function [newImgName] = replaceColors(imgName,origColors,newColors)
%Takes a .png image, finds all pixels that are of some color, and replace
%them by an alternative color.

[img,map,alpha]=imread(imgName);
[N,M,d]=size(img);
img=reshape(img,N*M,d);
for k=1:size(origColors,1)
    inds=sum(abs(double(img)-origColors(k,:)),2)==0;
    img(inds,:)=repmat(uint8(newColors(k,:)),sum(inds),1);
end
img=reshape(img,N,M,d);
newImgName= [imgName(1:end-4)  '_mod.png'];
imwrite(img,newImgName, 'Alpha', alpha);
figure
subplot(2,1,1)
imshow(imgName)
subplot(2,1,2)
imshow(newImgName)
end

function img=rgb2hex(img)
    img=double(img);
    img=img(:,1)+255*img(:,2)+255*255*img(:,3);
end

function img=hex2rgb(img)
img2(:,1)=mod(img,255);
img2(:,2)=mod((img-img2(:,1))/255,255);
img2(:,3)=mod(((img-img2(:,2))/255 - img(:,1))/255,255);
img=uint8(img2);
end