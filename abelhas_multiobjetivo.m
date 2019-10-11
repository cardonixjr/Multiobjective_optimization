f = @(x,l) l*x^2 + (1-l)*(x-2)^2;

g = @(x) (x-2)^2;
h = @(x) x^2;

% Limites da funcao
limite_x = 3;
limite_y = -3;

% Precisao minima do resultado
tolerancia = 0.01;

% Numero de abelhas de cada tipo
% As abelhas operarias voam para locais ao redor da colmeia (inicialmente aleatorio).
% As abelhas seguidoras tem como referencia a informacao trazida pelas abelhas operarias.
% As abelhas exploradoras voam aleatoriamente, explorando lugares distindos.
operarias = 10;
seguidoras = 10;
exploradoras = 10;

% Maxima distancia ao redor de um ponto que uma abelha explora
passo = 0.1;

pos_operarias = [];
pos_seguidoras = [];
pos_exploradoras = [];

pos_total = [];

%%%%%% Inicio otimizacao multiobjetiva %%%%%%
lambda = 0;
while lambda <= 1

  % Coloca a posicao inicial das abelhas operarias,
  % a primeiras posicoes sao aleatorias
  for a=1 : operarias 
    pos_operarias(a,1) = limite_y + rand()*(limite_x - limite_y);
    pos_total(a,1) = pos_operarias(a,1);
  end

  % Coloca a posicao inicial das abelhas exploradoras,
  % sempre aleatorio
  for b=1 : exploradoras
    pos_exploradoras(b,1) = limite_y + rand()*(limite_x - limite_y);
    pos_total(b+operarias,1) = pos_exploradoras(b,1);
  end

  cont = 0;
  melhor = [1000];
  interacoes = 0;

  while 1
    interacoes = interacoes + 1;
    cont = cont + 1;

    % Cria o vetor de probabilidades dos pontos
    prob = [];
    
    soma = 0;
    for i=1:length(pos_total);
      soma = soma + f(pos_total(i,1), lambda);
    end

    for i=1:length(pos_total);
      last_value = length(prob) + 1;
      value = length(prob) + 1 + ceil((f(pos_total(i,1), lambda)/soma)*100);
      for j=last_value : value;
        prob(j) = i;
      end
    end

    % Move as abelhas seguidoras
    for a=1:seguidoras
      % Escolhe um ponto baseado no vetor de probabilidaes  
      index = prob(randi(length(prob), 1));
      ponto = pos_total(index, :);
      
      % O novo ponto estara a um "passo" e distancia do oultro, em um angulo theta aleatorio
      theta = rand()*6.2831;
      pos_seguidoras(a,1) = ponto(1) + cos(theta)*passo;
      if pos_seguidoras(a,1) > limite_x
        pos_seguidoras(a,1) = limite_x;
      elseif pos_seguidoras(a,1) < -limite_x
        pos_seguidoras(a,1) = -limite_x;
      end
      
      pos_total(a+exploradoras+operarias,1) = pos_seguidoras(a,1);
    end
    
    % Move as abelhas exploradoras
    for b=1 : exploradoras
      pos_exploradoras(b,1) = limite_y + rand()*(limite_x - limite_y);
      pos_total(b+operarias,1) = pos_exploradoras(b,1);
    end

    
    
    % Move as abelhas operarias
    % Cria o vetor de probabilidades dos pontos
    prob = [];
    
    soma = 0;
    for i=1:length(pos_total);
      soma = soma + f(pos_total(i,1), lambda);
    end

    for i=1:length(pos_total);
      last_value = length(prob) + 1;
      value = length(prob) + 1 + ceil((f(pos_total(i,1), lambda)/soma)*100);
      for j=last_value : value;
        prob(j) = i;
      end
    end
    
    for a=1:seguidoras
      % Escolhe um ponto baseado no vetor de probabilidaes  
      index = prob(randi(length(prob), 1));
      ponto = pos_total(index, :);
      
      % O novo ponto estara a um "passo" e distancia do oultro, em um angulo theta aleatorio
      theta = rand()*6.2831;
      pos_operarias(a,1) = ponto(1) + cos(theta)*passo;
      if pos_operarias(a,1) > limite_x
        pos_operarias(a,1) = limite_x;
      elseif pos_operarias(a,1) < -limite_x
        pos_operarias(a,1) = -limite_x;
      end  
    end
      
    % ve o melor ponto
    for i=1 : length(pos_total)
      if f(pos_total(i,1),lambda) < f(melhor(1), lambda)
        melhor = pos_total(i, :);
      end  
    end
    % Condicao de parada 
    if cont > 100
      break;    
    end
    
  end
  
  X = melhor;

  y1 = g(X);
  y2 = h(X);
  
  plot(y1,y2,'*');
  hold on;
  
  lambda = lambda + 0.1;
  
end