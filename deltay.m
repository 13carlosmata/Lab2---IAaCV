function res = deltay(operator)

if operator == "sobel"
    res = [1,2,1;0,0,0;-1,-2,-1];
elseif operator == "roberts"
    res = [1,0;0,-1];
elseif operator == "central"
    [du,res] = central_diff(1);
end
end