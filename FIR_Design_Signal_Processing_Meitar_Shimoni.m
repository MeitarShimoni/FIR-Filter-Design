
% % --------------------- Task 1 ---------------------------
% Building 3000 cosine waves with 0 <|f|< 100[Hz] with |a| < 10 and
% |b| < 30.
% Ploting the Sum of the Fourier Transform between -125 <f< 125[Hz]

clc; clear all; close all;
% The following code is to building Bm*cos(2*pi*fm*t);
m=10;
bm = rand(m,1);
% in interval between x_max to x_min: x_min +(x_max-x_min)*rand(n).
min_bm=-30; max_bm=30;
bm = min_bm +(max_bm-min_bm)*bm;

f_min=-100; f_max=100;
fm= f_min +(f_max-f_min)*rand(m,1);
%nyquist
fs=8*f_max; ts=1/fs;

t=0:ts:4;
x2= sum(diag(bm)*cos(2*pi*fm*t));
size(x2); % !! CHECKING !!


% The following code is to building An*cos(2*pi*fn*t);
n=3000; 
an = rand(n,1);
an_min=-10; an_max=10;
an = an_min +(an_max-an_min)*an;
fn= f_min + (f_max-f_min)*rand(n,1);
x1 = sum(diag(an)*cos(2*pi*fn*t));

% xt The total sigma An*cos(2*pi*fn*t) + sigma Bm*cos(2*pi*fm*t)
xt = x1+x2;
% Fourier Transform Ploting when -125 <f< 125 [Hz].
Xf=fft(xt);

N=length(Xf);
f=fs*(-N/2:N/2-1)/N;
%Plot for fft for xt:
plot(f,fftshift(abs(Xf)))
axis([-125,125,0,90e3]);
grid on;
title('Fourier Transform','fontsize',16);
ylabel('\it|X(f)|','fontname','times','fontsize',16);
xlabel('\itf [Hz]','fontname','times','fontsize',16);
size(f); % !! CHECKING !!
% --------------------- Task 2 ---------------------------
% FIR Bandstop Filter 20[Hz]< |f| <40[Hz] with Resolution of
% delta_f = 0.3[Hz].

% Normelizing the frequency to the FIR.
Fn=fs/2;
f_low = 20/Fn; f_high = 40/Fn;
% Getting the Constants of the filter.
[b,a] = fir1(50,[f_low, f_high], 'stop');
[m,w] = freqz(b,a,ceil(length(xt)/2));
% Plot of |H(f)|^2
figure;

plot((w/pi)*fs/2,abs(m).^2); % |H(f)|^2

grid on;
title('Fourier Transform','fontsize',16);
ylabel('\it|H(f)|^2','fontname','times','fontsize',16);
xlabel('\itf [Hz]','fontname','times','fontsize',16);
% The effect of the filter on the signal xt.
x_filered = filter(b,a,xt); 
Xfs_filtered = fftshift(abs(fft(x_filered)).^2); % |Y(f)|^2
% Plot of |Y(f)|^2
hold on
yyaxis right;
plot(f,Xfs_filtered);
%axis([15 22 0 5e9]);
legend('|H(f)|^2','|Y(f)|^2')
ylabel('\it|Y(f)|^2','fontname','times','fontsize',16);

% --------------------- Task 4 ---------------------------
% the effect of H(f)=(1-abs(f)/125)^2 on the original signal xt

H = (1 - abs(f)/125).^2; % Frequency response

% Appling the filter in the frequency domain
X_filtered22 = Xf .* H; 

% Plot the original and filtered in frequency domain.
figure;
subplot(2,1,1);
plot(f,fftshift(abs(Xf).^2));
title('Fourier Transform of the original signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|X(f)|^2','fontname','times','fontsize',16);
xlim([-125 125]);

subplot(2,1,2);
plot(f,fftshift(abs(X_filtered22).^2))
title('Fourier Transform of the filtered signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|Y(f)|^2','fontname','times','fontsize',16);
xlim([-125 125]);
hold on
yyaxis right;
plot(f,abs(H).^2);
legend('|Y(f)|^2','|H(f)|^2')



% --------------------- LCCD ---------------------------

q1=250;
q2=500;

%a=1/(2*(-exp(q1*pi*j)-exp(-q1*pi*j)));
%b=1/(4+exp(q2*pi*j)+exp(-q2*pi*j));
%c=1/(2*(-exp(q1*pi*j)-exp(-q1*pi*j)));

%b4=[a*b*c,a*b,a*c,b*c,a*b*c];
%a4=[a*b*c,0,0,0,0];

a=(2*(-exp(q1*pi*j)-exp(-q1*pi*j)));
b=(4+exp(q2*pi*j)+exp(-q2*pi*j));
c=(2*(-exp(q1*pi*j)-exp(-q1*pi*j)));

b4=[1,c,b,a,1];
a4=[1,0,0,0,0];

[m4,w4] = freqz(b4,a4,ceil(length(xt)/2));

c1=1/(exp(250*pi*j) + exp(-250*pi*j));
b2=[c1,-1,c1];
a2=[c1,0,0];
[m3,w3] = freqz(b2,a2,ceil(length(xt)/2));
%option 1 % Without Square
Y3 = filter(b2,a2,xt);
Yf3 = fftshift(abs(fft(Y3)));
%option 2 With square
Y4 = filter(b4,a4,xt);
Yf4 = fftshift(abs(fft(Y4)));

figure;
subplot(2,1,1);
plot(f,fftshift(abs(Xf).^2))
title('Fourier Transform of the original signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|X(f)|^2','fontname','times','fontsize',16);
xlim([-125 125]);

% Without Square
subplot(2,1,2);
plot(f,Yf3);
title('Fourier Transform of the filtered signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|Y3(f)|^2','fontname','times','fontsize',16);
hold on 
yyaxis right;
ylabel('\it|H(f)|^2','fontname','times','fontsize',16);

% 
figure;
plot(log((w4/pi)*fs/2)/(2*pi),abs(m4)); % |H(f)|^2
hold on
plot((w4/pi)*fs/2,abs(H(end/2:end)));
plot(log((w4/pi)*fs/2)/(2*pi),abs(m3));
legend('LCCD','Original','LCCD not square');
%xlim([-125 125]);

figure;
subplot(2,1,1);
plot(f,fftshift(abs(Xf).^2))
title('Fourier Transform of the original signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|X(f)|^2','fontname','times','fontsize',16);
xlim([-125 125]);

subplot(2,1,2);
plot(f,Yf4);
title('Fourier Transform of the filtered signal');
xlabel('\itf [Hz]','fontname','times','fontsize',16);
ylabel('\it|Y4(f)|^2','fontname','times','fontsize',16);
hold on
yyaxis right;
plot(f,abs(H));
ylabel('\it|H(f)|^2','fontname','times','fontsize',16);
xlim([-125 125]);

%plot((w/pi)*fs/2,abs(m).^2); % |H(f)|^2

%%%%%
figure;
[m4,w4] = freqz(b4,a4,ceil(length(xt)/2));
plot((w4/pi)*fs/2,abs(m4).^2); % |H(f)|^2
hold on
plot(f,abs(H).^2);
legend('LCCD','Original');

%plot(f,Yf4);
%xlim([-125 125]);
