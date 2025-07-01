%% 20250418 LCE-03 功率放大器

clc, clear, close all
% 导出波形数据分析失真度
%stc = MyOscilloscope_MSO2202A_Read_OneCh(2)
stc = MyOscilloscope_MSO2202A_read_alldata(2, 3);
stc.stc_spectrum.ax1.XLim = [0 100e3];

stc.stc_spectrum.ax1.YScale = 'log';
stc.stc_spectrum.ax1.YLim = [1e-4 10^1];
stc.stc_spectrum.ax1.YTick = logspace(-4, 1, 6);
%MyExport_pdf_docked

%save('LCE-03 (20250418) 功率放大器输出数据 (input 370mVpp 3kHz, Load 3R75 Ohm).mat', 'stc')
%save('LCE-03 (20250418) 功率放大器输出数据 (input 370mVpp 3kHz, Load 3R75 Ohm).txt', 'data', '-ascii')

load("LCE-03 (20250418) 功率放大器输出数据 (input 370mVpp 3kHz, Load 3R75 Ohm).mat");

amp = stc.stc_spectrum.P1;
f = stc.stc_spectrum.f;
step = 3000;
f_max_array = [1e5, 1e6, 1e7, f(end)];
distor_total_array = zeros(size(f_max_array));

for k = 1:length(f_max_array)
    f_max = f_max_array(k);
    f_array = 3e3:3e3:f_max;
    len = length(f_array);
    
    amp_array = zeros(size(f_array));
    search = 3; % 共 search*2 + 1 个点
    for i = 1:len
        tv = find(f > f_array(i), 1);
        [~, ind] = max( amp((tv-search):(tv+search)) );
        tv = tv - search - 1 + ind;
        amp_array(i) = amp(tv);
    end
    
    % 计算各谐波失真和总谐波失真
    distor = amp_array./amp_array(1) * 100;  % unit: %
    distor_total = norm(distor(2:end));
    distor_total_array(k) = distor_total;
    %disp(['f_max = ', num2str(f_max)])
end

f_array
distor_total_array  % 总谐波失真结果


% 作出谐波失真图
stc2 = MyScatter(f_array, distor);
stc2.axes.YScale = 'log';
%stc2.axes.XScale = 'log';
stc2.axes.YLim = [0 1];
%sizedata = distor./distor(1) * 400;
%sizedata(sizedata < 100) = 100;
sizedata = zeros(size(distor)) + 100;
sizedata(1:10) = 400;

stc2.scatter.scatter_1.SizeData = 200;
MyFigure_ChangeSize_2048x512;
stc2.label.x.String = 'Freuqency $f$ (Hz)';
stc2.label.y.String = 'Percent of Harmonic Distortion';
stc2.axes.YTickLabel =  [{'0.01 %'}
                            {'0.1 %'}
                            {'1 %' }];
stc2.leg.Visible = 'off';
stc2.axes.XLim = [0 5e7] ;
%MyExport_pdf
stc2.axes.XScale = 'log';
stc2.axes.XLim = [1000 5e7] 
%MyExport_pdf

% 30 Ohm 效率
R_L = 30
V_out_pp = 27.9
V1 = 14.995 
I1 = 0.158
V2 = 14.999
I2 = 0.154


VCC = 15
P1 = V1*I1
P2 = V2*I2
V_out_amp = V_out_pp/2
P_out_av = V_out_amp^2/(2*R_L)
P_DC_av = V1*I1 + V2*I2
eta_1 = P_out_av/P_DC_av
eta_2 = pi*V_out_amp/(4*VCC)

% 3.75 Ohm 效率
R_L = 3.75
V_out_pp = 24.7
V1 = 14.994
I1 = 1.043
V2 = 14.999
I2 = 1.047


VCC = 15
P1 = V1*I1
P2 = V2*I2
V_out_amp = V_out_pp/2
P_out_av = V_out_amp^2/(2*R_L)
P_DC_av = V1*I1 + V2*I2
eta_1 = P_out_av/P_DC_av
eta_2 = pi*V_out_amp/(4*VCC)