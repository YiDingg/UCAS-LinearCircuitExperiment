function stc = MyDataProcessor_OpAmp_ACPSRR_100Hzto100kHz(data)
% data: 1    2     3    4
%       f  angle  Vin  Vout
%%
% 读取数据
f           = data(:, 1)';
InputPhase  = data(:, 2)';
V_in_abs    = data(:, 3)';     % AC INPUT, 为参考相位
V_out_abs   = data(:, 4)';     % TP2

V_out_phase = - InputPhase;

% 对数据后半段进行滤波
if 0
    index = floor(length(f)*0.75):length(f);
    window = 20;
    InputPhase(index) = MyFilter_mean(InputPhase(index), window);
    V_in_abs(index) = MyFilter_mean(V_in_abs(index), window);
    V_out_phase(index) = MyFilter_mean(V_out_phase(index), window);
end

% 再对数据整体进行滤波
window = 3;
InputPhase = MyFilter_mean(InputPhase, window);
V_in_abs = MyFilter_mean(V_in_abs, window);
V_out_phase = MyFilter_mean(V_out_phase, window);

% 将模长和相位转化为复数表达
v_W1 = V_in_abs;
v_TP2 = V_out_abs .* (cosd(V_out_phase) + 1j*sind(V_out_phase));

% 求解并作出 PSRR 波特图
PSRR = 2 * ( 101 + 10^5./(1j*2*pi*f) ) .* (v_W1./v_TP2);
PSRR_abs = abs(PSRR);
PSRR_dB = 20*log(PSRR_abs)/log(10);
PSRR_phase = MyArcTheta_complex_deg(PSRR) - 360;
stc = MyYYPlot(f, f, PSRR_dB, PSRR_phase);
stc.axes.XScale = 'log';

% 调整图像属性
ylim([0 120])
xlim([100, 100e3])
%xlim([2e2, 2e5])
stc.axes.XTick = logspace(1, 6, 6);
stc.axes.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
yyaxis('right');
ylim([-180 0])
xlim([100, 100e3])
YTick = -180:22.5:0;
stc.axes.YTick = YTick;
stc.axes.YTickLabel =  num2str(YTick', '%.1f');
stc.axes.XScale = 'log';
%stc.leg.String = ["PSRR (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Power-Supply Rejection Ratio (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';

yyaxis('left')
ylim([10 90])
yline(46.1070)
stc.axes.YTick = 20:10:100;
stc.leg.String = ["PSRR (dB)", "PSRR = 46.1 dB", "Phase $\varphi\ (^\circ)$"];


% 返回结果
stc.f = f;
stc.PSRR = PSRR;
stc.PSRR_abs = PSRR_abs;
stc.PSRR_dB = PSRR_dB;
stc.PSRR_phase = PSRR_phase;

end