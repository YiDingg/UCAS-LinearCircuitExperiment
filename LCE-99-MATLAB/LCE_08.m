LCE_08_OpAmpMeasurement

%% 20250530 LM741CN DC 数据处理
%%% 运放测量板测量运放参数
R_7 = 3.9e3;
R_77 = 390e3;
R_6 = 3.9e3;
R_66 = 390e3;

%%% 实验数据处理

% 0. 示波器 dc 校准
V_CH1_0 = -6.154e-3;
V_CH2_0 = 7.863e-3;

% 1. Vos
Vos_TP1 = -420.55e-3;
Vos_TP2 = 19.709e-3;
Vos = (Vos_TP1 - V_CH1_0)/(1001);
disp(['Vos = ', num2str(Vos*1000), ' mV'])

% 2.1 Ib+ (R6) 
Ib_pos_DeltaTP1 = (-187.59e-3) - (-420.5e-3);
Ib_pos_Resistor = R_6;   % R_6 or R_66
Ib_pos = +(Ib_pos_DeltaTP1)/(1001*Ib_pos_Resistor);
disp(['Ib+ = ', num2str(Ib_pos*10^9), ' nA'])

% 2.2 Ib- (R7)
Ib_neg_DeltaTP1 = (-639.45e-3) - (-419.2e-3);
Ib_neg_Resistor = R_7;   % R_7 or R_77
Ib_neg = -(Ib_neg_DeltaTP1)/(1001*Ib_neg_Resistor);
disp(['Ib- = ', num2str(Ib_neg*10^9), ' nA'])

Ib = 0.5*(Ib_pos + Ib_neg);
Ib_os = 0.5*(Ib_pos - Ib_neg);
disp(['Ib    = ', num2str(Ib*10^9), ' nA'])
disp(['Ib_os = ', num2str(Ib_os*10^9), ' nA'])

% 3.1 DC Gain (1)
DC_Gain_1_DeltaTP1 = (-421.35e-3) - (Vos_TP1);
DC_Gain_1_DeltaTP2 = (-7.955) - (Vos_TP2);
Av_dc_1 = 1001*DC_Gain_1_DeltaTP2/DC_Gain_1_DeltaTP1;
disp(['DC Gain 1 = ', num2str(Av_dc_1, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_1))/log(10)), ' dB'])

% 3.2 DC Gain (2)
DC_Gain_2_DeltaTP1 = (-419.65e-3) - (-420.35e-3);
DC_Gain_2_DeltaTP2 = (-7.956) - (20.194e-3);
Av_dc_2 = 1001*DC_Gain_2_DeltaTP2/DC_Gain_2_DeltaTP1;
disp(['DC Gain 2 = ', num2str(Av_dc_2, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_2))/log(10)), ' dB'])

% DC PSRR
PSRR_DeltaVs = 2*(15 - 5);
PSRR_DeltaTP1 = (-445.7e-3) - (-364.14e-3);
PSRR = 1001*PSRR_DeltaVs/PSRR_DeltaTP1;
disp(['DC PSRR = ', num2str(PSRR), ' = ', num2str(20*log(abs(PSRR))/log(10)), ' dB'])

% DC CMRR (1)
CMRR_DeltaVcm = 0.5*(15 - 9) - 0.5*(12 - 12);
CMRR_DeltaTP1 = (-424.3e-3) - (-423.3e-3);
CMRR_1 = 1001*CMRR_DeltaVcm/CMRR_DeltaTP1;
disp(['DC CMRR = ', num2str(CMRR_1), ' = ', num2str(20*log(abs(CMRR_1))/log(10)), ' dB'])

% DC CMRR (2)
CMRR_DeltaVcm = 0.5*(15 - 9) - 0.5*(9 - 15);
CMRR_DeltaTP1 = (-425.05e-3) - (-423e-3);
CMRR_2 = 1001*CMRR_DeltaVcm/CMRR_DeltaTP1;
disp(['DC CMRR = ', num2str(CMRR_2), ' = ', num2str(20*log(abs(CMRR_2))/log(10)), ' dB'])

