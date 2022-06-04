program Xadrez.Teste;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
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
  uXadrezException in '..\uXadrezException.pas',
  TestuPartida in 'TestuPartida.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True; //DebugHook <> 0;
  DUnitTestRunner.RunRegisteredTests;
end.

