function main()

close all;

% Initialize variables
p=8;
N=3;
min_value = -3.5;
max_value = 3.5;
load('source.mat')
x_length = length(x);
R = zeros(p,p);
r = zeros(p,1);

% Calculate array R and vector r
for i=1:p
    sum_r=0;
    for n=p+1:x_length
       sum_r = sum_r + x(n)*x(n-i);
    end
    r(i) = sum_r * 1/(x_length-p); 
    for j=1:p
        sum_R = 0;
        for n=p+1:x_length
           sum_R = sum_R + x(n-j)*x(n-i);
        end
        R(i,j) = sum_R * 1/(x_length-p);
    end
end

% Calculate vector a and its quantified values
a = R\r;
for i=1:p
    a(i) = my_quantizer(a(i),8,-2,2);   % inputs to be usedd are already predefined!
end

% DPCM Encoder
memory = zeros(p,1);
y = zeros(x_length,1);
y_hat = zeros(x_length,1);
y_toned = 0;
for i=1:x_length
    y(i) = x(i) - y_toned;
    y_hat(i) = my_quantizer(y(i),N,min_value,max_value);
    y_hat_toned = y_hat(i) + y_toned;
    memory = [y_hat_toned;memory(1:p-1)];  % 1st element y_hat_toned and all the other memory elements shifted right by 1 place
    y_toned = a'*memory;                       
end

% DPCM Decoder
memory = zeros(p,1);
y_toned = 0;
y_final = zeros(x_length,1);
for i=1:x_length
    y_final(i) = y_hat(i) + y_toned;
    memory = [y_final(i);memory(1:p-1)];
    y_toned = a'*memory;
end

% ----------------------- BULLET 2--------------------------- %
% Plot x and y in the same figure for BULLET 2  (uncomment to execute)
% p = 4 -> N = 1,2,3
% p = 8 -> N = 1,2,3
% plot(x) % plot the initial input signal
% hold
% plot(y) % plot the error prediction signal
% xlabel('Input signal x') 
% ylabel('Error Prediction Signal y') 

% ----------------------- BULLET 3--------------------------- %
% BULLET 3 Median square error and values of a, then diagram of E  (uncomment to execute)
% p = 4:8 -> N=1,2,3 (N values do not reflect on a!)
% E = mean(y.^2) % median square error
% a

% %Initialize E values we gathered
% N_values = [1 2 3];
% E_p4 = [5.7632 2.4177 1.3892];
% E_p5 = [6.4825 2.4136 1.4100];
% E_p6 = [5.3708 2.4385 1.4090];
% E_p7 = [5.5881 2.4665 1.4002];
% E_p8 = [5.4578 2.4819 1.4031];
% 
% %Plot each E for each p, x-axis is N
% hold on;
% plot1 = plot(N_values,E_p4);
% plot2 = plot(N_values,E_p5);
% plot3 = plot(N_values,E_p6);
% plot4 = plot(N_values,E_p7);
% plot5 = plot(N_values,E_p8);
% set(plot1,'Marker','square');
% set(plot2,'Marker','square');
% set(plot3,'Marker','square');
% set(plot4,'Marker','square');
% set(plot5,'Marker','square');
% hold off;
% xlabel('N') 
% ylabel('E(Y^2)') 
% legend('E(Y^2) for p=4','E(Y^2) for p=5','E(Y^2) for p=6','E(Y^2) for p=7','E(Y^2) for p=8')

% ----------------------- BULLET 4--------------------------- %
% Plot x and y_final in the same figure for BULLET 4 (uncomment to execute)
% p = 4 -> N = 1,2,3
% p = 8 -> N = 1,2,3
% plot (x(1:200))     % plot the first 200 elements of input signal x
% hold
% plot (y_final(1:200))  % plot the first 200 elements of the decoding output y_final
% xlabel('Input signal x') 
% ylabel('Decoded Output Signal y') 

end