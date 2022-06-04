unit uPosicaoXadrez;

interface

uses
  System.SysUtils, uITabuleiro, uPosicao;

type
  TPosicaoXadrez = class
  private
    FLinha : Integer;
    FColuna: char;
  public
    property Linha : Integer read FLinha  write FLinha;
    property Coluna: char    read FColuna write FColuna;
    constructor Create(aColuna: char; aLinha: Integer); overload;
    procedure DefinirValores(aColuna: char; aLinha: Integer);
    function ToPosicao: IPosicao;
  end;

implementation

{ TPosisaoXadrez }

constructor TPosicaoXadrez.Create(aColuna: char; aLinha: Integer);
begin
  FColuna := aColuna;
  FLinha  := aLinha;
end;

procedure TPosicaoXadrez.DefinirValores(aColuna: char; aLinha: Integer);
begin
  FColuna := aColuna;
  FLinha  := aLinha;
end;

function TPosicaoXadrez.ToPosicao: IPosicao;

  function ConverterCaracter(aColuna: string): Integer;
  begin
    Result := 0;
    if SameText(aColuna, 'A') then
      Result := 1
    else if SameText(aColuna, 'B') then
      Result := 2
    else if SameText(aColuna, 'C') then
      Result := 3
    else if SameText(aColuna, 'D') then
      Result := 4
    else if SameText(aColuna, 'E') then
      Result := 5
    else if SameText(aColuna, 'F') then
      Result := 6
    else if SameText(aColuna, 'G') then
      Result := 7
    else if SameText(aColuna, 'H') then
      Result := 8;
  end;

begin
  Result := TPosicao.Create(8 - FLinha, (ConverterCaracter(FColuna) - 1));
end;

end.
