function y_final = my_quantizer(y,N,min_value,max_value)

% Need to restrict y inside [min_val,max_val]
if y < min_value
    y = min_value;
end
if y > max_value
    y = max_value;
end

% Find area width step D
D = max_value/(2^(N-1));

% Find the centers
centers = zeros(2^N,1);
centers(1) = max_value - D/2;
centers(2^N) = min_value + D/2;
for i=2:2^N-1
   centers(i) = centers(i-1) - D; 
end

% Find the range of y
for i=1:2^N
    if ( (y <= centers(i)+D/2) && (y>= centers(i)-D/2) )
        y_final = i;
    end
end

% Find quantified sample
y_final = centers(y_final);
    
end

