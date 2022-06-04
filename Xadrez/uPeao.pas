unit uPeao;

interface

uses
  uPeca, uITabuleiro, uCor, uPosicao, uIPartida;

type
  TPeao = class(TPeca)
  private
    FPartida: IPartida;
    function ExisteAdversario(aPosicao: IPosicao): Boolean;
    function Livre(aPosicao: IPosicao): Boolean;
  public
    property Partida: IPartida read FPartida write FPartida;
    constructor Create(aTabuleiro: ITabuleiro; aCor: TCor; aPartida: IPartida; aQuantidadeMovimento: Integer = 0); reintroduce;
    procedure SalvarMovimentosPossiveis; override;
  end;

implementation

{ TPeao }

constructor TPeao.Create(aTabuleiro: ITabuleiro; aCor: TCor; aPartida: IPartida; aQuantidadeMovimento: Integer = 0);
begin
  inherited Create(aTabuleiro, aCor, aQuantidadeMovimento);
  NomeDaPeca := 'Peão';
  FPartida   := aPartida;
end;

function TPeao.ExisteAdversario(aPosicao: IPosicao): Boolean;
begin
  Result := (Tabuleiro.GetPeca(aPosicao) <> nil) and (Tabuleiro.GetPeca(aPosicao).Cor <> Cor);
end;

function TPeao.Livre(aPosicao: IPosicao): Boolean;
begin
  Result := (Tabuleiro.GetPeca(aPosicao) = nil);
end;

procedure TPeao.SalvarMovimentosPossiveis;
var
  posicaoAux: IPosicao;
begin
  inherited;
  posicaoAux := TPosicao.Create;

  {$REGION 'Todos movimentos'}
  if Cor = Branca then
  begin
    posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and Livre(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha - 2, Posicao.Coluna);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and Livre(posicaoAux) and (QuantidadeMovimento = 0)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna - 1);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and ExisteAdversario(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha - 1, Posicao.Coluna + 1);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and ExisteAdversario(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    {$REGION 'en Passant'}
    if Posicao.Linha = 3 then
    begin
      posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna - 1);
      if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna)) and (ExisteAdversario(posicaoAux)) and (Tabuleiro.GetPeca(posicaoAux) = FPartida.VulneravelEnpassant) then
        MovimentosPossiveis[posicaoAux.Linha - 1, posicaoAux.Coluna] := True;

      posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna + 1);
      if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna)) and (ExisteAdversario(posicaoAux)) and (Tabuleiro.GetPeca(posicaoAux) = FPartida.VulneravelEnpassant) then
        MovimentosPossiveis[posicaoAux.Linha - 1, posicaoAux.Coluna] := True;
    end;
    {$ENDREGION}
  end
  else
  begin
    posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and Livre(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha + 2, Posicao.Coluna);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and Livre(posicaoAux) and (QuantidadeMovimento = 0)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna - 1);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and ExisteAdversario(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    posicaoAux.DefinirValores(Posicao.Linha + 1, Posicao.Coluna + 1);
    if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna) and ExisteAdversario(posicaoAux)) then
      MovimentosPossiveis[posicaoAux.Linha, posicaoAux.Coluna] := True;

    {$REGION 'en Passant'}
    if Posicao.Linha = 4 then
    begin
      posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna - 1);
      if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna)) and (ExisteAdversario(posicaoAux)) and (Tabuleiro.GetPeca(posicaoAux) = FPartida.VulneravelEnpassant) then
        MovimentosPossiveis[posicaoAux.Linha + 1, posicaoAux.Coluna] := True;

      posicaoAux.DefinirValores(Posicao.Linha, Posicao.Coluna + 1);
      if (Tabuleiro.PosicaoValida(posicaoAux.Linha, posicaoAux.Coluna)) and (ExisteAdversario(posicaoAux)) and (Tabuleiro.GetPeca(posicaoAux) = FPartida.VulneravelEnpassant) then
        MovimentosPossiveis[posicaoAux.Linha + 1, posicaoAux.Coluna] := True;
    end;
    {$ENDREGION}
  end;
  {$ENDREGION}
end;

end.
