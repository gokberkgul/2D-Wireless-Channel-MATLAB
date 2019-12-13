freq = 10^9;
Ts = 12*10^-6;
ref1 = [10 100];
ref2 = [10 -100];
x = 50;
c = 3*10^8;
lambda = c/freq;

period_sample = 1000;
tp = linspace(0, 1.1*Ts, 1.1*period_sample);
sl = zeros(1, length(tp));
sl(1:period_sample/2) = 2*tp(1:period_sample/2)/Ts;
sl(period_sample/2+1:period_sample) = 2-2*tp(period_sample/2+1:period_sample)/Ts;
received_signal = zeros(1, length(tp));

for y = -100:50:100
    %Calculate distances
    d0 = sqrt( (x)^2 + (y)^2 );
    d1 = sqrt( (ref1(1)-x)^2 + (ref1(2)-y)^2 ) + sqrt( (ref1(1)-0)^2 + (ref1(2)-0)^2 );
    d2 = sqrt( (ref2(1)-x)^2 + (ref2(2)-y)^2 ) + sqrt( (ref2(1)-0)^2 + (ref2(2)-0)^2 );
    %Channel gain
    a0 = lambda/(4*pi*d0);		
    a1 = lambda/(4*pi*d1);
    a2 = lambda/(4*pi*d2);
    %Propagation delay
    pd0 = d0/c;
    pd1 = d1/c;
    pd2 = d2/c;
    %Shift signals
    shift0 = floor(period_sample*pd0/Ts);
    sl0 = circshift(sl, shift0);
    shift1 = floor(period_sample*pd1/Ts);
    sl1 = circshift(sl, shift1);
    shift2 = floor(period_sample*pd2/Ts);
    sl2 = circshift(sl, shift2);
    %Add all signals with respective gain
    received_signal = a0*sl0 + a1*sl1 + a2*sl2;
    %Calculate energy
    energy = received_signal*received_signal'/period_sample*Ts;
    figure;
	plot(10^9*tp, received_signal);
	title(['Time vs Amplitude for y = ', num2str(y)])
	xlabel('Time (ns)');
	ylabel('Amplitude');
end

