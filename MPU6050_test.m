clear all
delete(instrfind)
scom = serial('COM11','BaudRate',38400);

gx = 0;
gy = 0;
gz = 0;
j = 1;
trigger = -1
fopen(scom);
fprintf(scom,'a')
c1 = clock;
while j <= 5000
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
j./(c2(5)*60+c2(6)-c1(5)*60-c1(6))
figure();
plot(gx);
hold on;
plot(gy);
plot(gz);
hold off;

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

gxp = phase(gxf);
gyp = phase(gyf);
gzp = phase(gzf);
gxf = abs(gxf);
gyf = abs(gyf);
gzf = abs(gzf);

% figure();
% plot(gxf(2:end));
% hold on;
% plot(gyf(2:end));
% plot(gzf(2:end));
% hold off;
% figure();
% hold on;
% plot(gxp(2:end));
% plot(gyp(2:end));
% plot(gzp(2:end));
% hold off;
signal = [gxp(2:end)',gxf(2:end)',gyp(2:end)',gyf(2:end)',gzp(2:end)',gzf(2:end)'];
csvwrite('7/7_'+int2str(count), signal);