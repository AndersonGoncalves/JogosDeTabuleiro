unit uTela;

interface

uses
  System.SysUtils, winapi.windows, System.UITypes, vcl.Graphics,
  uCor, uPosicaoXadrez, uRainha, uITabuleiro, uIPartida;

type
  TTela = class
  private
    class function ImprimirPeca(aPeca: IPeca): String;
    class procedure ImprimirTabuleiro(aTabuleiro: ITabuleiro);
  public
    class procedure ImprimirPartida(aPartida: IPartida);
    class procedure ImprimirPecasCapturadas(aPartida: IPartida);
    class function LerPosicaoXadrez: IPosicao;
  end;

procedure SetColorConsole(AColor: TColor);

implementation

procedure SetColorConsole(AColor: TColor);
begin
  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
  case AColor of
    clWhite:  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE);
    clRed:    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_INTENSITY);
    clGreen:  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN or FOREGROUND_INTENSITY);
    clBlue:   SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_BLUE or FOREGROUND_INTENSITY);
    clMaroon: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN or FOREGROUND_RED or FOREGROUND_INTENSITY);
    clPurple: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED or FOREGROUND_BLUE or FOREGROUND_INTENSITY);
    clAqua: SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN or FOREGROUND_BLUE or FOREGROUND_INTENSITY);
  end;
end;

{ TTela }

class function TTela.ImprimirPeca(aPeca: IPeca): String;
begin
  if (aPeca is TRainha) then
    Result := 'D'
  else
    Result := Copy(aPeca.NomeDaPeca, 0, 1);
end;

class function TTela.LerPosicaoXadrez: IPosicao;
var
  posicao: string;
  coluna: char;
  linha: Integer;
  PosicaoXadrez: TPosicaoXadrez;
begin
  try
    ReadLn(Posicao);
    coluna        := Posicao[1];
    linha         := StrToInt(Posicao[2]);
    PosicaoXadrez := TPosicaoXadrez.Create(Coluna, linha);
    Result        := PosicaoXadrez.ToPosicao;
  finally
    if Assigned(PosicaoXadrez) then
      FreeAndNil(PosicaoXadrez);
  end;
end;

class procedure TTela.ImprimirTabuleiro(aTabuleiro: ITabuleiro);
begin
  Writeln(EmptyStr);
  SetColorConsole(clAqua);
  Writeln('  A B C D E F G H');
  SetColorConsole(clWhite);
  for var i: integer := 0 to aTabuleiro.Linhas - 1 do
  begin
    SetColorConsole(clAqua);
    write((8-i).ToString + ' ');
    SetColorConsole(clWhite);
    for var j: integer := 0 to aTabuleiro.Colunas - 1 do
    begin
      SetColorConsole(clWhite);
      if aTabuleiro.GetPeca(i, j) = nil then
        Write('- ')
      else
      begin
        if aTabuleiro.GetPeca(i, j).Cor = Branca then
          SetColorConsole(clMaroon)
        else if aTabuleiro.GetPeca(i, j).Cor = Preta then
          SetColorConsole(clRed);
        Write(ImprimirPeca(aTabuleiro.GetPeca(i, j)) + ' ');
      end;
    end;
    Write(EmptyStr);
    SetColorConsole(clAqua);
    write((8-i).ToString + ' ');
    SetColorConsole(clWhite);
    Writeln(EmptyStr);
  end;
  SetColorConsole(clAqua);
  Writeln('  A B C D E F G H');
  SetColorConsole(clWhite);
end;

class procedure TTela.ImprimirPartida(aPartida: IPartida);
begin
  TTela.ImprimirTabuleiro(aPartida.Tabuleiro);
  Writeln;
  TTela.ImprimirPecasCapturadas(aPartida);
  Writeln;
  writeln('Turno: ' + aPartida.Turno.ToString);

  if aPartida.Terminada then
  begin
    writeln('XEQUE-MATE');
    writeln('Vencedor: ' + aPartida.CorDoJogadorAtual);
  end
  else
  begin
    if aPartida.Xeque then
    begin
      writeln('XEQUE');
      Writeln;
    end;
    writeln('Aguardando jogada: ' + aPartida.CorDoJogadorAtual);
  end;
end;

class procedure TTela.ImprimirPecasCapturadas(aPartida: IPartida);

  procedure ImprimirPecas(aPecas: Array of IPeca);
  begin
    Write('[ ');
    for var i: integer := 0 to Length(aPecas) - 1 do
    begin
      if aPecas[i] <> nil then
        Write(ImprimirPeca(aPecas[i]) + ' ');
    end;
    Write(']');
  end;

begin
  SetColorConsole(clWhite);
  Writeln('PEÇAS CAPTURADAS:');
  Write('Brancas: ');
  SetColorConsole(clMaroon);
  ImprimirPecas(aPartida.BrancasCapturadas);
  Writeln;
  SetColorConsole(clWhite);
  Write('Pretas.: ');
  SetColorConsole(clRed);
  ImprimirPecas(aPartida.PretasCapturadas);
  SetColorConsole(clWhite);
  Writeln;
end;

end.
