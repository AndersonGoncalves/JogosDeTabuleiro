unit TestuPartida;

interface

uses
  TestFramework, uRei, uCavalo, uCor, uPosicaoXadrez, uPartida, uSingleton, uPeao,
  System.SysUtils, uRainha, uPosicao, uTabuleiro, uITabuleiro, uBispo, uTorre, uIPartida,
  uXadrezException;

type
  TestTPartida = class(TTestCase)
  strict private
    FPartida: IPartida;
    procedure VerificaXequeMate;
    procedure RealizarJogada(aOrigem, aDestino: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure XequeMateDoLouco;
    procedure XequeMatePastor;
    procedure XequeMateComTorres;
    procedure XequeMateNaPrimeiraFileira;
    procedure XequeMateSubPromocao;
    procedure CapturarPeaoPretoVulneravelEnpassant;
    procedure CapturarPeaoBrancoVulneravelEnpassant;
    procedure PeaoPretoNaoEstaMaisVulneravelEnpassant;
    procedure NaoPermitirRoqueComReiEmXeque;
  end;

implementation

procedure TestTPartida.SetUp;
begin
  FPartida := TPartidaSingleton.GetInstance;
end;

procedure TestTPartida.TearDown;
begin
  FPartida.Reiniciar;
end;

procedure TestTPartida.VerificaXequeMate;
begin
  CheckTrue(FPartida.Terminada, 'Partida não terminada');
end;

procedure TestTPartida.CapturarPeaoBrancoVulneravelEnpassant;

  procedure RealizarJogadas;
  begin
    RealizarJogada('G2', 'G4');
    RealizarJogada('B7', 'B5');
    RealizarJogada('G4', 'G5');
    RealizarJogada('B5', 'B4');
    RealizarJogada('C2', 'C4');
    RealizarJogada('B4', 'C3');
  end;

begin
  RealizarJogadas;
end;

procedure TestTPartida.CapturarPeaoPretoVulneravelEnpassant;

  procedure RealizarJogadas;
  begin
    RealizarJogada('E2', 'E4');
    RealizarJogada('B8', 'C6');
    RealizarJogada('E4', 'E5');
    RealizarJogada('D7', 'D5');
    RealizarJogada('E5', 'D6');
  end;

begin
  RealizarJogadas;
end;

procedure TestTPartida.NaoPermitirRoqueComReiEmXeque;
var
  PosicaoXadrezOrigem, PosicaoXadrezDestino: TPosicaoXadrez;

  procedure ColocarPecasNoTabuleiro;
  begin
    FPartida.ColocarNovaPeca('A', 1, TTorre.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 1, TCavalo.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 1, TBispo.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('D', 1, TRainha.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('E', 1, TRei.Create(FPartida.Tabuleiro, Branca).SetMovimentos(0)); //TODO

    FPartida.ColocarNovaPeca('H', 1, TTorre.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('A', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(0));
    FPartida.ColocarNovaPeca('B', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('D', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('F', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('H', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));


    FPartida.ColocarNovaPeca('F', 6, TTorre.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));

    FPartida.ColocarNovaPeca('A', 8, TTorre.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 8, TCavalo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 8, TBispo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('D', 8, TRainha.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('E', 8, TRei.Create(FPartida.Tabuleiro, Preta).SetMovimentos(0));
    FPartida.ColocarNovaPeca('F', 8, TBispo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('G', 8, TCavalo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('A', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('D', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('E', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('F', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('G', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('H', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  end;

  procedure RealizarJogadas;
  begin
    RealizarJogada('A2', 'A4');
    RealizarJogada('F6', 'E6');
    CheckTrue(FPartida.Xeque, 'Partida não está em xeque');
  end;

begin
  FPartida.RetirarTodasPecasDoTabuleiro;
  ColocarPecasNoTabuleiro;
  RealizarJogadas;
  try
    //Verificando Rei em xeque
    PosicaoXadrezOrigem  := TPosicaoXadrez.Create('E', 1);
    PosicaoXadrezDestino := TPosicaoXadrez.Create('G', 1);
    CheckTrue(FPartida.Tabuleiro.GetPeca(PosicaoXadrezOrigem.ToPosicao).PodeMoverPara(PosicaoXadrezDestino.ToPosicao) = False, 'Não pode fazer o Roque com o Rei em xeque');
  finally
    if Assigned(PosicaoXadrezOrigem) then
      FreeAndNil(PosicaoXadrezOrigem);

    if Assigned(PosicaoXadrezDestino) then
      FreeAndNil(PosicaoXadrezDestino);
  end;
end;

procedure TestTPartida.PeaoPretoNaoEstaMaisVulneravelEnpassant;
var
  PosicaoXadrezOrigem, PosicaoXadrezDestino: TPosicaoXadrez;

  procedure RealizarJogadas;
  begin
    RealizarJogada('E2', 'E4');
    RealizarJogada('B8', 'C6');
    RealizarJogada('E4', 'E5');
    RealizarJogada('D7', 'D5');
    RealizarJogada('A2', 'A4');
    RealizarJogada('C8', 'F5');
  end;

begin
  RealizarJogadas;
  try
    //Verifica EnPassant (esquerda)
    PosicaoXadrezOrigem  := TPosicaoXadrez.Create('E', 5);
    PosicaoXadrezDestino := TPosicaoXadrez.Create('D', 6);
    CheckFalse(FPartida.Tabuleiro.GetPeca(PosicaoXadrezOrigem.ToPosicao).PodeMoverPara(PosicaoXadrezDestino.ToPosicao), 'Não pode fazer o EnPassante, pois o peão não foi a ultima peça do adversário a se movimentar');
    //Verifica próxima casa a frente
    PosicaoXadrezOrigem.DefinirValores('E', 5);
    PosicaoXadrezDestino.DefinirValores('E', 6);
    CheckTrue(FPartida.Tabuleiro.GetPeca(PosicaoXadrezOrigem.ToPosicao).PodeMoverPara(PosicaoXadrezDestino.ToPosicao), 'Movimento do peão válido');
    //Verifica casa na frente a direita
    PosicaoXadrezOrigem.DefinirValores('E', 5);
    PosicaoXadrezDestino.DefinirValores('F', 6);
    CheckFalse(FPartida.Tabuleiro.GetPeca(PosicaoXadrezOrigem.ToPosicao).PodeMoverPara(PosicaoXadrezDestino.ToPosicao), 'Movimento do peão inválido');
  finally
    if Assigned(PosicaoXadrezOrigem) then
      FreeAndNil(PosicaoXadrezOrigem);

    if Assigned(PosicaoXadrezDestino) then
      FreeAndNil(PosicaoXadrezDestino);
  end;
end;

procedure TestTPartida.RealizarJogada(aOrigem, aDestino: string);
var
  coluna: char;
  linha: Integer;
  PosicaoXadrez: TPosicaoXadrez;
  Origem: IPosicao;
  Destino: IPosicao;
begin
  PosicaoXadrez := nil;
  try
    //Definir origem
    coluna        := aOrigem[1];
    linha         := StrToInt(aOrigem[2]);
    PosicaoXadrez := TPosicaoXadrez.Create(coluna, linha);
    Origem        := PosicaoXadrez.ToPosicao;
    //Definir destino
    coluna        := aDestino[1];
    linha         := StrToInt(aDestino[2]);
    PosicaoXadrez.DefinirValores(coluna, linha);
    Destino := PosicaoXadrez.ToPosicao;
    //realiza a jogada
    FPartida.RealizarJogada(Origem, Destino);
  finally
    if Assigned(PosicaoXadrez) then
      PosicaoXadrez.Free;
  end;
end;

procedure TestTPartida.XequeMateDoLouco;

  procedure RealizarJogadas;
  begin
    RealizarJogada('F2', 'F3');
    RealizarJogada('E7', 'E5');
    RealizarJogada('G2', 'G4');
    RealizarJogada('D8', 'H4');
  end;

begin
  RealizarJogadas;
  VerificaXequeMate;
end;

procedure TestTPartida.XequeMatePastor;

  procedure RealizarJogadas;
  begin
    RealizarJogada('E2', 'E4');
    RealizarJogada('E7', 'E5');
    RealizarJogada('F1', 'C4');
    RealizarJogada('B8', 'C6');
    RealizarJogada('D1', 'H5');
    RealizarJogada('G8', 'F6');
    RealizarJogada('H5', 'F7');
  end;

begin
  RealizarJogadas;
  VerificaXequeMate;
end;

procedure TestTPartida.XequeMateComTorres;

 procedure ColocarPecasNoTabuleiro;
 begin
   FPartida.ColocarNovaPeca('E', 8, TRei.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
   FPartida.ColocarNovaPeca('D', 8, TTorre.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
   FPartida.ColocarNovaPeca('C', 7, TTorre.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
   FPartida.ColocarNovaPeca('E', 1, TRei.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
 end;

 procedure RealizarJogadas;
 begin
   RealizarJogada('E1', 'F1');
   RealizarJogada('C7', 'C2');
   RealizarJogada('F1', 'G1');
   RealizarJogada('D8', 'D1');
 end;

begin
  FPartida.RetirarTodasPecasDoTabuleiro;
  ColocarPecasNoTabuleiro;
  RealizarJogadas;
  VerificaXequeMate;
end;

procedure TestTPartida.XequeMateNaPrimeiraFileira;

  procedure ColocarPecasNoTabuleiro;
  begin
    FPartida.ColocarNovaPeca('A', 8, TTorre.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 8, TBispo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('F', 8, TRainha.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('H', 8, TRei.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('A', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('G', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('H', 7, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 6, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('F', 5, TPeao.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 3, TBispo.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('C', 3, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('H', 3, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('A', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('B', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('D', 2, TRainha.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('F', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('G', 2, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('E', 1, TTorre.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
    FPartida.ColocarNovaPeca('G', 1, TRei.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
  end;

  procedure RealizarJogadas;
  begin
    RealizarJogada('D2', 'D6');
    RealizarJogada('F8', 'D6');
    CheckTrue(FPartida.BrancasCapturadas[0] is TRainha, 'Não capturou rainha branca');
    RealizarJogada('E1', 'E8');
    RealizarJogada('D6', 'F8');
    RealizarJogada('E8', 'F8');
    CheckTrue(FPartida.PretasCapturadas[0] is TRainha, 'Não capturou rainha preta');
  end;

begin
  FPartida.RetirarTodasPecasDoTabuleiro;
  ColocarPecasNoTabuleiro;
  RealizarJogadas;
  VerificaXequeMate;
end;

procedure TestTPartida.XequeMateSubPromocao;
begin
  FPartida.RetirarTodasPecasDoTabuleiro;

  FPartida.ColocarNovaPeca('F', 7, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
  FPartida.ColocarNovaPeca('H', 7, TRei.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('E', 6, TRainha.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('D', 4, TBispo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('H', 1, TRei.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));

  RealizarJogada('F7', 'F8');
  RealizarJogada('E6', 'H3');

  VerificaXequeMate;

  //Quando implementar a promoção do peão, vai quebrar aqui
  FPartida.Reiniciar;
  FPartida.RetirarTodasPecasDoTabuleiro;

  FPartida.ColocarNovaPeca('B', 7, TPeao.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));
  FPartida.ColocarNovaPeca('H', 7, TRei.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('E', 6, TRainha.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('D', 4, TBispo.Create(FPartida.Tabuleiro, Preta).SetMovimentos(1));
  FPartida.ColocarNovaPeca('H', 1, TRei.Create(FPartida.Tabuleiro, Branca).SetMovimentos(1));

  RealizarJogada('B7', 'B8');
  RealizarJogada('E6', 'H3');

  VerificaXequeMate;
end;

initialization
  RegisterTest(TestTPartida.Suite);
end.

