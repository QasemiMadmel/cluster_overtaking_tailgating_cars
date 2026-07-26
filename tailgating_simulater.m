clear;
clc;
close all;

%% ================================================================
%  PARAMETER
%  Alle Geschwindigkeiten werden in m/s angegeben.
%  Die Bremsbeschleunigungen werden als positive Werte angegeben.
%  ================================================================

% Fahrrad
vFahrradStart = 30/3.6;       % Anfangsgeschwindigkeit [m/s]                (case 1; 30/3.6)(case 2: 30/3.6)(case 3: 30/3.6)
vFahrradEnde  = 15/3.6;       % Endgeschwindigkeit [m/s]                    (case 1; 15/3.6)(case 2: 15/3.6)(case 3: 0)
aFahrrad      = 2.08;       % Bremsverzögerung [m/s^2] (15 km/h in 1 s)     (case 1: 2.08)  (case 2: 4.16)  (case 3: 4.16)

% Auto
vAutoStart = 30/3.6;           % Anfangsgeschwindigkeit [m/s]
vAutoEnde  = 015/3.6;           % Endgeschwindigkeit [m/s]
aAuto      = 0.45*9.81;            % Bremsverzögerung [m/s^2] moderate bremsung  (always the same!)
disp(aAuto)
% Fahrer und Abstand
reaktionszeit = 1.0;         % Reaktionszeit des Autofahrers [s]
startabstand  = 5.0;         % Anfangsabstand zwischen Auto und Fahrrad [m]

% Simulation
simulationszeit = 3;         % Gesamte Simulationszeit [s]
dt = 0.01;                   % Zeitschritt [s]

% Animation aktivieren:
animationAktiv = false;


%% ================================================================
%  EINGABEN PRÜFEN
%  ================================================================

if vFahrradEnde > vFahrradStart
    error('Die Endgeschwindigkeit des Fahrrads darf nicht größer als die Startgeschwindigkeit sein.');
end

if vAutoEnde > vAutoStart
    error('Die Endgeschwindigkeit des Autos darf nicht größer als die Startgeschwindigkeit sein.');
end

if aFahrrad <= 0 || aAuto <= 0
    error('Die Bremsverzögerungen müssen größer als null sein.');
end

if reaktionszeit < 0
    error('Die Reaktionszeit darf nicht negativ sein.');
end


%% ================================================================
%  ZEITVEKTOR
%  ================================================================

t = 0:dt:simulationszeit;


%% ================================================================
%  GESCHWINDIGKEIT DES FAHRRADS
%
%  Das Fahrrad beginnt bei t = 0 sofort zu bremsen.
%  ================================================================

vFahrrad = vFahrradStart - aFahrrad .* t;

% Endgeschwindigkeit nicht unterschreiten
vFahrrad(vFahrrad < vFahrradEnde) = vFahrradEnde; %%%%%%%%%%


%% ================================================================
%  GESCHWINDIGKEIT DES AUTOS
%
%  Während der Reaktionszeit fährt das Auto unverändert weiter.
%  Danach beginnt das Auto zu bremsen.
%  ================================================================

vAuto = zeros(size(t));

for i = 1:length(t)

    if t(i) < reaktionszeit

        % Fahrer hat noch nicht reagiert
        vAuto(i) = vAutoStart;

    else

        % Zeit seit Beginn der Bremsung
        bremszeitAuto = t(i) - reaktionszeit;

        vAuto(i) = vAutoStart - aAuto * bremszeitAuto;

        % Endgeschwindigkeit nicht unterschreiten
        if vAuto(i) < vAutoEnde
            vAuto(i) = vAutoEnde;
        end
    end
end


%% ================================================================
%  ZURÜCKGELEGTE STRECKEN
%
%  Die Strecke wird durch Integration der Geschwindigkeit berechnet.
%  ================================================================

streckeFahrrad = cumtrapz(t, vFahrrad);
streckeAuto = cumtrapz(t, vAuto);


%% ================================================================
%  POSITIONEN
%
%  Das Auto startet bei x = 0.
%  Das Fahrrad startet um den Startabstand weiter vorne.
%  ================================================================
positionAuto = streckeAuto;

positionFahrrad = startabstand + streckeFahrrad;


%% ================================================================
%  ABSTAND ZWISCHEN AUTO UND FAHRRAD
%  ================================================================

abstand = positionFahrrad - positionAuto;


%% ================================================================
%  MINIMALER ABSTAND
%  ================================================================

[minimalerAbstand, indexMinimum] = min(abstand);

zeitMinimum = t(indexMinimum);


%% ================================================================
%  ERFORDERLICHER ANFANGSABSTAND
%
%  Das Auto holt gegenüber dem Fahrrad folgende Strecke auf:
%
%  relativeAufholstrecke = Strecke Auto - Strecke Fahrrad
%
%  Der größte Wert entspricht dem mindestens notwendigen Abstand.
%  ================================================================

relativeAufholstrecke = streckeAuto - streckeFahrrad;

erforderlicherAbstandKollision = max(relativeAufholstrecke);

% Negative Werte sind nicht sinnvoll
if erforderlicherAbstandKollision < 0
    erforderlicherAbstandKollision = 0;
