f = @(x,l) l*x^2 + (1-l)*(x-2)^2;

gy1 = @(x) (x-2)^2;
gy2 = @(x) x^2;


n=100;            %% Numero de partiulas
momentum = 0.7;   %% Momento de inercia
lambda1 = 1;
lambda2 = 1;
max_cont = 100;
cont = 0;

%% limites da funcao
l = 10;    %% +- 10 em x
h = 10;    %% +- 10 em Y



gama = 0;
while gama <= 1

  %% Gera as particulas
  %% As particulas sao montadas na matriz da seguinte forma
  %% [posicao X, lbest X, velocidade X]
  p = [];

  for a=1:n
    p(a,1) = -l + rand*2*l;
    p(a,2) = p(a,1);
    p(a,3) = 0;
  end

  %% Encontra o melhor ponto inicial
  gbest = [0,10000];
  for i=1:n
      if f(p(i,1),gama) < gbest(2)
        gbest(1) = p(i,1);
        gbest(2) = f(p(i,1),gama);
      end  
  end

  while cont < max_cont
    cont = cont+1;
    %%  calcula a proxima posicao e velocidade de cada particula
    for a=1:n
      aux = [];
      %% Proxima posicao
      aux(1) = p(a,1) + p(a,3);   %% X

      if aux(1) > l
        aux(1) = l;
      end
      
      if aux(1) < -l
        aux(1) = -l;
      end
      
      %% Proxima velocidade
      aux(2) = momentum*p(a,3) + lambda1*rand*(p(a,2) - p(a,1)) + lambda2*rand*(gbest(1) - p(a,1));
      
      p(a,1) = aux(1);
      p(a,3) = aux(2);
      
      %% Verifica se ha um novo local_best
      if f(aux(1),gama) < f(p(a,2),gama)
        p(a,2) = aux(1);
      end
    end
    
    %% Verifica se ha um novo global_best 
    for i=1:n
      if f(p(i,1),gama) < gbest(2)
        gbest(1) = p(i,1);
        gbest(2) = f(p(i,1),gama);
        cont = 0;
      end  
    end
  end
  
  X = gbest(1);

  y1 = gy1(X);
  y2 = gy2(X);
  
  plot(y1,y2,'*');
  hold on;  
  
  gama = gama + 0.1;
end