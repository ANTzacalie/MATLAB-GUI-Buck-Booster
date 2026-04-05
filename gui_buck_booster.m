clear all;
close all;

% --- COLOR SETTINGS ---
fntSize = 10;
bgMain = [0.9 0.9 0.9];
bgPanel = [0.94 0.94 0.94];
bgPurple = [0.93 0.91 0.96];
bgBlue = [0.91 0.94 0.97];
bgOrange = [0.96 0.93 0.88];
bgEdit = [1 1 1];
highlightColor = [1 1 0]; % INTENSE YELLOW

% Create the main figure
Fig = figure('Name', 'Buck-Boost Interface', ...
    'Units', 'normalized', ...
    'Position', [0.1 0.1 0.8 0.8], ...
    'NumberTitle', 'off', ...
    'Color', bgMain);

% --- INPUT (RED Panel) ---
P_red = uipanel('Title', 'Input Data', 'FontSize', 11, 'FontWeight', 'bold', ...
    'HighlightColor', 'r', 'BorderWidth', 3, 'ForegroundColor', 'k', ...
    'Units', 'normalized', 'Position', [0.02 0.3 0.22 0.68], 'BackgroundColor', bgPanel);

uicontrol(P_red,'Style','popup','Units','normalized',...
    'Position',[0.05 0.9 0.5 0.06],'String','Buck-Boost','ForegroundColor', 'w','Callback',@updateSim);

P_mod = uipanel(P_red,'Title','Mode','Units','normalized',...
    'Position',[0.6 0.82 0.35 0.15],'BackgroundColor',bgPanel, 'ForegroundColor', 'k');

uicontrol(P_mod,'Style','checkbox','Units','normalized',...
    'Position',[0.1 0.5 0.8 0.4],'String','CCM','Value',1,'ForegroundColor', 'k','Callback',@updateSim);
uicontrol(P_mod,'Style','checkbox','Units','normalized',...
    'Position',[0.1 0.1 0.8 0.4],'String','DCM','ForegroundColor', 'k','Callback',@updateSim);

labels = {'E [V]','Us [V]','Delta U [V]','Is [A]','alpha','f_sw [Hz]'};
values = {'20','40','0.8','3','1.1','40000'};
tags = {'in_E','in_Us','in_DU','in_Is','in_alpha','in_f'};
y_pos = [0.72 0.60 0.48 0.36 0.24 0.10];

% --- ELECTRICAL SCHEME PANEL ---
P_schema = uipanel('Units','normalized','Position',[0.02 0.02 0.28 0.25],...
    'HighlightColor',[0.5 0.8 0.2],'BorderWidth',3,...
    'Title','Schematic','BackgroundColor','w', 'ForegroundColor', 'k');

% Displaying SVG Image
% Note: uiimage is the standard component for SVG support in MATLAB
try
    uiimage(P_schema, 'ImageSource', 'buck_boost.svg', ...
        'Position', [10 10 250 150], 'ScaleMethod', 'fit'); 
catch
    % Fallback message if the SVG file is missing
    uicontrol(P_schema, 'Style', 'text', 'Units', 'normalized', ...
        'Position', [0.1 0.4 0.8 0.2], 'String', 'SVG file not found', ...
        'ForegroundColor', 'r', 'BackgroundColor', 'w');
end

for i=1:6
    uicontrol(P_red,'Style','text','Units','normalized',...
        'Position',[0.05 y_pos(i) 0.35 0.05],'String',labels{i},...
        'BackgroundColor',bgPanel,'FontWeight','bold','ForegroundColor', 'k');
    
    uicontrol(P_red,'Style','edit','Units','normalized',...
        'Position',[0.45 y_pos(i) 0.45 0.06],'String',values{i},...
        'BackgroundColor',bgEdit,'ForegroundColor', 'k','Tag',tags{i},'Callback',@updateSim);
end

% --- MATH (PURPLE Panel) ---
P_purple = uipanel('Title','Calculations','FontSize',11,'FontWeight','bold',...
    'HighlightColor',[0.5 0 0.5],'BorderWidth',3, 'ForegroundColor', 'k', ...
    'Units','normalized','Position',[0.26 0.28 0.23 0.70],'BackgroundColor',bgPurple);

