unit uCavalo;

interface

uses
  uPeca, uITabuleiro, uCor, uPosicao;

type
  TCavalo = class(TPeca)
  public
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor); overload;
    procedure SalvarMovimentosPossiveis; override;
  end;

implementation

{ TCavalo }

constructor TCavalo.Create(aTabuleiro: ITabuleiro; aCor: TCor);
begin
  inherited Create(aTabuleiro, aCor);
  NomeDaPeca := 'Cavalo';
end;

procedure TCavalo.SalvarMovimentosPossiveis;
var
  posicaoAux: IPosicao;
begin
  inherited;
  posicaoAux := TPosicao.Create;

  {$REGION 'Todos movimentos'}
  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna - 2);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha - 2, Posicao.Coluna - 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha - 2, Posicao.Coluna + 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna + 2);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna + 2);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 2, Posicao.Coluna + 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 2, Posicao.Coluna - 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna - 2);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
  {$ENDREGION}
end;

end.
