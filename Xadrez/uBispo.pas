unit uBispo;

interface

uses
  uPeca, uITabuleiro, uCor, uPosicao;

type
  TBispo = class(TPeca)
  public
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor); overload;
    procedure SalvarMovimentosPossiveis; override;
  end;

implementation

{ TBispo }

constructor TBispo.Create(aTabuleiro: ITabuleiro; aCor: TCor);
begin
  inherited Create(aTabuleiro, aCor);
  NomeDaPeca := 'Bispo';
end;

procedure TBispo.SalvarMovimentosPossiveis;
var
  posicaoAux: IPosicao;
begin
  inherited;
  posicaoAux := TPosicao.Create;

  {$REGION 'Movimentos para esquerda acima'}
  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna - 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.DefinirValores(posicaoAux.Linha + 1, posicaoAux.Coluna - 1);
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para direita acima'}
  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna + 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.DefinirValores(posicaoAux.Linha + 1, posicaoAux.Coluna + 1);
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para esquerda abaixo'}
  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna - 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.DefinirValores(posicaoAux.Linha - 1, posicaoAux.Coluna - 1);
  end;
  {$ENDREGION}

  {$REGION 'Movimentos para esquerda acima'}
  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna + 1);
  while (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) do
  begin
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
    if ((Tabuleiro.GetPeca(posicaoAux) <> nil) and (Tabuleiro.GetPeca(posicaoAux).Cor <> Cor)) then
      Break;
    posicaoAux.DefinirValores(posicaoAux.Linha - 1, posicaoAux.Coluna + 1);
  end;
  {$ENDREGION}
end;

end.
