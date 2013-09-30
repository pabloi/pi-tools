function s=num2letras(x,n)

%Convierte números enteros a un string de n dígitos
s=[];

if x==0
    for i=1:n
        s=[s '0'];
    end
else
    t=floor(log(x)/log(10))+1; %Dígitos necesarios para la representación
    if n<t
        disp('Se establecieron menos dígitos de los necesarios, se devuelven los n-últimos');
        s=num2str(x);
        s=s(end-n+1:end);
    else
        for i=1:(n-t)
            s=[s '0'];
        end
        s=[s num2str(x)];
    end
end

end