end

erforderlicherAbstandSicher = ...
    erforderlicherAbstandKollision ;

fprintf('notwendiger abstand auf basis von der Geschwindigkeiten:', erforderlicherAbstandSicher );
%% ================================================================
%  KOLLISION PRÜFEN
%  ================================================================

indexKollision = find(abstand <= 0, 1);



%% ================================================================
%  ERGEBNISSE IM COMMAND WINDOW
%  ================================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('       TAILGATING-SIMULATION\n');
fprintf('============================================\n\n');

fprintf('Eingestellter Anfangsabstand:      %.2f m\n', ...
    startabstand);

fprintf('Minimaler Abstand der Simulation:  %.2f m\n', ...
    minimalerAbstand);

fprintf('Zeitpunkt des kleinsten Abstands:  %.2f s\n\n', ...
    zeitMinimum);

fprintf('Mindestabstand ohne Kollision:     %.2f m\n', ...
    erforderlicherAbstandKollision);

fprintf('Mindestabstand mit %.2f m:  m\n\n', ...
    erforderlicherAbstandSicher);


if ~isempty(indexKollision)

    fprintf('ERGEBNIS: KOLLISION bei t = %.2f s\n', ...
        t(indexKollision));

end


if vAutoEnde > vFahrradEnde

    fprintf('\nACHTUNG:\n');

    fprintf(['Das Auto fährt nach dem Bremsen schneller als das Fahrrad.\n', ...
        'Der Abstand wird deshalb langfristig weiter kleiner.\n']);
end


%% ================================================================
%  PLOT 1: GESCHWINDIGKEIT
%  ================================================================

figure('Name', 'Tailgating-Simulation', ...
       'Position', [100 100 1000 800]);

subplot(3,1,1);

plot(t, vFahrrad, ...
    'LineWidth', 2);

hold on;

plot(t, vAuto, ...
    'LineWidth', 2);

grid on;

xlabel('time [s]');
ylabel('velocity [m/s]');

title('velocity profile for case 1: a_{cyclist} = -2.08 a_{vehicle}= -4.141');

legend('cyclist', 'vehicle', ...
    'Location', 'best');


%% ================================================================
%  PLOT 2: POSITIONEN
%  ================================================================

subplot(3,1,2);

plot(t, positionFahrrad, ...
    'LineWidth', 2);

hold on;

plot(t, positionAuto, ...
    'LineWidth', 2);

grid on;

xlabel('time [s]');
ylabel('position [m]');

title('positions of both participants');

legend('cyclist', 'vehicle', ...
    'Location', 'best');


%% ================================================================
%  PLOT 3: ABSTAND
%  ================================================================

subplot(3,1,3);

plot(t, abstand, ...
    'LineWidth', 2);

hold on;

plot(zeitMinimum, minimalerAbstand, ...
    'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

grid on;

xlabel('time [s]');
ylabel('distance [m]');
ylim([0,max(abstand)]);
title('distance between the vehicle and the cyclist (case 1)');

legend('distace', ...
       'Location', 'best');


%% ================================================================
%  ANIMATION
%  ================================================================

if animationAktiv

    figure('Name', 'Animation der Tailgating-Situation', ...
           'Position', [150 150 1100 350]);

    animationsschritt = round(0.05 / dt);

    if animationsschritt < 1
        animationsschritt = 1;
    end

    for i = 1:animationsschritt:length(t)

        clf;

        hold on;

        % Straßenbegrenzungen
        plot([-10, max(positionFahrrad) + 10], ...
             [-1.5, -1.5], ...
             'k-', ...
             'LineWidth', 1.5);

        plot([-10, max(positionFahrrad) + 10], ...
             [1.5, 1.5], ...
             'k-', ...
             'LineWidth', 1.5);

        % Straßenmitte
        plot([-10, max(positionFahrrad) + 10], ...
             [0, 0], ...
             'k--');

        % Auto
        plot(positionAuto(i), -0.4, ...
            's', ...
            'MarkerSize', 18, ...
            'LineWidth', 2);

        % Fahrrad
        plot(positionFahrrad(i), 0.4, ...
            'd', ...
            'MarkerSize', 14, ...
            'LineWidth', 2);

        % Abstandslinie
        plot([positionAuto(i), positionFahrrad(i)], ...
             [0.1, 0.1], ...
             'LineWidth', 2);

        text(positionAuto(i), -0.9, ...
            'vehicle', ...
            'HorizontalAlignment', 'center');

        text(positionFahrrad(i), 0.9, ...
            'bicycle', ...
            'HorizontalAlignment', 'center');

        text((positionAuto(i) + positionFahrrad(i))/2, ...
             0.25, ...
             sprintf('distance = %.2f m', abstand(i)), ...
             'HorizontalAlignment', 'center', ...
             'FontWeight', 'bold');

        title(sprintf( ...
            'time = %.2f s | distance = %.2f m', ...
            t(i), abstand(i)));

        xlabel('Position [m]');

        ylim([-2 2]);

        xlim([positionAuto(i) - 8, ...
              positionFahrrad(i) + 8]);

        yticks([]);

        grid on;

        drawnow;

        pause(0.02);
    end
end