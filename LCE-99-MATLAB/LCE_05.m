%% LCE-05 精密整流

%% 输出信号 FFT (input 50 Hz)
data = readmatrix("D:\aa_MyExperimentData\LCE (Linear Circuit Experiment)\1N5711 input-output waveform (50 Hz) several circles.txt");
%data = readmatrix("D:\a_RemoteRepo\GH.UCAS-LinearCircuitExpe\LCE-05-精密整流\data\1N4148 input-output waveform (50 Hz).txt");
stc = MyAnalysis_Spectrum_3fig_amp(data(:, 3)', data(:, 1)' - data(1, 1));
stc.ax0.YLim(1) = 0;
stc.ax0.YTick = 0:1:5

%% 输入信号幅度与输出信号平均值
data = [
5.0	3.2680
4.5	2.9419
4.0	2.6175
3.7	2.4219
3.4	2.2269
3.1	2.0314
2.8	1.8358
2.5	1.6408
2.2	1.4454
1.9	1.2505
1.6	1.0425
1.3	0.8472
1.0	0.6526    
];
[fitresult, stc, gof] = MyFit_proportional(data(:, 1)', data(:, 2)', 1);
stc.label.x.String = 'Input amplitude $V_{in,amp}$ (V)';
stc.label.y.String = 'Mean value of the output signal $(V_{out})_{mean}$ (V)';
MyFigure_ChangeSize_2048x512
MyExport_pdf

%% 
V1 = 3.2674 % 50 Hz, input 5Vamp 的输出平均值
V1*0.99


V1 = 3.2679 % 50 Hz, input 5Vamp 的输出平均值
V1*0.99

omega = 2*pi*50;
T = 1/50;
syms t
Vin = 5*sin(omega*t)
mean = 1/T*int(abs(Vin), t, 0, T)
vpa(mean)

V1 = [2.5942, 2.0381, 0.2733]
RMS = [2.8504, 2.3273, 0.9004]
[V1; RMS]/4*5