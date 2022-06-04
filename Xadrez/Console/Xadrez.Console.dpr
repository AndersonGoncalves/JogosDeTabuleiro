program Xadrez.Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  uTela in 'uTela.pas',
  uSingleton in '..\..\Comum\uSingleton.pas',
  uITabuleiro in '..\..\Tabuleiro\uITabuleiro.pas',
  uIPartida in '..\uIPartida.pas',
  uCor in '..\..\Tabuleiro\uCor.pas',
  uPosicaoXadrez in '..\uPosicaoXadrez.pas',
  uTabuleiro in '..\..\Tabuleiro\uTabuleiro.pas',
  uPartida in '..\uPartida.pas',
  uPosicao in '..\..\Tabuleiro\uPosicao.pas',
  uPeca in '..\..\Tabuleiro\uPeca.pas',
  uBispo in '..\uBispo.pas',
  uCavalo in '..\uCavalo.pas',
  uPeao in '..\uPeao.pas',
  uRainha in '..\uRainha.pas',
  uRei in '..\uRei.pas',
  uTorre in '..\uTorre.pas',
  uTabuleiroException in '..\..\Tabuleiro\uTabuleiroException.pas',
  uXadrezException in '..\uXadrezException.pas';

var
  Partida: IPartida;
  posicaoOrigem, posicaoDestino: IPosicao;
begin
  ReportMemoryLeaksOnShutdown := True; //DebugHook <> 0;

  Partida := TPartidaSingleton.GetInstance;
  repeat
    try
      TTela.ImprimirPartida(Partida);

      write('Origem: ');
      posicaoOrigem := TTela.LerPosicaoXadrez;
      //Partida.Tabuleiro.GetPeca(posicaoOrigem).SalvarMovimentosPossiveis;
      //Partida.ValidarPosicaoDeOrigem(posicaoOrigem);

      write('Destino: ');
      posicaoDestino := TTela.LerPosicaoXadrez;
      //Partida.ValidarPosicaoDeDestino(posicaoOrigem, posicaoDestino);

      Partida.RealizarJogada(posicaoOrigem, posicaoDestino);

      if Partida.Terminada then
        TTela.ImprimirPartida(Partida);
    except
      on E: TabuleiroException do
      begin
        Writeln(EmptyStr);
        Writeln(E.ClassName, ': ', E.Message);
      end;

      on E: XadrezException do
      begin
        Writeln(EmptyStr);
        Writeln(E.ClassName, ': ', E.Message);
      end;

      on E: Exception do
      begin
        Writeln(EmptyStr);
        Writeln(E.ClassName, ': ', E.Message);
      end;
    end;
  until Partida.Terminada;

  ReadLn;
end.