y_calc = [0.85 0.73 0.61];
l_calc = {'Imax [A]','Imin [A]','Lmin [H]'};

for i=1:3
    uicontrol(P_purple,'Style','text','Units','normalized',...
        'Position',[0.05 y_calc(i) 0.35 0.05],'String',l_calc{i},...
        'BackgroundColor',bgPurple,'ForegroundColor', 'k');
end

% Yellow result boxes
txtImax = uicontrol(P_purple,'Style','text','Units','normalized','Position',[0.45 y_calc(1) 0.45 0.07],'BackgroundColor',highlightColor,'FontWeight','bold','ForegroundColor','k','Tag','out_Imax');
txtImin = uicontrol(P_purple,'Style','text','Units','normalized','Position',[0.45 y_calc(2) 0.45 0.07],'BackgroundColor',highlightColor,'FontWeight','bold','ForegroundColor','k','Tag','out_Imin');
txtLmin = uicontrol(P_purple,'Style','text','Units','normalized','Position',[0.45 y_calc(3) 0.45 0.07],'BackgroundColor',highlightColor,'FontWeight','bold','ForegroundColor','k','Tag','out_Lmin');

% --- OUTPUT ---
P_iesire = uipanel(P_purple,'Title','Output Values','Units','normalized',...
    'Position',[0.05 0.03 0.9 0.52],'BackgroundColor',bgPurple, 'ForegroundColor', 'k');

l_ies = {'L [H]','C [F]','R [Ohm]','Duty Cycle (D)'};
y_ies = [0.75 0.53 0.31 0.09];
out_tags = {'out_L','out_C','out_R','out_D'};

for i=1:4
    uicontrol(P_iesire,'Style','text','Units','normalized',...
        'Position',[0.05 y_ies(i) 0.35 0.08],'String',l_ies{i},'BackgroundColor',bgPurple,'ForegroundColor','k');
    
    uicontrol(P_iesire,'Style','text','Units','normalized',...
        'Position',[0.45 y_ies(i) 0.45 0.12],'BackgroundColor',highlightColor,'FontWeight','bold','ForegroundColor','k','Tag',out_tags{i});
end

% --- OPERATING REGIME (ORANGE PANEL) ---
P_orange = uipanel('Title','Operating Mode','FontWeight','bold',...
    'HighlightColor',[1 0.6 0],'BorderWidth',3, 'ForegroundColor', 'k', ...
    'Units','normalized','Position',[0.31 0.02 0.18 0.25],'BackgroundColor',bgOrange);

uicontrol(P_orange,'Style','pushbutton','Units','normalized',...
    'Position',[0.05 0.55 0.42 0.25],'String','Steady State','ForegroundColor','w','BackgroundColor',[0.2 0.2 0.2],'Callback',@updateSim);
uicontrol(P_orange,'Style','pushbutton','Units','normalized',...
    'Position',[0.52 0.55 0.42 0.25],'String','Transient','ForegroundColor','w','BackgroundColor',[0.2 0.2 0.2],'Callback',@updateSim);

uicontrol(P_orange,'Style','text','Units','normalized',...
    'Position',[0.15 0.15 0.15 0.18],'String','N','BackgroundColor',bgOrange,'ForegroundColor', 'k');
uicontrol(P_orange,'Style','edit','Units','normalized',...
    'Position',[0.4 0.15 0.4 0.22],'String','350','BackgroundColor',bgEdit,'ForegroundColor','k','Callback',@updateSim);

% --- SIMULATION RESULTS (BLUE Panel) ---
P_blue = uipanel('Units','normalized','Position',[0.51 0.02 0.47 0.96],...
    'HighlightColor',[0.3 0.6 0.9],'BorderWidth',3, 'ForegroundColor', 'k', ...
    'Title','Simulation Results','BackgroundColor',bgBlue);

ax1 = axes('Parent',P_blue,'Position',[0.12 0.72 0.82 0.2],'Color','w','XColor','k','YColor','k'); grid on;
ax2 = axes('Parent',P_blue,'Position',[0.12 0.40 0.82 0.2],'Color','w','XColor','k','YColor','k'); grid on;
ax3 = axes('Parent',P_blue,'Position',[0.12 0.08 0.82 0.2],'Color','w','XColor','k','YColor','k'); grid on;

% Initial simulation call
updateSim();

