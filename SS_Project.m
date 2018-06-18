delete(instrfind)
scom = serial('COM3','BaudRate',38400);

gx = 0;
gy = 0;
gz = 0;
j = 1;
trigger = -1;
fopen(scom);
fprintf(scom,'a')
c1 = clock;
while j <= 1500
    if (scom.BytesAvailable)
        t = fgetl(scom);
        t = split(t);
        gx(j) = str2num(t{2});
        gy(j) = str2num(t{3});
        gz(j) = str2num(t{4});
        if j > 1 &&abs(gz(j)-gz(j-1)) > 1000 && trigger < 0
            trigger = j;
        end
        j = j+1;
    end
end
c2 = clock;
fclose(scom)
j./(c2(5)*60+c2(6)-c1(5)*60-c1(6));
% figure();
% plot(gx);
% hold on;
% plot(gy);
% plot(gz);
% hold off;

gx = gx(trigger-10:trigger+500);
gy = gy(trigger-10:trigger+500);
gz = gz(trigger-10:trigger+500);
% figure();
% plot(gx);
% hold on;
% plot(gy);
% plot(gz);
% hold off;

gxf = fft(gx);
gyf = fft(gy);
gzf = fft(gz);

% figure();
% hold on;
% plot(gxf(2:end));
% plot(gyf(2:end));
% plot(gzf(2:end));
% hold off;

gxp = angle(gxf);
gyp = angle(gyf);
gzp = angle(gzf);
gxf = abs(gxf);
gyf = abs(gyf);
gzf = abs(gzf);

%  figure();
%  plot(gxf(2:end));
%  hold on;
%  plot(gyf(2:end));
%  plot(gzf(2:end));
%  hold off;
%  figure();
%  hold on;
%  plot(gxp(2:end));
%  plot(gyp(2:end));
%  plot(gzp(2:end));
%  hold off;

% classify
% modelfile = '1_9_93up.h5';
% classnames = {'9','8','7','6','5','4','3','2','1'};
% net = importKerasNetwork(modelfile,'ClassNames',classnames);
% 
% data = zeros(1,510,6,1);
% 
% signal = [gxf(3:end)',gxp(3:end)',gyf(3:end)',gyp(3:end)',gzf(3:end)',gzp(3:end)'];
% 
% data(1:509,1:6,1) = signal(1:509,1:6);
% 
% input = [1,509,6,1];
% label = classify(net,signal);
% 
% disp(['Result: ', char(label)]);
csvwrite(strcat('dot/dot_',int2str(count),'.csv'), signal);
count = count + 1;
% 
% signal = [gxf(3:256)',gxp(3:256)',gyf(3:256)',gyp(3:256)',gzf(3:256)',gzp(3:256)'];
% this_data = zeros(254,6,1,1);
% this_data(:, :, 1, 1) = signal(:, :);
% otest = predict(net_result, this_data);
% [b, out] = max(otest);
% disp(['Result: ', int2str(out)]);