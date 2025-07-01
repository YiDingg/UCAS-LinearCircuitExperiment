function stc = MyDataProcessor_OpAmp_ACCMRR_100Hzto100kHz(data)
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

% 求解并作出 CMRR 波特图
CMRR = ( 101 + 10^5./(1j*2*pi*f) ) .* (- v_W1./v_TP2);
%CMRR = ( 101 ) .* (- v_W1./v_TP2);
CMRR_abs = abs(CMRR);
CMRR_dB = 20*log(CMRR_abs)/log(10);
CMRR_phase = MyArcTheta_complex_deg(CMRR);
stc = MyYYPlot(f, f, CMRR_dB, CMRR_phase);
stc.axes.XScale = 'log';

% 调整图像属性
ylim([0 120])
xlim([100, 100e3])
%xlim([2e2, 2e5])
stc.axes.XTick = logspace(1, 6, 6);
stc.axes.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
yyaxis('right');
ylim([0 180])
xlim([100, 100e3])
YTick = -180:22.5:0 + 180;
stc.axes.YTick = YTick;
stc.axes.YTickLabel =  num2str(YTick', '%.1f');
stc.axes.XScale = 'log';
%stc.leg.String = ["CMRR (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Common-Mode Rejection Ratio (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';

yyaxis('left')
ylim([10 90])
yline(40.0864)
stc.axes.YTick = 20:10:100;
stc.leg.String = ["CMRR (dB)", "CMRR = 40.1 dB", "Phase $\varphi\ (^\circ)$"];


% 返回结果
stc.f = f;
stc.CMRR = CMRR;
stc.CMRR_abs = CMRR_abs;
stc.CMRR_dB = CMRR_dB;
stc.CMRR_phase = CMRR_phase;

end