disp('------------------------------------------------------------------------------')
disp('>>>-------------------------- LM741CN DC 参数汇总 --------------------------<<<')
disp(['Vos = ', num2str(Vos*1000), ' mV'])
disp(['Ib+ = ', num2str(Ib_pos*10^9), ' nA'])
disp(['Ib- = ', num2str(Ib_neg*10^9), ' nA'])
disp(['Ib = ', num2str(Ib*10^9), ' nA'])
disp(['Ib_os = ', num2str(Ib_os*10^9), ' nA'])
disp(['DC Gain (1) = ', num2str(Av_dc_1/1000, '%.4f'), ' V/mV = ', num2str(20*log(abs(Av_dc_1))/log(10)), ' dB'])
disp(['DC Gain (2) = ', num2str(Av_dc_2/1000, '%.4f'), ' V/mV = ', num2str(20*log(abs(Av_dc_2))/log(10)), ' dB'])
disp(['DC PSRR = ', num2str(PSRR/1000, '%.4f'), ' V/mV = ', num2str(20*log(abs(PSRR))/log(10)), ' dB'])
disp(['DC CMRR (1) = ', num2str(CMRR_1/1000, '%.4f'), ' V/mV = ', num2str(20*log(abs(CMRR_1))/log(10)), ' dB'])
disp(['DC CMRR (2) = ', num2str(CMRR_2/1000, '%.4f'), ' V/mV = ', num2str(20*log(abs(CMRR_2))/log(10)), ' dB'])
disp('------------------------------------------------------------------------------')
disp('------------------------------------------------------------------------------')



20250530 LM741CN AC Gain 数据处理
clc, clear
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 250 mVamp, 10 nF + 51 kOhm, 10 Hz to 1 MHz.txt");
stc1 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 1);

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 1 Vamp, 10 nF + 51 kOhm, 100 Hz to 1 MHz.txt");
stc2 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 1);
stc2.axes.XLim(1) = 10;

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 10 Hz to 100 kHz.txt");
stc3 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 0);

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 100 Hz to 100 kHz.txt");
stc4 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 0);

X_1 = [stc1.f; stc2.f; stc3.f; stc4.f];
Y_1 = [stc1.A_v_dB; stc2.A_v_dB; stc3.A_v_dB; stc4.A_v_dB];
X_2 = X_1;
Y_2 = [stc1.A_v_phase; stc2.A_v_phase; stc3.A_v_phase; stc4.A_v_phase];

stc = MyPlot_2window(X_1, Y_1, X_2, Y_2, 1);

% 调整图像属性
stc.ax1.XScale = 'log';
stc.ax1.XTick = logspace(1, 6, 6);
stc.ax1.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
stc.ax1.YLim = [0 120];
%xlim([2e2, 2e5])

