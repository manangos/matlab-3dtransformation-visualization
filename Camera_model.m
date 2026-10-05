%% αρχειο
TR = stlread('man_small.stl');

%κορυφες και σημεια
V = TR.Points;           % συντεταγμενες
F = TR.ConnectivityList; % δεικτες κορυφων τριγωνων

%% σημεια
fprintf('πληθος σημειων: %d\n', size(V, 1));
fprintf('πληθος τριγωνων: %d\n', size(F, 1));

% 3Δ
figure;
patch('Vertices', V, 'Faces', F, 'FaceColor', 'green', 'EdgeColor', 'k');
axis equal;  
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3Δ μοντελο');

view(3); 
grid on;

%% διαστασεις και μετατοπιση
width = max(V(:,1)) - min(V(:,1));
offset = width * (1.2);
depth = max(V(:,2)) - min(V(:,2));
dist = depth * 1.2;
dx = width * 1.2;  
dy = depth * 1.2; 

%% 3 φιγουρες
V2 = V + [offset, dist, 0];
V3 = V + [2 * offset, 2 * dist, 0];
V4 = V + [3 * offset, 3 * dist, 0];

%πινακας
V_total = [V; V2; V3; V4];

%% δεικτες προσωπων
n = size(V, 1); % κορυφες
F_total = [F; F + n; F + 2*n; F + 3*n];

% οπτικοποιηση σχηματος 2
figure(2);
patch('Faces', F_total, 'Vertices', V_total, 'FaceColor', 'green', 'EdgeColor', 'k');
axis equal; view(3); grid on;
title('διαταξη');

%% πινακας περιστροφης
R = [0 -1 0; 0 0 -1; 1 0 0];
camera_pos = [-2; 0.8; 0];
V_rotated = -R * camera_pos;
Pextr = [R, V_rotated; 0 0 0 1];

disp('πινακας Pextr:');
disp(Pextr);
%% 
R = [0 -1 0; 0 0 -1; 1 0 0];
camera_pos = [-2; 0.8; 0];
t = -R * camera_pos; % μεταθεση
Pextr = [R, t; 0 0 0 1];

disp('πινακας Pextr:');
disp(Pextr);

%% μετατροπη σε 4χΝ
D = [V_total'; ones(1, size(V_total, 1))];
D_prime = Pextr * D; 

x_prime = D_prime(1, :);
y_prime = D_prime(2, :);
z_prime = D_prime(3, :);

%%
u = x_prime ./ z_prime;
v = y_prime ./ z_prime;

%%2Δ
figure(3); 
patch('Vertices', [u', v'], 'Faces', F_total,'FaceColor', 'green', 'EdgeColor', 'k', 'LineWidth', 0.1);
axis equal; 
axis tight; 
grid on;
xlabel('u (Image X)');
ylabel('v (Image Y)');
title('2D Perspective Projection of 4 Figures');