unit uTorre;

interface

uses
  uPeca, uITabuleiro, uCor, uPosicao;

type
  TTorre = class(TPeca)
  public
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor); overload;
    procedure SalvarMovimentosPossiveis; override;
  end;

implementation

{ TTorre }

constructor TTorre.Create(aTabuleiro: ITabuleiro; aCor: TCor);
begin
  inherited Create(aTabuleiro, aCor);
  NomeDaPeca := 'Torre';
end;

procedure TTorre.SalvarMovimentosPossiveis;
var
  posicaoAux: IPosicao;
begin
  inherited;
  posicaoAux := TPosicao.Create;

  {$REGION 'Movimentos para esquerda'}
  posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna - 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.Coluna := posicaoAux.Coluna - 1;
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para direita'}
  posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna + 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.Coluna := posicaoAux.Coluna + 1;
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para cima'}
  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.Linha := posicaoAux.Linha - 1;
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para baixo'}
  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.Linha := posicaoAux.Linha + 1;
  end;
  {$ENDREGION}
end;

end.
