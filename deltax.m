function res = deltax(operator)

if operator == "sobel"
    res = [-1,0,1;-2,0,2;-1,0,1];
elseif operator == "roberts"
    res = [0,1;-1,0];
end

end