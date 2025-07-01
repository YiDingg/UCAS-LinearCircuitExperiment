%% 20250516 运放验证 (AC Gain 数据处理)

clc, clear, close all
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, discrete uA741, input 1 Vamp, 10 nF + 51 kOhm.txt");
V_in = data(:, 4)';
V_out = data(:, 5)';
f = data(:, 1)';
phase = data(:, 2)';
phase = MyFilter_mean(phase, 3);

num_filt = 350;
phase(num_filt:end) = MyFilter_mean(phase(num_filt:end), 20);
V_in(num_filt:end) = MyFilter_mean(V_in(num_filt:end), 5);
V_out(num_filt:end) = MyFilter_mean(V_out(num_filt:end), 5);

A_v = (1+(1./(2*pi*f*10^(-8))+51000)/100) .* (V_out./V_in);
A_v_dB = 20*log(A_v)/log(10);

stc = MyYYPlot(f, f, A_v_dB, phase);
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
ylim([-180 0])
YTick = -180:22.5:0;
stc.axes.YTick = YTick
stc.axes.YTickLabel =  num2str(YTick', '%.1f');

MyPlot(f, A_v.*f)

%% 运放测量板测量运放参数
R_7 = 3.9e3;
R_77 = 390e3;
R_6 = 3.9e3;
R_66 = 390e3;



TP1_Vos = 3.5334;  % V_IO
TP2_Vos = 13.579e-3;
TP1_Ib_R7 = 3.3392;
TP1_Ib_R6 = 3.6214;
TP1_DCGain = 4.797;
TP2_DCGain = -8.0405;
TP1_DCGain_2 = 3.9408;
TP2_DCGain_2 = -3.9738;
TP1_PSRR = 3.3278;
Delta_Vs = 2*(16 - 12);


I_B_neg = -(TP1_Ib_R7 - TP1_Vos)/(R_7*1001);
I_B_neg_2 = -(3.4266 - 3.5654)/(R_7*1001);
I_B_pos = (TP1_Ib_R6 - TP1_Vos)/(R_6*1001);
I_B_pos_2 = (3.72 - 3.5566)/(R_6*1001);
A_v_dc = abs( 1001 * (TP2_DCGain - TP2_Vos) / (TP1_DCGain - TP1_Vos));
A_v_dc_2 = abs( 1001 * (TP2_DCGain_2 - TP2_Vos) / (TP1_DCGain_2 - TP1_Vos));
PSRR_dc = abs( 1001 * Delta_Vs / (TP1_PSRR - TP1_Vos) );


disp(['V_IO = ', num2str(TP1_Vos/1001 * 1000), ' mV'])
disp(['I_B_neg = ', num2str(I_B_neg*10^9), ' nA'])
disp(['I_B_neg_2 = ', num2str(I_B_neg_2*10^9), ' nA'])
disp(['I_B_pos = ', num2str(I_B_pos*10^9), ' nA'])
disp(['I_B_pos_2 = ', num2str(I_B_pos_2*10^9), ' nA'])
I_B = 0.5*(I_B_pos_2 + I_B_neg_2)*10^9
I_OS = 0.5*(I_B_pos_2 - I_B_neg_2)*10^9

disp(['DC Gain 1 = ', num2str(A_v_dc), ' = ', num2str(20*log(A_v_dc)/log(10)), ' dB'])
A_v_dc_2
disp(['DC Gain 2 = ', num2str(A_v_dc_2), ' = ', num2str(20*log(A_v_dc_2)/log(10)), ' dB'])
disp(['DC PSRR = ', num2str(PSRR_dc), ' = ', num2str(20*log(PSRR_dc)/log(10)), ' dB'])

GBWP = 2.051e3* 199.4;
disp(['GBWP = ', num2str(GBWP/10^6), ' MHz'])



%% square wave generator 计算
V_OH = 11.5;
V_OL = -10.5;
R_k = 10e3;
R_2 = 10e3;
V_D = 0.6004;
R_f = 10e3;
R_1 = 10e3;
C = 10e-9;

tau_1 = (R_k + R_2)*C
tau_2 = R_2*C
%tau_2 = tau_1

%t_1 =  tau_1 * log(  ( V_OH - V_OL/2 ) / ( V_OH/2 ) )
t_1 = tau_1 * log(  ( V_OH - V_OL/(1 + R_1/R_f) ) / ( V_OH/(1 + R_1/R_f) ) )
t_2 = tau_2 * log(  ( (V_OL + V_D) - V_OH/(1 + R_1/R_f) ) / ( (V_OL + V_D)/((1 + R_1/R_f)) ) )

T = t_1 + t_2
f = 1/T

% square wave generator 计算 (短路 D 和 R_k)
V_OH = 11.5;
V_OL = -10.5;
R_k = 0;
R_2 = 10e3;
V_D = 0;
R_f = 10e3;
R_1 = 10e3;
C = 10e-9;

tau_1 = (R_k + R_2)*C
tau_2 = R_2*C
%tau_2 = tau_1

%t_1 =  tau_1 * log(  ( V_OH - V_OL/2 ) / ( V_OH/2 ) )
t_1 = tau_1 * log(  ( V_OH - V_OL/(1 + R_1/R_f) ) / ( V_OH/(1 + R_1/R_f) ) )
t_2 = tau_2 * log(  ( (V_OL + V_D) - V_OH/(1 + R_1/R_f) ) / ( (V_OL + V_D)/((1 + R_1/R_f)) ) )

T = t_1 + t_2
f = 1/T

% https://www.allaboutcircuits.com/technical-articles/op-amp-and-transistor-analog-square-wave-oscillator-design/
V_OH = 5;
V_OL = -5;
R_k = 0;
R_2 = 1e3;
V_D = 0;
R_f = 10e3;
R_1 = 10e3;
C = 1e-6;

tau_1 = (R_k + R_2)*C
tau_2 = R_2*C
%tau_2 = tau_1

%t_1 =  tau_1 * log(  ( V_OH - V_OL/2 ) / ( V_OH/2 ) )
t_1 = tau_1 * log(  ( V_OH - V_OL/(1 + R_1/R_f) ) / ( V_OH/(1 + R_1/R_f) ) )
t_2 = tau_2 * log(  ( (V_OL + V_D) - V_OH/(1 + R_1/R_f) ) / ( (V_OL + V_D)/((1 + R_1/R_f)) ) )

T = t_1 + t_2
f = 1/T

C = 10e-9;
T = C*(  2*10 + 10 )*10^3 * log(1 + 2*10/10)
f = 1/T
k = 1 / ( 1 + (10 + 5)/(10 + 10) )

V_OH = 11.5;
V_OL = -10.5;
R = (2*10 + 10) * 10^3;
C = 10e-9;
T = -2*R*C*log( V_OH*(1-0.5) / (V_OH - V_OL*0.5) )
f = 1/T

%% 20250513 uA741 理论计算
% 1st stage
V_AN = 100;
V_AP = 70;
I_C = 13e-6;
V_T = 26e-3;
R_E = 1e3;

r_ON = V_AN/I_C
r_OP = V_AP/I_C
g_mN = I_C/V_T
g_mP = I_C/V_T

G_m1 = MyParallel(g_mN, g_mP)
G_m1*1000
R_1 = r_OP + (1+g_mP*r_OP)/g_mN;
R_2 = r_ON + (1 + g_mN*r_ON)*R_E;
R_out1 = MyParallel(R_1, R_2)
A_v1 = G_m1 * R_out1

% 2nd stage
beta = 100;
I_C = 0.7e-3;
g_m2 = I_C/V_T
r_pi2 = beta/g_m2
r_O2 = V_AN/I_C
r_O4 = V_AP/I_C

beta_Eq = beta*(beta + 2)
g_m_eq = g_m2/2
r_O_eq = (V_AN/V_T)/(beta - 1)*r_pi2 + r_O2
r_pi_eq = 2*beta*r_pi2
R_E = 51;

G_m2 = 1 / (R_E + MyParallel(1/g_m_eq, r_O_eq))
G_m2*1000
R_out2 = MyParallel( r_O4, r_O_eq + (1 + g_m_eq*r_O_eq)*MyParallel(R_E, r_pi_eq) )
A_v2 = G_m2*R_out2
R_in = r_pi_eq + R_E * (beta_Eq*r_O_eq + r_O_eq + r_O4) / (R_E + r_O_eq + r_O4)

% overall
A_v = A_v1*R_in/(R_in + R_out1)*A_v2
A_v_dB = 20*log(A_v)/log(10)

% input resistance
I_C = 13e-6;
r_pi = beta*V_T/I_C
R_L = R_1
R_emit_Q10 = (1 + R_L/r_OP) * MyParallel( r_pi / (beta + 1 + R_L/r_OP), r_OP )
R_in = r_pi + (beta + 1) * MyParallel(R_emit_Q10, r_pi)
2*R_in

10^(83.351729/20)