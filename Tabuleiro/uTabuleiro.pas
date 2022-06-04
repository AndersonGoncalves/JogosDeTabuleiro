unit uTabuleiro;

interface

uses
  uITabuleiro, uSingleton, uTabuleiroException;

type
  TTabuleiro = class(TInterfacedObject, ITabuleiro)
  private
    FLinhas : Integer;
    FColunas: Integer;
    FPecas  : IArrayOfArrayPecas;
    function ExistePeca(aLinha, aColuna: Integer): Boolean;
  protected
    function GetLinhas: Integer;
    procedure SetLinhas(const Value: Integer);
    function GetColunas: Integer;
    procedure SetColunas(const Value: Integer);
    function GetPecas: IArrayOfArrayPecas;
    procedure SetPecas(const Value: IArrayOfArrayPecas);
  public
    property Linhas : Integer            read GetLinhas  write SetLinhas;
    property Colunas: Integer            read GetColunas write SetColunas;
    property Pecas  : IArrayOfArrayPecas read GetPecas   write SetPecas;
    constructor Create(aLinhas, aColunas: Integer); overload;
    function GetPeca(aLinha, aColuna: Integer): IPeca; overload;
    function GetPeca(aPosicao: IPosicao): IPeca; overload;
    function PosicaoValida(aLinha, aColuna: Integer): Boolean;
    function RetirarPeca(aLinha, aColuna: Integer): IPeca;
    procedure ColocarPeca(aPeca: IPeca); overload;
    procedure ColocarPeca(aPeca: IPeca; aPosicao: IPosicao); overload;
    procedure DefinirValores(aLinhas, aColunas: Integer);
    procedure Release;
  end;

  TTabuleiroSingleton = class(TSingleton<TTabuleiro>)
  public
    class function GetInstance(aLinha, aColuna: Integer): TTabuleiro; overload;
  end;

implementation

{ TTabuleiro }

constructor TTabuleiro.Create(aLinhas, aColunas: Integer);
begin
  FLinhas  := aLinhas;
  FColunas := aColunas;
  SetLength(FPecas, FLinhas, FColunas);
end;

procedure TTabuleiro.DefinirValores(aLinhas, aColunas: Integer);
begin
  FLinhas  := aLinhas;
  FColunas := aColunas;
end;

function TTabuleiro.GetPeca(aLinha, aColuna: Integer): IPeca;
begin
  Result := FPecas[aLinha, aColuna];
end;

function TTabuleiro.GetColunas: Integer;
begin
  Result := FColunas;
end;

function TTabuleiro.GetLinhas: Integer;
begin
  Result := FLinhas
end;

function TTabuleiro.PosicaoValida(aLinha, aColuna: Integer): Boolean;
begin
  Result := (aLinha >= 0)      and
            (aLinha < FLinhas) and
            (aColuna >= 0)     and
            (aColuna < FColunas);
end;

function TTabuleiro.ExistePeca(aLinha, aColuna: Integer): Boolean;
begin
  if not PosicaoValida(aLinha, aColuna) then
    Raise TabuleiroException.Create('Posição inválida')
  else
    Result := GetPeca(aLinha, aColuna) <> nil;
end;

function TTabuleiro.GetPeca(aPosicao: IPosicao): IPeca;
begin
  Result := FPecas[aPosicao.Linha, aPosicao.Coluna];
end;

function TTabuleiro.GetPecas: IArrayOfArrayPecas;
begin
  Result := FPecas;
end;

procedure TTabuleiro.Release;
begin
  for var i: integer := 0 to Linhas - 1 do
  begin
    for var j: integer := 0 to Colunas - 1 do
    begin
      if FPecas <> nil then
      begin
        if Assigned(FPecas[i, j]) then
          FPecas[i, j] := nil;
      end;
    end;
  end;

  if Assigned(FPecas) then
    FPecas := nil;
end;

function TTabuleiro.RetirarPeca(aLinha, aColuna: Integer): IPeca;
var
  Peca: IPeca;
begin
  Peca := GetPeca(aLinha, aColuna);
  if Peca = nil then
    Result := nil
  else
  begin
    FPecas[aLinha, aColuna] := nil;
    Result := Peca;
  end;
end;

procedure TTabuleiro.SetColunas(const Value: Integer);
begin
  FColunas := Value;
end;

procedure TTabuleiro.SetLinhas(const Value: Integer);
begin
  FLinhas := Value;
end;

procedure TTabuleiro.SetPecas(const Value: IArrayOfArrayPecas);
begin
  FPecas := Value;
end;

procedure TTabuleiro.ColocarPeca(aPeca: IPeca);
begin
  if (ExistePeca(aPeca.Posicao.Linha, aPeca.Posicao.Coluna)) then
    Raise TabuleiroException.Create('Já existe peça nessa posição')
  else
    FPecas[aPeca.Posicao.Linha, aPeca.Posicao.Coluna] := aPeca;
end;

procedure TTabuleiro.ColocarPeca(aPeca: IPeca; aPosicao: IPosicao);
begin
  if (ExistePeca(aPosicao.Linha, aPosicao.Coluna)) then
    Raise TabuleiroException.Create('Já existe peça nessa posição')
  else
  begin
    FPecas[aPosicao.Linha, aPosicao.Coluna]         := aPeca;
    FPecas[aPosicao.Linha, aPosicao.Coluna].Posicao := aPosicao;
  end;
end;

{ TTabuleiroSingleton }

class function TTabuleiroSingleton.GetInstance(aLinha, aColuna: Integer): TTabuleiro;
begin
  if not Assigned(FInstance) then
    FInstance := TTabuleiro.Create(aLinha, aColuna);
  Result := FInstance;
end;

end.