function updateSim(~,~)
    % UI Handles
    hE  = findobj('Tag','in_E'); hUs = findobj('Tag','in_Us');
    hDU = findobj('Tag','in_DU'); hIs = findobj('Tag','in_Is');
    hf  = findobj('Tag','in_f');
    
    % Read input values
    E = str2double(get(hE,'String')); Us = str2double(get(hUs,'String'));
    DU = str2double(get(hDU,'String')); Is = str2double(get(hIs,'String'));
    f = str2double(get(hf,'String'));
    
    if any(isnan([E Us DU Is f])), return; end
    
    % --- Calculations for Buck-Boost topology ---
    D = Us / (E + Us);          % Duty cycle
    R = Us / Is;                % Load resistance
    T = 1/f;                    % Switching period
    
    % Average inductor current based on energy conservation: E*In = Us*Is
    % In Buck-Boost: IL_avg = Is / (1-D)
    IL_avg = Is / (1 - D);
    
    % Minimum inductance (L_min) for Continuous Conduction Mode (CCM)
    L_min = (E * D) / (2 * IL_avg * f);
    L = L_min * 2;              % Selecting an inductor larger than L_min
    
    % Inductor current ripple
    delta_iL = (E * D) / (L * f);
    Imax = IL_avg + delta_iL/2;
    Imin = IL_avg - delta_iL/2;
    
    % Capacitance calculation based on allowed voltage ripple (Delta U)
    C = (Is * D) / (f * DU);
    
    % --- UPDATE INTERFACE TEXT ---
    set(findobj('Tag','out_Imax'),'String',num2str(Imax,'%.2f'));
    set(findobj('Tag','out_Imin'),'String',num2str(Imin,'%.2f'));
    set(findobj('Tag','out_Lmin'),'String',num2str(L_min,'%.2e'));
    set(findobj('Tag','out_L'),'String',num2str(L,'%.2e'));
    set(findobj('Tag','out_C'),'String',num2str(C,'%.2e'));
    set(findobj('Tag','out_R'),'String',num2str(R,'%.2f'));
    set(findobj('Tag','out_D'),'String',num2str(D,'%.3f'));
    
    % --- SIMULATION PLOTS ---
    t = linspace(0, 3*T, 1000); % Plot 3 switching cycles
    iL_plot = zeros(size(t));
    uL_plot = zeros(size(t));
    
    for k = 1:length(t)
        t_cycle = mod(t(k), T);
        if t_cycle < D*T
            uL_plot(k) = E;
            iL_plot(k) = Imin + (E/L)*t_cycle;
        else
            uL_plot(k) = -Us;
            iL_plot(k) = Imax - (Us/L)*(t_cycle - D*T);
        end
    end
    
    % Output voltage (Capacitor/Load voltage with ripple)
    u_plot = Us + (DU/2) * sawtooth(2*pi*f*t, D);
    
    % Instantaneous power on the inductor
    p_plot = uL_plot .* iL_plot;
    
    % Get correct axis handles
    all_axes = findobj(gcf, 'Type', 'axes');
    
    % Plot 1: Inductor Current iL [A] - RED
    plot(all_axes(3), t, iL_plot, 'r', 'LineWidth', 1.5);
    ylabel(all_axes(3), 'iL [A]', 'Color', 'k'); grid(all_axes(3), 'on');
    set(all_axes(3), 'Color', 'w', 'XColor', 'k', 'YColor', 'k');
    
    % Plot 2: Output Voltage Us [V] - BLUE
    plot(all_axes(2), t, u_plot, 'b', 'LineWidth', 1.5);
    ylabel(all_axes(2), 'u_s [V]', 'Color', 'k'); grid(all_axes(2), 'on');
    set(all_axes(2), 'Color', 'w', 'XColor', 'k', 'YColor', 'k');
    
    % Plot 3: Inductor Power PL [W] - BLACK
    plot(all_axes(1), t, p_plot, 'k', 'LineWidth', 1.5);
    ylabel(all_axes(1), 'P_L [W]', 'Color', 'k'); xlabel(all_axes(1), 't [s]', 'Color', 'k');
    grid(all_axes(1), 'on');
    set(all_axes(1), 'Color', 'w', 'XColor', 'k', 'YColor', 'k');
end