stc.ax2.XScale = 'log';
stc.ax2.XTick = logspace(1, 6, 6);
stc.ax1.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
stc.ax2.YLim = [-180 0]; YTick = -180:22.5:0;
stc.ax2.YTick = YTick;
stc.ax2.YTickLabel =  num2str(YTick', '%.1f');

stc.plot1.leg.String = [
    "10 nF + 51 kOhm, input 250 mVamp"
    "10 nF + 51 kOhm, input 1.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 4.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 5.0  Vamp"
    ];
stc.plot1.leg.Location = 'northeast';
stc.plot2.leg.String = [
    "10 nF + 51 kOhm, input 250 mVamp"
    "10 nF + 51 kOhm, input 1.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 4.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 5.0  Vamp"
    ];
stc.plot2.leg.Visible = 'on';
stc.plot2.leg.Location = 'northeast';

stc.plot1.label.x.String = 'Frequency $f$';
stc.plot1.label.y.String = 'Open-Loop Gain $A_v$ (dB)';
stc.plot2.label.x.String = 'Frequency $f$';
stc.plot2.label.y.String = 'Output Phase Shift $\varphi\ (^\circ)$';
MyFigure_ChangeSize(512*[3, 1]);
%MyFigure_ChangeSize_2048x512
%stc.fig.WindowStyle = 'modal';
%MyExport_pdf


20250530 LM741CN CMRR PSRR 数据处理
clc, clear
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, CMRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt");
data(:, 4) = 0.5*data(:, 4);
stc1 = MyDataProcessor_OpAmp_ACCMRR_100Hzto100kHz(data);
%stc1.leg.String = ["CMRR (dB)", "CMRR = 40 dB", "Phase"];
%MyExport_pdf_modal

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, PSRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt");
data(:, 4) = 0.5*data(:, 4);
stc2 = MyDataProcessor_OpAmp_ACPSRR_100Hzto100kHz(data);
%hold(stc2.axes, 'on')
%MyExport_pdf_modal

LM741CN FPBW 数据处理
"D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, Full Power Frequency, input 5Vamp, 100 Hz to 100 kHz.txt"

% 运放测量板测量运放参数
R_7 = 3.9e3;
R_77 = 390e3;
R_6 = 3.9e3;
R_66 = 390e3;



TP1_Vos = -420.55e-3;  % V_IO
TP2_Vos = 19.709e-3;

TP1_Ib_R7 = 3.3392;
TP1_Ib_R6 = 3.6214;

DCGain_1_TP1 = -421.35e-3;
DCGain_1_TP2 = -7.955;
DCGain_2_TP1 = -420.95e-3;
DCGain_2_TP2 = -7.955;
DCGain_mean_TP1 = 0.5*(DCGain_1_TP1 + DCGain_2_TP1);
DCGain_mean_TP2 = 0.5*(DCGain_1_TP2 + DCGain_2_TP2);



TP1_PSRR = 3.3278;
Delta_Vs = 2*(16 - 12);


I_B_neg = -(TP1_Ib_R7 - TP1_Vos)/(R_7*1001);
I_B_neg_2 = -(3.4266 - 3.5654)/(R_7*1001);
I_B_pos = (TP1_Ib_R6 - TP1_Vos)/(R_6*1001);
I_B_pos_2 = (3.72 - 3.5566)/(R_6*1001);
A_v_dc = 1001 * (DCGain_1_TP2 - TP2_Vos) / (DCGain_1_TP1 - TP1_Vos);
A_v_dc_2 = 1001 * (DCGain_2_TP2 - TP2_Vos) / (DCGain_2_TP1 - TP1_Vos);
A_v_dc_mean = 1001 * (DCGain_mean_TP2 - TP2_Vos) / (DCGain_mean_TP1 - TP1_Vos);

PSRR_dc = abs( 1001 * Delta_Vs / (TP1_PSRR - TP1_Vos) );


disp(['V_IO = ', num2str(TP1_Vos/1001 * 1000), ' mV'])
disp(['I_B_neg = ', num2str(I_B_neg*10^9), ' nA'])
disp(['I_B_neg_2 = ', num2str(I_B_neg_2*10^9), ' nA'])
disp(['I_B_pos = ', num2str(I_B_pos*10^9), ' nA'])
disp(['I_B_pos_2 = ', num2str(I_B_pos_2*10^9), ' nA'])
I_B = 0.5*(I_B_pos_2 + I_B_neg_2)*10^9
I_OS = 0.5*(I_B_pos_2 - I_B_neg_2)*10^9

disp(['DC Gain 1 = ', num2str(A_v_dc, '%.2e'), ' = ', num2str(20*log(abs(A_v_dc))/log(10)), ' dB'])
disp(['DC Gain 2 = ', num2str(A_v_dc_2, '%.2e'), ' = ', num2str(20*log(abs(A_v_dc_2))/log(10)), ' dB'])
disp(['DC Gain mean = ', num2str(A_v_dc_mean, '%.2e'), ' = ', num2str(20*log(abs(A_v_dc_mean))/log(10)), ' dB'])
disp(['DC PSRR = ', num2str(PSRR_dc), ' = ', num2str(20*log(PSRR_dc)/log(10)), ' dB'])

GBWP = 2.051e3* 199.4;
disp(['GBWP = ', num2str(GBWP/10^6), ' MHz'])


20250528 ADI op amp 测量方法修正
syms v_out1 A_1 v_out2 R_2 R_3 v_1 omega R_4 A_2 C_1 R_1 R_9 C_3 v_in s

% 代入具体数值
if 0
C_3 = 10e-9;
R_9 = 51e3;
R_1 = 100;
R_2 = 100;
R_3 = 100e3;
R_4 = MyParallel(20, 20);
C_1 = 10e-6;
end

eq1 = v_1 == R_1 / (R_1 + R_9 + 1/(s*C_3)) * v_in
eq2 = v_out1 == A_1 * ( v_out2/(1+R_3/R_2) - v_1 )
eq3 = (v_out1 + v_out2/A_2) / R_4 == (-v_out2/A_2 - v_out2) / (1/s*C_1)
re_v_out2 = solve(eq2, v_out2)
eq3 = subs(eq3, v_out2, re_v_out2);
re_v_out1 = solve(eq3, v_out1);
re_v_out1 = simplifyFraction(re_v_out1)
re_v_out1_dividedBy_v_1 = simplify(re_v_out1/v_1)

limit(re_v_out1_dividedBy_v_1, A_2, inf)
simplify(subs(re_v_out1_dividedBy_v_1, A_2, A_1))


20250528 数据处理代码测试
%% AC Gain 数据处理

% 导入数据
clc, clear, close all
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, discrete uA741, input 1 Vamp, 10 nF + 51 kOhm.txt");
V_in_abs = data(:, 4)';     % AC INPUT, 为参考相位
V_out_abs = data(:, 5)';    % TP2
f = data(:, 1)';
InputPhase = data(:, 2)';
V_out_phase = - InputPhase;

% 先对数据后半段重点滤波
index = 360:length(f);
window = 20;
InputPhase(index) = MyFilter_mean(InputPhase(index), window);
V_in_abs(index) = MyFilter_mean(V_in_abs(index), window);
V_out_phase(index) = MyFilter_mean(V_out_phase(index), window);


% 再对数据整体进行滤波
window = 3;
InputPhase = MyFilter_mean(InputPhase, window);
V_in_abs = MyFilter_mean(V_in_abs, window);
V_out_phase = MyFilter_mean(V_out_phase, window);

% 选择所使用的电容和电阻
if 1 % 51 kOhm + 10 nF
    R_9 = 51e3;
    C_3 = 10e-8;
end
if 0 % 1 MOhm + 1 nF
    R_9 = 1e6;
    C_3 = 1e-9;
end

% 将模长和相位转化为复数表达
R_1 = 100;
v_acin = V_in_abs;
v_TP2 = V_out_abs .* (cosd(V_out_phase) + 1j*sind(V_out_phase));
%v_TP2'
%MyArcTheta_complex_rad(v_TP2)'
%test = atand(real(v_TP2)./imag(v_TP2)) - 180

% 作出 A_v 波特图
A_v = ( 1 + R_9/R_1 + 1./(1j*2*pi.*f*R_1*C_3) ) .* (- v_TP2./v_acin);
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
A_v_phase = MyArcTheta_complex_deg(A_v) - 360;
stc = MyYYPlot(f, f, A_v_dB, A_v_phase);
stc.axes.XScale = 'log';

% 调整图像属性
ylim([0 80])
xlim([2e2, 2e5])
stc.axes.XTick = [2e2, 1e3, 2e3, 1e4, 2e4, 1e5, 2e5];
stc.axes.XTickLabel = ["200 Hz", "1 kHz", "2 kHz", "10 kHz", "20 kHz", "100 kHz", "200 kHz"];
yyaxis('right');
ylim([-180 0])
YTick = -180:22.5:0;
stc.axes.YTick = YTick;
stc.axes.YTickLabel =  num2str(YTick', '%.1f');
stc.axes.XScale = 'log';
stc.leg.String = ["Gain $A_v$ (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Open-Loop Gain $A_v$ (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';

% 导出图像
%MyFigure_ChangeSize_2048x512
%MyExport_pdf


A_v = (1+(1./(2*pi*f*10^(-8))+51000)/100) .* (V_out_abs./V_in_abs);
A_v_dB = 20*log(A_v)/log(10);

stc = MyYYPlot(f, f, A_v_dB, test);
stc.axes.XScale = 'log';
stc.leg.String = ["Gain $A_v$ (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Open-Loop Small-Signal Gain $A_v$ (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';
MyFigure_ChangeSize_2048x512
ylim([0 80])
xlim([2e2, 2e5])
stc.axes.XTick = [2e2, 1e3, 2e3, 1e4, 2e4, 1e5, 2e5]
stc.axes.XTickLabel = ["200 Hz", "1 kHz", "2 kHz", "10 kHz", "20 kHz", "100 kHz", "200 kHz"];
yyaxis('right')
ylim([0 180])
YTick = 0:22.5:180;
stc.axes.YTick = YTick
stc.axes.YTickLabel =  num2str(YTick', '%.1f');

MyPlot(f, A_v.*f)


