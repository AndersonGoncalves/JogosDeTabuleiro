unit uRei;

interface

uses
  uPeca, uITabuleiro, uCor, uPosicao, uTorre;

type
  TRei = class(TPeca)
  private
    FPartidaEmXeque: Boolean;
    function TesteTorreParaRoque(aPosicao: IPosicao): Boolean;
  public
    property PartidaEmXeque: Boolean read FPartidaEmXeque write FPartidaEmXeque;
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor; aPartidaEmXeque: Boolean); overload;
    procedure SalvarMovimentosPossiveis; override;
  end;

implementation

{ TRei }

function TRei.TesteTorreParaRoque(aPosicao: IPosicao): Boolean;
var
  Peca: IPeca;
begin
  Result := False;
  peca   := Tabuleiro.GetPeca(aPosicao);
  if (Peca <> nil) then
    Result := (Peca is TTorre) and (Peca.Cor = Cor) and (Peca.QuantidadeMovimento = 0);
end;

constructor TRei.Create(aTabuleiro: ITabuleiro; aCor: TCor; aPartidaEmXeque: Boolean);
begin
  inherited Create(aTabuleiro, aCor);
  NomeDaPeca      := 'Rei';
  FPartidaEmXeque := aPartidaEmXeque;
end;

procedure TRei.SalvarMovimentosPossiveis;
var
  posicaoAux: IPosicao;
  posicaoTorre1, posicaoTorre2, p1, p2, p3: IPosicao;
begin
  inherited;
  posicaoAux := TPosicao.Create;

  {$REGION 'Movimentos uma linha acima'}
  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna - 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna + 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
  {$ENDREGION}

  {$REGION 'Movimentos na mesma linha'}
  posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna - 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna + 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
  {$ENDREGION}

  {$REGION 'Movimentos uma linha abaixo'}
  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna - 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

  posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna + 1);
  if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and PodeMover(posicaoAux)) then
    MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;
  {$ENDREGION}

  {$REGION 'Roque'}
  if (QuantidadeMovimento = 0) and (not FPartidaEmXeque) then
  begin
    //Roque pequeno
    posicaoTorre1 := TPosicao.Create(Posicao.Linha, Posicao.Coluna + 3);
    if TesteTorreParaRoque(posicaoTorre1) then
    begin
      p1 := TPosicao.Create(Posicao.Linha, Posicao.Coluna + 1);
      p2 := TPosicao.Create(Posicao.Linha, Posicao.Coluna + 2);
      if (Tabuleiro.GetPeca(p1) = nil) and (Tabuleiro.GetPeca(p2) = nil) then
        MovimentosPossiveis[Posicao.Linha, Posicao.Coluna + 2] := True;
    end;
    //Roque grande
    posicaoTorre2 := TPosicao.Create(Posicao.Linha, Posicao.Coluna - 4);
    if TesteTorreParaRoque(posicaoTorre2) then
    begin
      p1 := TPosicao.Create(Posicao.Linha, Posicao.Coluna - 1);
      p2 := TPosicao.Create(Posicao.Linha, Posicao.Coluna - 2);
      p3 := TPosicao.Create(Posicao.Linha, Posicao.Coluna - 3);
      if (Tabuleiro.GetPeca(p1) = nil) and (Tabuleiro.GetPeca(p2) = nil) and (Tabuleiro.GetPeca(p3) = nil) then
        MovimentosPossiveis[Posicao.Linha, Posicao.Coluna - 2] := True;
    end;
  end;
  {$ENDREGION}
end;

end.
